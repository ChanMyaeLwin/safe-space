import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/journal_entry.dart';

class JournalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'journal';

  Future<void> saveEntry(String userId, JournalEntry entry) async {
    try {
      if (entry.id.isEmpty) {
        // New entry
        await _firestore
            .collection('users')
            .doc(userId)
            .collection(_collection)
            .add(entry.toMap());
      } else {
        // Update existing entry
        await _firestore
            .collection('users')
            .doc(userId)
            .collection(_collection)
            .doc(entry.id)
            .update(entry.toMap());
      }
    } catch (e) {
      print('Error saving journal entry: $e');
    }
  }

  Stream<List<JournalEntry>> getEntriesStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return JournalEntry.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> deleteEntry(String userId, String entryId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection(_collection)
          .doc(entryId)
          .delete();
    } catch (e) {
      print('Error deleting journal entry: $e');
    }
  }
}
