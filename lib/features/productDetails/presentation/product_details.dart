import 'package:depi_app/core/models/product.dart';
import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/core/utils/app_styles.dart';
import 'package:depi_app/features/productDetails/data/fake_data.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/DetailsExpandable.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/ProductReviewsExpandable.dart';
import 'package:depi_app/features/productDetails/presentation/widgets/QuantitySelector.dart';
import 'package:flutter/material.dart';

final Product product = fakeProducts[0];

double get averageRating {
  if (product.comments.isEmpty) return 0.0;
  double total = 0;
  for (var r in product.comments) {
    total += r.rate;
  }
  return total / product.comments.length;
}

int get reviewCount => product.comments.length;

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String? sizeColorBoth;

  @override
  void initState() {
    super.initState();
    sizeColorBoth = product.productAttributeType.name;
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
        actions: const [
          Icon(Icons.favorite_border),
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
                child: Image.network(product.photoUrl, fit: BoxFit.cover),
              ),
              // التفاصيل
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.brand, style: AppStyles.styleRegular16Muted),
                    const SizedBox(height: 4),
                    Text(product.name, style: AppStyles.styleBold24Dark),
                    const SizedBox(height: 8),

                    // التقييم وعدد المراجعات
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < averageRating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 25,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          averageRating.toStringAsFixed(1),
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
                      '\$${product.price}',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // if condition to show available sizes/colors/both
                    //
                    //
                    //
                    //

                    // الألوان المتوفرة
                    if (sizeColorBoth == 'color')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Color ",
                            style: AppStyles.styleSemiBold18Dark,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children:
                                product.stock.keys.map<Widget>((color) {
                                  return GestureDetector(
                                    onTap: () {
                                      // يمكن إضافة وظيفة اختيار اللون هنا
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        color,
                                        style: AppStyles.styleSemiBold18Dark,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ],
                      ),
                    const SizedBox(height: 25),
                    Text("Quantity", style: AppStyles.styleSemiBold18Dark),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: QuantitySelector(
                        initialQuantity: 1,
                        min: 1,
                        max: product.quantity,
                        onChanged: (qty) {
                          // يمكن إضافة وظيفة تحديث الكمية هنا
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ProductDetailsExpandable(
                      description: product.description,
                      instruction: product.instruction,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductReviewsExpandableFull(comments: product.comments),
              ),
              // زر Add to Cart
              Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
