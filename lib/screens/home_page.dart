import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/screens/profile_page.dart';
import 'package:studyhive/screens/meetings_page.dart';
import 'package:studyhive/screens/task_list_page.dart';
import 'package:studyhive/screens/calendar_page.dart';
import 'package:studyhive/screens/files_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  // Navigation functions
  void _navigateToMeetings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MeetingsPage()),
    );
  }

  void _navigateToTaskList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaskListPage()),
    );
  }

  void _navigateToCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalendarPage()),
    );
  }

  void _navigateToFiles() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FilesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF59D), // Light yellow background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87, size: 30),
          onPressed: () {
            // Navigate to profile page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/beehive.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 8),
            Text(
              "StudyHive",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          // Empty action to balance the leading icon
          const SizedBox(width: 48),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            // Group Meeting Card
            _buildFeatureCard(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFE0B2), Color(0xFFFFB74D)],
              ),
              height: 160,
              imagePath: 'assets/images/meeting_illustration.png',
              label: "Group Meeting Discussion\nand Livestream",
              onTap: _navigateToMeetings,
            ),

            const SizedBox(height: 20),

            // Task List Card
            _buildFeatureCard(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFDCEDC8), Color(0xFFAED581)],
              ),
              height: 120,
              imagePath: 'assets/images/task_list.png',
              label: "Task List",
              onTap: _navigateToTaskList,
            ),

            const SizedBox(height: 20),

            // Calendar Card
            _buildFeatureCard(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFCDD2), Color(0xFFFFAB91)],
              ),
              height: 120,
              imagePath: 'assets/images/calendar_icon.png',
              label: "Calendar",
              onTap: _navigateToCalendar,
            ),

            const SizedBox(height: 20),

            // Files Card
            _buildFeatureCard(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
              ),
              height: 120,
              imagePath: 'assets/images/files_icon.png',
              label: "Files",
              onTap: _navigateToFiles,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.chat_bubble_outline, Colors.orange),
              _buildNavItem(1, Icons.hexagon_outlined, const Color(0xFFFF9800)),
              _buildNavItem(2, Icons.notifications_none, Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required LinearGradient gradient,
    required double height,
    required String imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to placeholder if image doesn't exist
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 50,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black54,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(int index, IconData icon, Color color) {
    final isSelected = _selectedIndex == index;
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF9800) : Colors.white,
        shape: BoxShape.circle,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 28,
          color: isSelected ? Colors.white : color,
        ),
        onPressed: () => setState(() => _selectedIndex = index),
      ),
    );
  }
}
