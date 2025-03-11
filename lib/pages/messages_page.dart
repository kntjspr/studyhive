import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_navbar.dart';
import 'settings_page.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Already on messages page
        break;
      case 1:
        Navigator.pushNamed(context, '/home');
        break;
      case 2:
        Navigator.pushNamed(context, '/notifications');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Messages",
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TabBar(
                    labelColor: Colors.orange,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.orange,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(
                        child: Text(
                          "All Messages",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Unread",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // All Messages Tab
                      ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: const [
                          // Add message items here
                        ],
                      ),
                      // Unread Messages Tab
                      ListView(
                        padding: const EdgeInsets.all(16.0),
                        children: const [
                          // Add unread message items here
                        ],
                      ),
                    ],
                  ),
                ),
                CustomNavBar(
                  selectedIndex: 0,
                  onItemTapped: (index) => _handleNavigation(context, index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
