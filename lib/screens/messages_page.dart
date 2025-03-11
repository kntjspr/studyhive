import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/message.dart';
import 'package:studyhive/widgets/custom_navbar.dart';
import 'package:studyhive/screens/notification_page.dart';
import 'package:studyhive/screens/home_page.dart';
import 'package:studyhive/screens/settings_page.dart';

class MessagesPage extends StatefulWidget {
  final bool showNavBar;

  const MessagesPage({super.key, this.showNavBar = false});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Message> _messages = MessageData.getSampleMessages();
  String _currentFilter = "All Messages";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _currentFilter = "All Messages";
              break;
            case 1:
              _currentFilter = "Read";
              break;
            case 2:
              _currentFilter = "Unread";
              break;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
              _buildTabBar(),
              Expanded(
                child: _buildMessageList(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
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
                // If we can pop, go back to previous screen
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  // Otherwise, go to home page
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
          // Title
          Text(
            "Messages",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          // Settings button
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
              icon: const Icon(Icons.settings, size: 20),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(showNavBar: true),
                  ),
                );
              },
              padding: EdgeInsets.zero,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFilterTab("All Messages",
                  isActive: _currentFilter == "All Messages", index: 0),
              _buildFilterTab("Read",
                  isActive: _currentFilter == "Read", index: 1),
              _buildFilterTab("Unread",
                  isActive: _currentFilter == "Unread", index: 2),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildFilterTab(String title,
      {required bool isActive, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentFilter = title;
          _tabController.animateTo(index);
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? Colors.black87 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          if (isActive)
            Container(
              width: 80,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9900),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    List<Message> filteredMessages = _messages;
    if (_currentFilter == "Read") {
      filteredMessages = _messages.where((message) => message.isRead).toList();
    } else if (_currentFilter == "Unread") {
      filteredMessages = _messages.where((message) => !message.isRead).toList();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: filteredMessages.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        thickness: 0.5,
        color: Colors.black12,
      ),
      itemBuilder: (context, index) {
        final message = filteredMessages[index];
        return _buildMessageTile(message);
      },
    );
  }

  Widget _buildMessageTile(Message message) {
    return GestureDetector(
      onTap: () {
        // Mark as read when tapped
        if (!message.isRead) {
          setState(() {
            // Find the message in the list and replace it with a new one that's marked as read
            final index = _messages.indexWhere((m) => m.id == message.id);
            if (index != -1) {
              _messages[index] = Message(
                id: message.id,
                name: message.name,
                profileImageUrl: message.profileImageUrl,
                content: message.content,
                isRead: true,
                timestamp: message.timestamp,
                isGroup: message.isGroup,
                memberCount: message.memberCount,
                additionalMemberImages: message.additionalMemberImages,
              );
            }
          });
        }

        // Navigate to chat detail
        _navigateToChatDetail(message);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            _buildAvatar(message),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message.name,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: message.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (!message.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF9900),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.content,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: message.isRead ? Colors.black54 : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChatDetail(Message message) {
    // This would navigate to a chat detail page
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening chat with ${message.name}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildAvatar(Message message) {
    if (message.isGroup) {
      return Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(message.profileImageUrl),
          ),
          Positioned(
            right: -2,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9900),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                "+${message.memberCount! - 1}",
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return CircleAvatar(
        radius: 24,
        backgroundImage: AssetImage(message.profileImageUrl),
      );
    }
  }
}
