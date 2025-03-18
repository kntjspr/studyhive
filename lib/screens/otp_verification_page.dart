import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/screens/home_page.dart';
import 'package:studyhive/services/auth_service.dart';
import 'package:studyhive/utils/constants.dart';
import 'package:studyhive/utils/exceptions.dart';
import 'dart:math' as math;

enum VerificationType { login, register }

class OtpVerificationPage extends StatefulWidget {
  final String email;
  final VerificationType type;
  final String? firstName;
  final String? lastName;

  const OtpVerificationPage({
    super.key,
    required this.email,
    required this.type,
    this.firstName,
    this.lastName,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  String? _errorMessage;

  // Timer for resend functionality
  Timer? _resendTimer;
  int _resendSeconds = 60;
  bool _canResend = false;

  // Animation controller for honeycomb
  late AnimationController _animationController;
  late Animation<Offset> _honeycombAnimation;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    // Initialize animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _honeycombAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    // Start animation
    Future.delayed(const Duration(milliseconds: 100), () {
      _animationController.forward();
    });

    // Start resend timer
    _startResendTimer();

    // Add listener to automatically focus on next field when a digit is entered
    for (int i = 0; i < 5; i++) {
      _otpControllers[i].addListener(() {
        if (_otpControllers[i].text.length == 1) {
          FocusScope.of(context).requestFocus(_otpFocusNodes[i + 1]);
        }
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes
    for (int i = 0; i < 6; i++) {
      _otpControllers[i].dispose();
      _otpFocusNodes[i].dispose();
    }

    // Dispose timer and animation controller
    _resendTimer?.cancel();
    _animationController.dispose();

    super.dispose();
  }

  // Start the resend timer
  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendSeconds = 60;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendSeconds > 0) {
          _resendSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  // Handle OTP verification
  Future<void> _verifyOtp() async {
    // Get the full OTP code
    final String otp =
        _otpControllers.map((controller) => controller.text).join('');

    // Validate OTP length
    if (otp.length != 6) {
      setState(() => _errorMessage = 'Please enter all 6 digits');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (widget.type == VerificationType.login) {
        // Complete login with OTP
        await _authService.loginComplete(token: otp);
      } else {
        // Complete registration with OTP
        await _authService.registerComplete(
          token: otp,
          firstName: widget.firstName,
          lastName: widget.lastName,
        );
      }

      if (mounted) {
        // Navigate to home page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false, // Remove all previous routes
        );
      }
    } catch (e) {
      String message = 'Invalid verification code. Please try again.';
      if (e is ApiException) {
        message = e.message;
      }
      setState(() => _errorMessage = message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Resend OTP
  Future<void> _resendOtp() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Use the new resendOtp method
      await _authService.resendOtp(
        email: widget.email,
        isLogin: widget.type == VerificationType.login,
      );

      // Clear OTP fields
      for (var controller in _otpControllers) {
        controller.clear();
      }

      // Focus on first field
      FocusScope.of(context).requestFocus(_otpFocusNodes[0]);

      // Restart timer
      _startResendTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification code resent to ${widget.email}'),
          backgroundColor: AppConstants.successColor,
        ),
      );
    } catch (e) {
      String message = 'Failed to resend verification code. Please try again.';
      if (e is ApiException) {
        message = e.message;
      }
      setState(() => _errorMessage = message);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive calculations
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    // Calculate appropriate card width for mobile
    final cardWidth = math.min(screenSize.width * 0.85, 400.0);

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFFFFF).withOpacity(0.4),
                  Color(0xFFFFF6A3).withOpacity(0.1),
                  Color(0xFFFF9900),
                ],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Logo and App Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 6),
                        Image.asset(
                          "assets/images/vector.png",
                          width: math.min(180, screenSize.width * 0.35),
                          height: math.min(50, screenSize.width * 0.1),
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Stack for overlapping honeycomb and verification card
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        // Verification Card - positioned below
                        Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Container(
                            width: cardWidth,
                            padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFFFF8E1),
                                  Color(0xFFFBCF8C),
                                ],
                                stops: [0.0, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Space for honeycomb overlap
                                SizedBox(height: 120),

                                Text(
                                  "Verification",
                                  style: GoogleFonts.montserrat(
                                    fontSize: isSmallScreen ? 28 : 36,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF8B4513),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Email display
                                Text(
                                  "Code sent to",
                                  style: GoogleFonts.poppins(
                                    fontSize: isSmallScreen ? 12 : 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  widget.email,
                                  style: GoogleFonts.poppins(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF8B4513),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Error message if any
                                if (_errorMessage != null) ...[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _errorMessage!,
                                      style: GoogleFonts.poppins(
                                        fontSize: isSmallScreen ? 12 : 14,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],

                                // OTP input fields
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    6,
                                    (index) => Container(
                                      width: (cardWidth - 40) / 7,
                                      height: (cardWidth - 40) / 7,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: const Color(0xFFFFCA28)
                                              .withOpacity(0.5),
                                          width: 2,
                                        ),
                                      ),
                                      child: TextField(
                                        controller: _otpControllers[index],
                                        focusNode: _otpFocusNodes[index],
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        maxLength: 1,
                                        decoration: const InputDecoration(
                                          counterText: '',
                                          border: InputBorder.none,
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF8B4513),
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        onChanged: (value) {
                                          // If backspace is pressed, move focus to previous field
                                          if (value.isEmpty && index > 0) {
                                            FocusScope.of(context).requestFocus(
                                                _otpFocusNodes[index - 1]);
                                          }
                                          // If all fields are filled, verify OTP
                                          if (index == 5 && value.isNotEmpty) {
                                            _verifyOtp();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 25),

                                // Verify Button
                                Container(
                                  width: 150,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFCA28)
                                            .withOpacity(0.5),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _verifyOtp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFCA28),
                                      foregroundColor: const Color(0xFF8B4513),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: _isLoading
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: const Color(0xFF8B4513),
                                            ),
                                          )
                                        : Text(
                                            "Verify",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Resend timer
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Didn't receive code? ",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    _canResend
                                        ? GestureDetector(
                                            onTap: _resendOtp,
                                            child: Text(
                                              "Resend",
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF966317),
                                              ),
                                            ),
                                          )
                                        : Text(
                                            "${_resendSeconds}s",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                  ],
                                ),

                                // Back to login/signup
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Text(
                                    "Back",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),

                        // Animated Honeycomb Logo - positioned on top
                        Positioned(
                          top: 0,
                          child: SlideTransition(
                            position: _honeycombAnimation,
                            child: Container(
                              width: math.min(cardWidth * 0.9, 300),
                              height: 160,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFFFFF9A),
                                    Color(0xFFFFA629),
                                  ],
                                  stops: [0.0, 1.0],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/beehive.png",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Add extra space at the bottom for scrolling
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
