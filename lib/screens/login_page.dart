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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Honeycomb Background
          const HoneycombBackground(),

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

                    const SizedBox(height: 20),

                    // Honeycomb Logo
                    Container(
                      width: 350,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFFF9A),
                            Color(0xFFFFA629),
                          ],
                          stops: [0.28, 0.77],
                        ),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/images/beehive.png",
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.5,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login Card
                    Container(
                      width: 300,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: const [
                            Color(0xFFFF9A),
                            Color(0xFFFBCF8C),
                          ],
                          stops: [0.0, 0.80],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
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
                              color: const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(30),
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
                              color: const Color(0xFFFFF8E1),
                              borderRadius: BorderRadius.circular(30),
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
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Login Button
                          SizedBox(
                            width: 150,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Implement login logic
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFCA28),
                                foregroundColor: Colors.brown,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 2,
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
                                MaterialPageRoute(
                                  builder: (context) => const SignupPage(),
                                ),
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

// Custom Honeycomb Background Widget
class HoneycombBackground extends StatelessWidget {
  const HoneycombBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: CustomPaint(
        painter: HoneycombPainter(),
        size: Size.infinite,
      ),
    );
  }
}

// Custom Painter for Honeycomb Pattern
class HoneycombPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const double hexSize = 60.0;
    final double width = size.width;
    final double height = size.height;

    // Calculate number of hexagons needed
    final int horizontalCount = (width / (hexSize * 1.5)).ceil() + 1;
    final int verticalCount = (height / (hexSize * math.sqrt(3))).ceil() + 1;

    for (int row = -1; row < verticalCount; row++) {
      for (int col = -1; col < horizontalCount; col++) {
        double offsetX = col * hexSize * 1.5;
        double offsetY = row * hexSize * math.sqrt(3);

        // Offset every other row
        if (row % 2 == 1) {
          offsetX += hexSize * 0.75;
        }

        drawHexagon(canvas, paint, Offset(offsetX, offsetY), hexSize);
      }
    }
  }

  void drawHexagon(Canvas canvas, Paint paint, Offset center, double size) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (60 * i - 30) * (math.pi / 180);
      final x = center.dx + size * math.cos(angle);
      final y = center.dy + size * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
