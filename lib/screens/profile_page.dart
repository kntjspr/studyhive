import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/screens/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive calculations
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF59D), // Light yellow at top
              Color(0xFFFFB74D), // Orange at bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and profile header
              Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    // Profile image
                    Container(
                      width: isSmallScreen ? 45 : 50,
                      height: isSmallScreen ? 45 : 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[700],
                          size: isSmallScreen ? 25 : 30,
                        ),
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    // Name and "You" text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mitch Dumdum",
                          style: GoogleFonts.poppins(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "You",
                          style: GoogleFonts.poppins(
                            fontSize: isSmallScreen ? 12 : 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.black26),

              // Menu items
              _buildMenuItem(
                context: context,
                icon: Icons.person_outline,
                title: "Personal Information",
                onTap: () {
                  // TODO: Navigate to personal information page
                },
              ),

              _buildMenuItem(
                context: context,
                icon: Icons.settings_outlined,
                title: "Account Setting",
                onTap: () {
                  // TODO: Navigate to account settings page
                },
              ),

              // Spacer to push sign out button to bottom
              const Spacer(),

              // Sign out button
              Padding(
                padding: EdgeInsets.all(isSmallScreen ? 20.0 : 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: isSmallScreen ? 45 : 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to login page
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Sign out",
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    // Get screen size for responsive calculations
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20.0 : 24.0,
            vertical: isSmallScreen ? 12.0 : 16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: isSmallScreen ? 20 : 24),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
