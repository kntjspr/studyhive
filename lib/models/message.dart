import 'package:flutter/material.dart';

/// Represents a message or conversation in the messaging system
class Message {
  /// Unique identifier for the message/conversation
  final String id;

  /// Name of the sender or group
  final String name;

  /// Profile image URL of the sender or group
  final String profileImageUrl;

  /// Latest message content
  final String content;

  /// Whether this is a group conversation
  final bool isGroup;

  /// Number of members if this is a group conversation
  final int? memberCount;

  /// Additional members to display in group avatar
  final List<String>? additionalMemberImages;

  /// Whether the message has been read
  final bool isRead;

  /// Timestamp when the message was sent
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.content,
    required this.isRead,
    required this.timestamp,
    this.isGroup = false,
    this.memberCount,
    this.additionalMemberImages,
  });
}

/// Sample message data for UI development
class MessageData {
  static List<Message> getSampleMessages() {
    return [
      Message(
        id: '1',
        name: 'Sophia Flores',
        profileImageUrl: 'assets/images/beehive.png',
        content: 'Thank you 💖',
        isRead: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      Message(
        id: '2',
        name: 'Jay Goldie',
        profileImageUrl: 'assets/images/vector.png',
        content: 'Hello, how are you?',
        isRead: false,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Message(
        id: '3',
        name: 'Marketing Team',
        profileImageUrl: 'assets/images/group_meeting.png',
        content: '7 Members',
        isRead: true,
        isGroup: true,
        memberCount: 7,
        additionalMemberImages: [
          'assets/images/calendar.png',
          'assets/images/files.png',
          'assets/images/task_list.png',
        ],
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
