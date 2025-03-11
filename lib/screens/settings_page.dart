import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/widgets/custom_navbar.dart';
import 'package:studyhive/screens/home_page.dart';
import 'package:studyhive/screens/notification_page.dart';
import 'package:studyhive/screens/messages_page.dart';

class SettingsPage extends StatefulWidget {
  final bool showNavBar;

  const SettingsPage({super.key, this.showNavBar = true});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 3; // Settings tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFF9A),
              Color(0xFFFFC164),
              Color(0xFFFFFF9A),
            ],
            stops: [0.111, 0.326, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildSettingsList(),
              ),
              if (widget.showNavBar)
                CustomNavBar(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _handleNavigation,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MessagesPage(showNavBar: true)),
          );
          break;
        case 1:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NotificationPage()),
          );
          break;
      }
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
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
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                }
              },
              padding: EdgeInsets.zero,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            "Settings",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSettingsCategory("Account"),
        _buildSettingsItem(
          icon: Icons.person_outline,
          title: "Profile",
          onTap: () {},
        ),
        _buildSettingsItem(
          icon: Icons.lock_outline,
          title: "Privacy",
          onTap: () {},
        ),
        _buildSettingsItem(
          icon: Icons.notifications_none,
          title: "Notifications",
          onTap: () {},
        ),
        const SizedBox(height: 24),
        _buildSettingsCategory("App Settings"),
        _buildSettingsItem(
          icon: Icons.language,
          title: "Language",
          onTap: () {},
        ),
        _buildSettingsItem(
          icon: Icons.color_lens_outlined,
          title: "Theme",
          onTap: () {},
        ),
        _buildSettingsItem(
          icon: Icons.help_outline,
          title: "Help & Support",
          onTap: () {},
        ),
        const SizedBox(height: 24),
        _buildSettingsCategory("Other"),
        _buildSettingsItem(
          icon: Icons.info_outline,
          title: "About",
          onTap: () {},
        ),
        _buildSettingsItem(
          icon: Icons.logout,
          title: "Logout",
          onTap: () {},
          textColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildSettingsCategory(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.black.withOpacity(0.1),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
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
              child: Icon(
                icon,
                color: const Color(0xFFFF9900),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor ?? Colors.black87,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black54,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
