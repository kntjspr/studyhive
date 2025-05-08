import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/widgets/custom_navbar.dart';
import 'package:studyhive/screens/messages_page.dart';
import 'package:studyhive/screens/notification_page.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _taskController = TextEditingController();
  int _selectedIndex = 1; // Default to middle tab

  // Sample todo items matching the image
  final List<TodoItem> _todoItems = [
    TodoItem(title: "HCI - LESSON 7-10 STUDY", isCompleted: false),
    TodoItem(title: "ENVI SCI - LESSON 11 STUDY", isCompleted: false),
    TodoItem(title: "FDS - MEETING", isCompleted: false),
    TodoItem(title: "CSMATH211 - REVISIONS", isCompleted: false),
    TodoItem(title: "CSMATH211 - QUIZZIZ", isCompleted: false),
    TodoItem(title: "CSMATH211 - VID PRESENTATION", isCompleted: false),
  ];

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addNewTodo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Add New Task",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: _taskController,
          decoration: InputDecoration(
            hintText: "Enter task description",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(
                color: const Color(0xFF666666),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_taskController.text.isNotEmpty) {
                setState(() {
                  _todoItems.add(TodoItem(
                    title: _taskController.text.toUpperCase(),
                    isCompleted: false,
                  ));
                  _taskController.clear();
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFCA28),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Add",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFFF59D), // Light yellow background matching the image
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F1F1F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Task list visualization at the top
          Container(
            width: double.infinity,
            height: 150,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFAED581), Color(0xFFFFD54F)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    'assets/images/task_list.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),

          // "All to-dos:" label
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD54F),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              "All to-dos:",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ),

          // Todo list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _todoItems.length,
              itemBuilder: (context, index) {
                return _buildTodoItem(_todoItems[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Navigation logic based on index
          if (index == 0) {
            // Navigate to chat/messages
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MessagesPage(showNavBar: true)),
            );
          } else if (index == 1) {
            // Navigate to home
            Navigator.pop(context);
          } else if (index == 2) {
            // Navigate to notifications
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTodo,
        backgroundColor: const Color(0xFFFFCA28),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTodoItem(TodoItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          // Checkbox image (you'll need to provide these assets)
          GestureDetector(
            onTap: () {
              setState(() {
                item.isCompleted = !item.isCompleted;
              });
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: item.isCompleted
                    ? Image.asset(
                        'assets/images/checkbox_checked.png',
                        width: 20,
                        height: 20,
                        // If you don't have these assets yet, use Icons instead
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.check_box,
                          color: Colors.brown,
                          size: 20,
                        ),
                      )
                    : Image.asset(
                        'assets/images/checkbox_unchecked.png',
                        width: 20,
                        height: 20,
                        // If you don't have these assets yet, use Icons instead
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.check_box_outline_blank,
                          color: Colors.brown,
                          size: 20,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Task title
          Expanded(
            child: Text(
              item.title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration:
                    item.isCompleted ? TextDecoration.lineThrough : null,
                color: item.isCompleted ? Colors.grey : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItem {
  String title;
  bool isCompleted;

  TodoItem({required this.title, required this.isCompleted});
}
