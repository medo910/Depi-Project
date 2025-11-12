import 'package:depi_app/core/data/fake_data.dart';
import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/utils/app_styles.dart';
import 'package:depi_app/features/HomeScreen/presentation/widgets/HorizontalCategoryButtons.dart';
import 'package:depi_app/features/HomeScreen/presentation/widgets/product_item.dart';
import 'package:depi_app/features/productDetails/presentation/product_details.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';

  List<dynamic> getFilteredProducts() {
    if (selectedCategory == 'All') {
      return fakeProducts;
    }
    return fakeProducts
        .where((product) => product.category == selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = getFilteredProducts();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 15.0,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Kite',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search),
                            ),
                            Expanded(
                              child: GestureDetector(
                                child: const Text(
                                  'Search for products...',
                                  style: AppStyles.styleRegular12Muted,
                                ),
                                onTap: () {},
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.mic_none_rounded),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.camera_alt_outlined),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.backgroundGradientEnd,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.accent.withOpacity(0.5),
                      ),
                      child: IconButton(
                        onPressed: () {
                          AppRouter.router.go(AppRouter.kFavoriteScreen);
                        },
                        icon: const Icon(Icons.filter_alt_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              HorizontalCategoryButtons(
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Products Grid
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                color: AppColors.accent.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child:
                      filteredProducts.isEmpty
                          ? const Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(
                              child: Text(
                                'No products found in this category',
                                style: AppStyles.styleRegular12Muted,
                              ),
                            ),
                          )
                          : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.68,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = filteredProducts[index];
                              return ProductItem(
                                productImage: product.photoUrl,
                                productName: product.name,
                                productRating: product.rate,
                                productReviews: product.reviews,
                                productPrice: product.price,
                                productType: product.category,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              ProductDetails(product: product),
                                    ),
                                  );
                                },
                              );
                            },
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
