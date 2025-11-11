import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/review.dart';

class ProductReviewsExpandableFull extends StatelessWidget {
  final List<Review> comments;

  const ProductReviewsExpandableFull({super.key, required this.comments});

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, // يخفي الخط الفاصل
      ),
      child: ExpansionTile(
        title: const Text(
          'Customer Reviews',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        children:
            comments.map<Widget>((r) {
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: sender + date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            r.senderId,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            formatDate(r.date),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // Message
                      Text(r.message, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      // Stars + reactNum
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(
                              r.rate,
                              (i) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.thumb_up,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                r.reactNum.toString(),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
