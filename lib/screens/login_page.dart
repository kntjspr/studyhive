import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/screens/signup_page.dart';
import 'package:studyhive/screens/home_page.dart';
import 'dart:math' as math;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Custom page route for beehive animation
  Route _createSignupRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SignupPage(),
      transitionDuration: const Duration(milliseconds: 800),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // We don't need to animate the beehive here, as it will be handled by the Hero widget
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        // StudyHive vector
                        Image.asset(
                          "assets/images/vector.png",
                          // logo size dynamic based on the viewport width
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.width * 0.1,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Stack for overlapping honeycomb and login card
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        // Login Card - positioned below
                        Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Container(
                            width: MediaQuery.of(context).size.width *
                                0.55, // dynamic width of login container and beehive container based on viewport width
                            padding: const EdgeInsets.all(20),
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
                                const SizedBox(
                                    height: 150), // Spacing between Login text
                                Text(
                                  "Login",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF8B4513),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Username Field
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
                                    controller: _usernameController,
                                    decoration: const InputDecoration(
                                      hintText: "username",
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 25),

                                // Login Button
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
                                    onPressed: () {
                                      // TODO: Implement login logic
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePage(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFFCA28),
                                      foregroundColor: const Color(0xFF8B4513),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      "Login",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Create Account Link
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      _createSignupRoute(),
                                    );
                                  },
                                  child: Text(
                                    "create an account",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Honeycomb Logo - positioned on top
                        Positioned(
                          top: 0,
                          left:
                              -30, // Honeycomb container left and right padding
                          right: -30,
                          child: Hero(
                            tag: 'beehive',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Container(
                                height: MediaQuery.of(context).size.width * 0.4,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: MediaQuery.of(context).size.width *
                                        0.25,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
