import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/screens/home_page.dart';
import 'package:studyhive/screens/login_page.dart';
import 'package:studyhive/screens/otp_verification_page.dart';
import 'package:studyhive/services/auth_service.dart';
import 'package:studyhive/utils/exceptions.dart';
import 'dart:math' as math;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Create auth service instance
  final AuthService _authService = AuthService();

  late AnimationController _animationController;
  late Animation<Offset> _beehiveAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _beehiveAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    Future.delayed(const Duration(milliseconds: 100), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Validate form inputs
  bool _validateForm() {
    if (_firstNameController.text.isEmpty) {
      setState(() => _errorMessage = "First name is required");
      return false;
    }

    if (_lastNameController.text.isEmpty) {
      setState(() => _errorMessage = "Last name is required");
      return false;
    }

    if (_emailController.text.isEmpty) {
      setState(() => _errorMessage = "Email is required");
      return false;
    }

    // Simple email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(_emailController.text)) {
      setState(() => _errorMessage = "Please enter a valid email");
      return false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() => _errorMessage = "Password is required");
      return false;
    }

    if (_passwordController.text.length < 8) {
      setState(() => _errorMessage = "Password must be at least 8 characters");
      return false;
    }

    return true;
  }

  // Handle registration initialization
  Future<void> _handleRegisterInit() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call registerInit to validate credentials and send OTP
      final success = await _authService.registerInit(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (success && mounted) {
        // Navigate to OTP verification page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationPage(
              email: _emailController.text,
              type: VerificationType.register,
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
            ),
          ),
        );
      }
    } catch (e) {
      String message = "Registration failed. Please try again.";
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

                    // Stack for overlapping signup card and beehive
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // Signup Card - positioned on top
                        Container(
                          width: cardWidth,
                          padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
                          margin: const EdgeInsets.only(
                              bottom: 100), // Add margin for overlap
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
                              Text(
                                "Sign up",
                                style: GoogleFonts.montserrat(
                                  fontSize: isSmallScreen ? 32 : 40,
                                  fontWeight: FontWeight.w900,
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

                              // First Name Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: const Color(0xFFFFCA28)
                                        .withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: TextField(
                                  controller: _firstNameController,
                                  decoration: const InputDecoration(
                                    hintText: "first name",
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: Color(0xFFBDBDBD),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 15),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              // Last Name Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: const Color(0xFFFFCA28)
                                        .withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: TextField(
                                  controller: _lastNameController,
                                  decoration: const InputDecoration(
                                    hintText: "last name",
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: Color(0xFFBDBDBD),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 15),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              // Email Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: const Color(0xFFFFCA28)
                                        .withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    hintText: "email",
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Color(0xFFBDBDBD),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 15),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              // Password Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: const Color(0xFFFFCA28)
                                        .withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: !_isPasswordVisible,
                                  decoration: InputDecoration(
                                    hintText: "password",
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFFBDBDBD),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: const Color(0xFFBDBDBD),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              // Sign up Button
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
                                  onPressed:
                                      _isLoading ? null : _handleRegisterInit,
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
                                          "Sign up",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Login Link
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  "already have an account? click here",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: const Color(0xFF966317),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  height: 120), // Space for beehive overlap
                            ],
                          ),
                        ),

                        // Animated Beehive - positioned at bottom
                        Positioned(
                          bottom: 0,
                          child: SlideTransition(
                            position: _beehiveAnimation,
                            child: Hero(
                              tag: 'beehive',
                              child: Material(
                                type: MaterialType.transparency,
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
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40),
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, -4),
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
