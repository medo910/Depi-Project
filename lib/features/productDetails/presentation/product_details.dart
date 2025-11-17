import 'package:depi_app/core/models/product.dart';
import 'package:depi_app/core/models/selectedProduct.dart';
import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/utils/app_styles.dart';
import 'package:depi_app/features/productDetails/data/ReviewService.dart';
import 'package:depi_app/features/productDetails/data/UserService.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/DetailsExpandable.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/FavoriteButton.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/ProductOptionsSelector.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/ProductReviewsExpandable.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/QuantitySelector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final Product product;

  final cartService = CartService();

  ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? sizeColorBoth;
  String? selectedColor;
  String? selectedSize;
  int get reviewCount => widget.product.comments.length;

  @override
  void initState() {
    super.initState();
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
            AppRouter.router.go(AppRouter.kHome);
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
          ),
          SizedBox(width: 8),
          Icon(Icons.share),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
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

                    // التقييم وعدد المراجعات - ديناميكي
                    StreamBuilder<Product>(
                      stream: ProductReviewService().getProductStream(
                        widget.product.id,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        final product = snapshot.data!;
                        final comments = product.comments;

                        // حساب متوسط التقييم
                        double avgRate = 0;
                        if (comments.isNotEmpty) {
                          avgRate =
                              comments
                                  .map((r) => r.rate)
                                  .reduce((a, b) => a + b) /
                              comments.length;
                        }

                        // عدد المراجعات
                        final reviewCount = comments.length;

                        return Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < avgRate.round()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 25,
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              avgRate.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
                        );
                      },
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
                      onColorSelected: (color) => selectedColor = color,
                      onSizeSelected: (size) => selectedSize = size,
                    ),
                    const SizedBox(height: 25),
                    Text("Quantity", style: AppStyles.styleSemiBold18Dark),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: QuantitySelector(
                        initialQuantity: 1,
                        min: 1,
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
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              print("User not logged in");
              return;
            }

            Map<String, dynamic> productDetails = {"quantity": 1};

            ///  لو المنتج فيه color
            if (widget.product.productAttributeType ==
                    ProductAttributeType.color ||
                widget.product.productAttributeType ==
                    ProductAttributeType.both) {
              if (selectedColor != null) {
                productDetails["color"] = selectedColor;
              }
            }

            ///  لو المنتج فيه size
            if (widget.product.productAttributeType ==
                    ProductAttributeType.size ||
                widget.product.productAttributeType ==
                    ProductAttributeType.both) {
              if (selectedSize != null) {
                productDetails["size"] = selectedSize;
              }
            }

            final productToAdd = ProductSelected(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              productId: widget.product.id,
              name: widget.product.name,
              price: widget.product.price,
              photoURL: widget.product.photoUrl,
              brand: widget.product.brand,
              category: widget.product.category,
              productDetails: productDetails,
            );

            await CartService().addToCart(user.uid, productToAdd);

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Added to cart")));
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
