import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/widgets/custom_navbar.dart';
import 'package:studyhive/screens/messages_page.dart';
import 'package:studyhive/screens/notification_page.dart';
import 'package:studyhive/screens/home_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final List<Task> _tasks = [
    Task(title: "Complete Math Assignment", isCompleted: false),
    Task(title: "Read Chapter 5 of Biology", isCompleted: true),
    Task(title: "Prepare for History Presentation", isCompleted: false),
    Task(title: "Study for Physics Quiz", isCompleted: false),
    Task(title: "Submit Literature Essay", isCompleted: true),
  ];

  int _selectedIndex = 1; // Default to middle tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEDC8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFAED581),
        elevation: 0,
        title: Text(
          "Task List",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return _buildTaskItem(_tasks[index]);
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
            // Navigate to messages page
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MessagesPage(showNavBar: true)),
            );
          } else if (index == 1) {
            // Navigate to home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
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
        onPressed: _addNewTask,
        backgroundColor: const Color(0xFFAED581),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: task.isCompleted,
          activeColor: const Color(0xFFAED581),
          onChanged: (bool? value) {
            setState(() {
              task.isCompleted = value ?? false;
            });
          },
        ),
        title: Text(
          task.title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            setState(() {
              _tasks.remove(task);
            });
          },
        ),
      ),
    );
  }

  void _addNewTask() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Add New Task",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter task description",
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _tasks.add(Task(title: controller.text, isCompleted: false));
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAED581),
            ),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}

class Task {
  String title;
  bool isCompleted;

  Task({required this.title, required this.isCompleted});
}
