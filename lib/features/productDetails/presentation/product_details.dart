import 'package:depi_app/core/models/product.dart';
import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/core/utils/app_styles.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/DetailsExpandable.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/FavoriteButton.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/ProductOptionsSelector.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/ProductReviewsExpandable.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/QuantitySelector.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? sizeColorBoth;

  void averageRating() {
    if (widget.product.comments.isEmpty) widget.product.rate = 0.0;
    double total = 0;
    for (var r in widget.product.comments) {
      total += r.rate;
    }
    widget.product.rate = total / widget.product.comments.length;
  }

  int get reviewCount => widget.product.comments.length;

  @override
  void initState() {
    super.initState();
    averageRating();
    sizeColorBoth = widget.product.productAttributeType.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          FavoriteButton(
            productId: widget.product.id,
            activeColor: Colors.pink,
            inactiveColor: Colors.grey[400],
            onFavoritePressed: (productId) {
              // احفظ في Firebase أو Local Storage
            },
          ),
          SizedBox(width: 8),
          Icon(Icons.share),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // صورة المنتج
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(widget.product.photoUrl, fit: BoxFit.fill),
              ),
              // التفاصيل
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.brand,
                      style: AppStyles.styleRegular16Muted,
                    ),
                    const SizedBox(height: 4),
                    Text(widget.product.name, style: AppStyles.styleBold24Dark),
                    const SizedBox(height: 8),

                    // التقييم وعدد المراجعات
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < widget.product.rate
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 25,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.product.rate.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '($reviewCount reviews)',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Text(
                      '\$${widget.product.price}',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ProductOptionsSelector(
                      sizeColorBoth: sizeColorBoth!,
                      stock: widget.product.stock,
                    ),
                    const SizedBox(height: 25),
                    Text("Quantity", style: AppStyles.styleSemiBold18Dark),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: QuantitySelector(
                        initialQuantity: 1,
                        min: 1,
                        max: widget.product.quantity,
                        onChanged: (qty) {
                          // يمكن إضافة وظيفة تحديث الكمية هنا
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ProductDetailsExpandable(
                      description: widget.product.description,
                      instruction: widget.product.instruction,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductReviewsExpandableFull(
                  comments: widget.product.comments,
                  productId: widget.product.id,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            // يمكن إضافة وظيفة إضافة المنتج للسلة هنا
          },
          child: const Text(
            'Add to Cart',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
