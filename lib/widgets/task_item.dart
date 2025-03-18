import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:studyhive/models/task/task_model.dart';
import 'package:studyhive/utils/constants.dart';

/// Widget for displaying a task item in a list
class TaskItem extends StatelessWidget {
  /// The task to display
  final TaskModel task;

  /// Callback when the task is tapped
  final VoidCallback? onTap;

  /// Callback when the task is marked as completed
  final Function(bool)? onCompletionChanged;

  /// Callback when the task is deleted
  final VoidCallback? onDelete;

  /// Creates a new TaskItem widget
  const TaskItem({
    super.key,
    required this.task,
    this.onTap,
    this.onCompletionChanged,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Format the due date if it exists
    final formattedDueDate = task.dueDate != null
        ? DateFormat('MMM dd, yyyy').format(task.dueDate!)
        : 'No due date';

    // Get the priority color
    final priorityColor =
        AppConstants.taskPriorityColors[task.priority] ?? Colors.grey;

    // Get the status color
    final statusColor =
        AppConstants.taskStatusColors[task.status] ?? Colors.grey;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and completion checkbox
              Row(
                children: [
                  if (onCompletionChanged != null)
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        if (value != null) {
                          onCompletionChanged!(value);
                        }
                      },
                      activeColor: AppConstants.primaryColor,
                    ),
                  Expanded(
                    child: Text(
                      task.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.isCompleted
                            ? Colors.grey
                            : AppConstants.textColorDark,
                      ),
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red[300],
                      onPressed: onDelete,
                    ),
                ],
              ),

              // Description if available
              if (task.description != null && task.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32.0,
                    top: 4.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    task.description!,
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Due date, priority, and status
              Padding(
                padding: const EdgeInsets.only(
                  left: 32.0,
                  top: 8.0,
                ),
                child: Row(
                  children: [
                    // Due date
                    Icon(
                      Icons.calendar_today,
                      size: 16.0,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      formattedDueDate,
                      style: GoogleFonts.poppins(
                        fontSize: 12.0,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 16.0),

                    // Priority
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag,
                            size: 12.0,
                            color: priorityColor,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            task.priority.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: priorityColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),

                    // Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 2.0,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        task.status.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Category if available
              if (task.category != null && task.category!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32.0,
                    top: 8.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.folder_outlined,
                        size: 16.0,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        task.category!,
                        style: GoogleFonts.poppins(
                          fontSize: 12.0,
                          color: Colors.grey[700],
                        ),
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
}
