import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'reviews';

  Future<void> addReview(Review review) async {
    try {
      await _firestore.collection(_collection).add(review.toMap());
    } catch (e) {
      print('Error adding review: $e');
    }
  }

  Stream<List<Review>> getReviewsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Review.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
}
