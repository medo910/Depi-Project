import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  bool isFavorite = false;
  String productName;
  String productImage;
  double productPrice;
  String productType;
  double productRating;
  int productReviews;
  VoidCallback? onTap;

  ProductItem({
    super.key,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productType,
    required this.productRating,
    required this.productReviews,
    this.onTap,
  });

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    widget.productImage,
                    fit: BoxFit.fill,
                    height: 140,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 140,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.isFavorite = !widget.isFavorite;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      radius: 16,
                      child: Icon(
                        widget.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.green,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Details Section - flexible
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Product Name
                    Text(
                      widget.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Rating
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            "${widget.productRating.toStringAsFixed(1)} (${widget.productReviews} reviews)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Price
                    Text(
                      "\$${widget.productPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),

                    // Product Type
                    Text(
                      widget.productType,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
