import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/features/productDetails/data/ReviewService.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/LikeButton.dart';
import 'package:flutter/material.dart';
import 'package:depi_app/core/models/review.dart';
import 'package:depi_app/core/models/product.dart';

class ProductReviewsExpandableFull extends StatefulWidget {
  final String productId;
  const ProductReviewsExpandableFull({super.key, required this.productId});

  @override
  State<ProductReviewsExpandableFull> createState() =>
      _ProductReviewsExpandableFullState();
}

class _ProductReviewsExpandableFullState
    extends State<ProductReviewsExpandableFull> {
  final TextEditingController _commentController = TextEditingController();
  double _selectedRate = 5;

  String formatDate(Timestamp timestamp) {
    final date = timestamp.toDate(); // يحوّل Timestamp لـ DateTime
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _showAddReviewDialog(List<Review> currentComments) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.75,
                  ),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.grey.shade50],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header with icon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.accent.withOpacity(0.1),
                              AppColors.accent.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.rate_review_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Share Your Experience',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Help others make better decisions',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Rating Section
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'How would you rate this product?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Animated Stars
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (i) {
                                final isSelected = i < _selectedRate;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedRate = (i + 1).toDouble();
                                    });
                                    setDialogState(() {});
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    padding: const EdgeInsets.all(4),
                                    child: Icon(
                                      isSelected
                                          ? Icons.star_rounded
                                          : Icons.star_outline_rounded,
                                      color:
                                          isSelected
                                              ? Colors.amber
                                              : Colors.grey.shade300,
                                      size: 32,
                                    ),
                                  ),
                                );
                              }),
                            ),

                            // Rating Text
                            const SizedBox(height: 6),
                            AnimatedOpacity(
                              opacity: _selectedRate > 0 ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                _getRatingText(_selectedRate.toInt()),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Comment TextField
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _commentController,
                          decoration: InputDecoration(
                            labelText: 'Share your thoughts...',
                            labelStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                            hintText: 'What did you like or dislike?',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                            prefixIcon: Icon(
                              Icons.edit_note_rounded,
                              color: AppColors.accent.withOpacity(0.6),
                              size: 22,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                          ),
                          maxLines: 3,
                          maxLength: 500,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _commentController.clear();
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () async {
                                final commentText =
                                    _commentController.text.trim();
                                if (commentText.isEmpty || _selectedRate == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Please add rating and comment',
                                      ),
                                      backgroundColor: Colors.orange,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.all(16),
                                    ),
                                  );
                                  return;
                                }

                                final newReview = Review(
                                  reviewId:
                                      'temp_${DateTime.now().millisecondsSinceEpoch}',
                                  productId: widget.productId,
                                  senderId: 'user1',
                                  message: commentText,
                                  rate: _selectedRate.toInt(),
                                  date: Timestamp.now(),
                                  reactNum: 0,
                                );

                                await ProductReviewService().addReviewToProduct(
                                  widget.productId,
                                  newReview,
                                );

                                if (mounted) {
                                  Navigator.pop(context);
                                  _commentController.clear();
                                  setState(() {
                                    _selectedRate = 0;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Review submitted successfully!',
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: const EdgeInsets.all(16),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                backgroundColor: AppColors.accent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send_rounded, size: 16),
                                  SizedBox(width: 6),
                                  Text(
                                    'Submit Review',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Product>(
      stream: ProductReviewService().getProductStream(widget.productId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = snapshot.data!;
        final comments = product.comments;

        double total = 0;
        for (var r in comments) total += r.rate;
        final avg = comments.isEmpty ? 0.0 : total / comments.length;

        Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
        for (var review in comments) {
          int rating = review.rate;
          if (rating >= 1 && rating <= 5) {
            distribution[rating] = (distribution[rating] ?? 0) + 1;
          }
        }

        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: const Icon(Icons.reviews, color: AppColors.primary),
            title: const Text(
              'Customer Reviews',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            children: [
              // ملخص التقييمات
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
                            '${comments.length} reviews',
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
                                  comments.isEmpty
                                      ? 0.0
                                      : (count / comments.length);
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
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
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(Colors.amber),
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

              // زرار إضافة تعليق
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _showAddReviewDialog(comments),
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

              // قائمة التعليقات
              ...comments.map<Widget>((r) {
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
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
      },
    );
  }
}
