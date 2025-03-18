import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/widgets/custom_navbar.dart';
import 'package:studyhive/screens/home_page.dart';

class NotificationPage extends StatelessWidget {
  final bool showNavBar;

  const NotificationPage({
    super.key,
    this.showNavBar = true,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive calculations
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D9), // Light yellow background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with back button and title
            Padding(
              padding: EdgeInsets.fromLTRB(isSmallScreen ? 12 : 16,
                  isSmallScreen ? 12 : 16, isSmallScreen ? 12 : 16, 0),
              child: Row(
                children: [
                  // Back button - only show if not accessed via bottom nav
                  Container(
                    width: isSmallScreen ? 36 : 40,
                    height: isSmallScreen ? 36 : 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: IconButton(
                      icon:
                          Icon(Icons.arrow_back, size: isSmallScreen ? 18 : 20),
                      onPressed: () {
                        // Check if we can pop the current route
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          // If we can't pop, navigate to home
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        }
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "Mail & Notifications",
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 18 : 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: isSmallScreen ? 6 : 8),
                            height: 2,
                            width: isSmallScreen ? 140 : 160,
                            color: const Color(0xFFFF9900),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      width:
                          isSmallScreen ? 36 : 40), // Balance the back button
                ],
              ),
            ),

            // Mark all read and sort options
            Padding(
              padding: EdgeInsets.fromLTRB(
                  isSmallScreen ? 12 : 16,
                  isSmallScreen ? 20 : 24,
                  isSmallScreen ? 12 : 16,
                  isSmallScreen ? 6 : 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mark all read",
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 12 : 14,
                      color: Colors.black54,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Sort by time",
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: Colors.black54,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: const Color(0xFFFF9900),
                        size: isSmallScreen ? 18 : 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Notification list
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // First notification - Started live
                  _buildNotificationItem(
                    context: context,
                    profileImage: "assets/images/profile1.png",
                    name: "Sophia Plariza",
                    action: "Started live.",
                    timeAgo: "3m ago",
                    backgroundColor: const Color(0xFFFF9900),
                    showMoreIcon: false,
                  ),

                  // Second notification - Created a group
                  _buildNotificationItem(
                    context: context,
                    profileImage: "assets/images/profile1.png",
                    name: "Sophia Plariza",
                    action: "Created a group.",
                    timeAgo: "5m ago",
                    backgroundColor: const Color(0xFFFFF6D9),
                    showMoreIcon: true,
                  ),

                  // Third notification - Invited to join call
                  _buildNotificationItem(
                    context: context,
                    profileImage: "assets/images/profile2.png",
                    name: "Kelvin Fulgencio",
                    action: "Invited you to join call.",
                    timeAgo: "3h ago",
                    backgroundColor: const Color(0xFFFFF6D9),
                    showMoreIcon: true,
                  ),

                  // Fourth notification - Started following you
                  _buildNotificationItem(
                    context: context,
                    profileImage: "assets/images/profile3.png",
                    name: "Shane Pagara",
                    action: "Started following you.",
                    timeAgo: "7h ago",
                    backgroundColor: const Color(0xFFFFF6D9),
                    showMoreIcon: true,
                  ),
                ],
              ),
            ),

            // Using the custom navbar - only show if accessed directly
            if (showNavBar)
              CustomNavBar(
                selectedIndex: 2, // Notification tab is selected
                onItemTapped: (index) {
                  // Handle navigation
                  if (index != 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required BuildContext context,
    required String profileImage,
    required String name,
    required String action,
    required String timeAgo,
    required Color backgroundColor,
    required bool showMoreIcon,
  }) {
    // Get screen size for responsive calculations
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 10 : 12),
      child: Row(
        children: [
          // Profile image with orange border
          Container(
            width: isSmallScreen ? 42 : 48,
            height: isSmallScreen ? 42 : 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFF9900), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isSmallScreen ? 21 : 24),
              child: Image.asset(
                profileImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: isSmallScreen ? 10 : 12),

          // Notification content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 1 : 2),
                Text(
                  action,
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // Time and menu
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeAgo,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 10 : 12,
                  color: Colors.black54,
                ),
              ),
              if (showMoreIcon) ...[
                SizedBox(height: isSmallScreen ? 3 : 4),
                Icon(
                  Icons.more_horiz,
                  color: Colors.grey,
                  size: isSmallScreen ? 18 : 20,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
