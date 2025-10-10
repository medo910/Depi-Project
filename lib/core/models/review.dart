import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String reviewId;
  final String productId;
  final Timestamp date;
  final String senderId;
  final String message;
  final int reactNum;
  final int rate;

  Review({
    required this.reviewId,
    required this.productId,
    required this.date,
    required this.senderId,
    required this.message,
    required this.reactNum,
    required this.rate,
  });

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'productId': productId,
      'date': date,
      'senderId': senderId,
      'message': message,
      'reactNum': reactNum,
      'rate': rate,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      reviewId: map['reviewId'] ?? '',
      productId: map['productId'] ?? '',
      date: map['date'] ?? Timestamp.now(),
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      reactNum: (map['reactNum'] ?? 0).toInt(),
      rate: (map['rate'] ?? 0).toInt(),
    );
  }
}
