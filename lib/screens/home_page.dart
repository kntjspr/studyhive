import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/screens/profile_page.dart';
import 'package:studyhive/screens/meetings_page.dart';
import 'package:studyhive/screens/todo_page.dart';
import 'package:studyhive/screens/calendar_page.dart';
import 'package:studyhive/screens/files_page.dart';
import 'package:studyhive/screens/messages_page.dart';
import 'package:studyhive/screens/notification_page.dart';
import 'package:studyhive/screens/settings_page.dart';
import 'package:studyhive/widgets/custom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  final List<Widget> _pages = [
    const MessagesPage(showNavBar: false),
    const HomeContent(),
    const NotificationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedIndex == 1
          ? const Color(0xFFFFF59D)
          : const Color(0xFFFFF3D8),
      appBar: _selectedIndex == 1 ? _buildHomeAppBar() : null,
      drawer: _buildDrawer(),
      body: _pages[_selectedIndex],
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

  AppBar _buildHomeAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Image.asset(
              'assets/icons/hamburger.png',
              width: 24,
              height: 24,
              // If the asset doesn't exist, use a fallback icon
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF59D),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 2,
                        width: 16,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      Container(
                        height: 2,
                        width: 16,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      Container(
                        height: 2,
                        width: 16,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
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
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF4E9),
              Color(0xFFFFE4CA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildDrawerHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildCategoryHeader("Account"),
                    _buildDrawerItem(
                      icon: Icons.person_outline,
                      title: "Profile",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings_outlined,
                      title: "Settings",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryHeader("Study Tools"),
                    _buildDrawerItem(
                      icon: Icons.calendar_today_outlined,
                      title: "Calendar",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CalendarPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.folder_outlined,
                      title: "Files",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FilesPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.check_circle_outline,
                      title: "Tasks",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TodoPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.videocam_outlined,
                      title: "Meetings",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MeetingsPage()),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryHeader("Support"),
                    _buildDrawerItem(
                      icon: Icons.help_outline,
                      title: "Help Center",
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to help center
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.feedback_outlined,
                      title: "Feedback",
                      onTap: () {
                        Navigator.pop(context);
                        // Navigate to feedback
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDrawerItem(
                      icon: Icons.logout,
                      title: "Logout",
                      onTap: () {
                        Navigator.pop(context);
                        // Handle logout
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              image: const DecorationImage(
                image: AssetImage('assets/images/profile.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "John Doe",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "john.doe@example.com",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: const Color(0xFFFF9800),
            size: 22,
          ),
          title: Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.black45,
          ),
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MeetingsPage()),
              );
            },
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TodoPage()),
              );
            },
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalendarPage()),
              );
            },
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FilesPage()),
              );
            },
          ),
        ],
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
