import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/LikeButton.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/review.dart';

class ProductReviewsExpandableFull extends StatefulWidget {
  final List<Review> comments;
  final String productId; // مهم لو هتضيف التعليق في Firestore

  const ProductReviewsExpandableFull({
    super.key,
    required this.comments,
    required this.productId,
  });

  @override
  State<ProductReviewsExpandableFull> createState() =>
      _ProductReviewsExpandableFullState();
}

class _ProductReviewsExpandableFullState
    extends State<ProductReviewsExpandableFull> {
  final TextEditingController _commentController = TextEditingController();
  double _selectedRate = 5;

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}';
  }

  double get averageRating {
    if (widget.comments.isEmpty) return 0.0;
    double sum = widget.comments.fold(
      0.0,
      (prev, review) => prev + review.rate.toDouble(),
    );
    return sum / widget.comments.length;
  }

  Map<int, int> get ratingDistribution {
    Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in widget.comments) {
      int rating = review.rate;
      if (rating >= 1 && rating <= 5) {
        distribution[rating] = (distribution[rating] ?? 0) + 1;
      }
    }
    return distribution;
  }

  // Future<void> _showAddReviewDialog() async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         title: const Text('Add a Review'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text('Select Rating:'),
  //             const SizedBox(height: 8),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: List.generate(5, (i) {
  //                 return IconButton(
  //                   icon: Icon(
  //                     Icons.star,
  //                     color: i < _selectedRate ? Colors.amber : Colors.grey,
  //                   ),
  //                   onPressed: () {
  //                     setState(() {
  //                       _selectedRate = (i + 1).toDouble();
  //                     });
  //                   },
  //                 );
  //               }),
  //             ),
  //             TextField(
  //               controller: _commentController,
  //               decoration: const InputDecoration(
  //                 labelText: 'Write your comment...',
  //                 border: OutlineInputBorder(),
  //               ),
  //               maxLines: 3,
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               _commentController.clear();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () async {
  //               final commentText = _commentController.text.trim();
  //               if (commentText.isEmpty) return;

  //               // ✳️ هنا ممكن تضيف التعليق في Firestore
  //               await FirebaseFirestore.instance
  //                   .collection('products')
  //                   .doc(widget.productId)
  //                   .collection('reviews')
  //                   .add({
  //                     'senderId': 'user1', // replace with current user ID
  //                     'message': commentText,
  //                     'rate': _selectedRate.toInt(),
  //                     'date': Timestamp.now(),
  //                     'reactNum': 0,
  //                   });

  //               // ✳️ ترجع وتحدث الواجهة
  //               if (mounted) {
  //                 Navigator.pop(context);
  //                 setState(() {
  //                   widget.comments.add(
  //                     Review(
  //                       reviewId:
  //                           'temp_${DateTime.now().millisecondsSinceEpoch}',
  //                       productId: widget.productId,
  //                       senderId: 'user1',
  //                       message: commentText,
  //                       rate: _selectedRate.toInt(),
  //                       date: Timestamp.now(),
  //                       reactNum: 0,
  //                     ),
  //                   );
  //                 });
  //               }
  //               _commentController.clear();
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: AppColors.accent,
  //             ),
  //             child: const Text('Submit'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final distribution = ratingDistribution;
    final avg = averageRating;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: const Icon(Icons.reviews, color: AppColors.primary),
        title: const Text(
          'Customer Reviews',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        children: [
          // 🔹 ملخص التقييمات
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        avg.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            color:
                                i < avg.round()
                                    ? Colors.amber
                                    : Colors.grey[300],
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.comments.length} reviews',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    children:
                        [5, 4, 3, 2, 1].map((star) {
                          int count = distribution[star] ?? 0;
                          double percentage =
                              widget.comments.isEmpty
                                  ? 0.0
                                  : (count / widget.comments.length);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Text(
                                  '$star',
                                  style: const TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: percentage,
                                      backgroundColor: Colors.grey[300],
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.amber,
                                          ),
                                      minHeight: 8,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 20,
                                  child: Text(
                                    '$count',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 🔹 زرار إضافة تعليق
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed:(){} ,// _showAddReviewDialog
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.add_comment, color: Colors.white),
              label: const Text(
                'Add a Review',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 🔹 قائمة التعليقات
          ...widget.comments.map<Widget>((r) {
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
                    Text(r.message, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
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
                        LikeButton(
                          likeCount: r.reactNum,
                          reviewId: r.reviewId,
                          onLikePressed: (reviewId) {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
