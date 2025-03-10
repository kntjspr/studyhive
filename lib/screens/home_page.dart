import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF59D), // Lighter yellow background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFFFF9800), size: 30),
          onPressed: () {
            // Navigate to profile page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFF9800),
              ),
              child: const Center(
                child: Icon(
                  Icons.hexagon_outlined,
                  color: Colors.black,
                  size: 24,
                ),
              ),
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            // Group Meeting Card
            _buildCard(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFE0B2), Color(0xFFFFB74D)],
              ),
              height: 160,
              child: Center(
                child: Image.asset(
                  'assets/images/meeting_illustration.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              label: "Group Meeting Discussion\nand Livestream",
            ),

            const SizedBox(height: 20),

            // Task List Card
            _buildCard(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFB2DFDB), Color(0xFF80CBC4)],
              ),
              height: 120,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE57373),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            width: 100 - (index * 15),
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3F51B5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              label: "Task List",
            ),

            const SizedBox(height: 20),

            // Calendar Card
            _buildCard(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFCDD2), Color(0xFFFFB74D)],
              ),
              height: 120,
              child: Center(
                child: Image.asset(
                  'assets/images/calendar_icon.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              label: "Calendar",
            ),

            const SizedBox(height: 20),

            // Files Card
            _buildCard(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
              ),
              height: 120,
              child: Center(
                child: Image.asset(
                  'assets/images/files_icon.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              label: "Files",
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
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.chat_bubble_outline, Icons.chat_bubble),
              _buildNavItem(1, Icons.hexagon_outlined, Icons.hexagon),
              _buildNavItem(2, Icons.notifications_none, Icons.notifications),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required LinearGradient gradient,
    required double height,
    required Widget child,
    required String label,
  }) {
    return Column(
      children: [
        Container(
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
          child: child,
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

  Widget _buildNavItem(
      int index, IconData unselectedIcon, IconData selectedIcon) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      icon: Icon(
        isSelected ? selectedIcon : unselectedIcon,
        size: 28,
        color: isSelected ? const Color(0xFFFF9800) : Colors.grey,
      ),
      onPressed: () => setState(() => _selectedIndex = index),
    );
  }
}
