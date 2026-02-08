class Review {
  final String id;
  final String userName;
  final double rating;
  final String text;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'rating': rating,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Review.fromMap(String id, Map<String, dynamic> map) {
    return Review(
      id: id,
      userName: map['userName'] ?? 'Anonymous',
      rating: (map['rating'] ?? 0.0).toDouble(),
      text: map['text'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}
