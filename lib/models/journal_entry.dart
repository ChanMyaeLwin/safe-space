import 'package:cloud_firestore/cloud_firestore.dart';

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory JournalEntry.fromMap(String id, Map<String, dynamic> map) {
    return JournalEntry(
      id: id,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
