import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/screens/profile_page.dart';
import 'package:studyhive/screens/meetings_page.dart';
import 'package:studyhive/screens/todo_page.dart';
import 'package:studyhive/screens/calendar_page.dart';
import 'package:studyhive/screens/files_page.dart';
import 'package:studyhive/widgets/custom_navbar.dart';

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
      MaterialPageRoute(builder: (context) => const TodoPage()),
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
              imagePath: 'assets/images/group_meeting.png',
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
              imagePath: 'assets/images/calendar.png',
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
              imagePath: 'assets/images/files.png',
              label: "Files",
              onTap: _navigateToFiles,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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
              child: imagePath == 'assets/images/group_meeting.png'
                  ? Image.asset(
                      imagePath,
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 250,
                          height: 250,
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
                    )
                  : Image.asset(
                      imagePath,
                      width: 150,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
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
}
