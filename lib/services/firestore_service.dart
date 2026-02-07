import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'chats';

  // Save a message to Firestore
  Future<void> saveMessage(String userId, ChatMessage message) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection(_collection)
          .add({
        'text': message.text,
        'isUser': message.isUser,
        'timestamp': Timestamp.fromDate(message.timestamp),
      });
    } catch (e) {
      print('Error saving message: $e');
    }
  }

  // Get chat history stream
  Stream<List<ChatMessage>> getChatStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection(_collection)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ChatMessage(
          text: data['text'] ?? '',
          isUser: data['isUser'] ?? false,
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }
}
