import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/features/chat/repositories/chat_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/core/utils/app_styles.dart';
import 'package:depi_app/features/HomeScreen/presentation/widgets/HorizontalCategoryButtons.dart';
import 'package:depi_app/features/HomeScreen/presentation/widgets/product_item.dart';
import 'package:depi_app/features/HomeScreen/data/repos/ProductService.dart';
import 'package:depi_app/core/models/product.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  List<Product> allProducts = [];
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenForIncomingMessages();
  }

  void listenForIncomingMessages() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: 'sent')
        .snapshots()
        .listen((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.update({'status': 'delivered'});
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ======= Header =======
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
                    icon: const Icon(Iconsax.setting_2_copy),
                    onPressed: () {
                      GoRouter.of(context).push(AppRouter.kSettings);
                    },
                  ),
                  StreamBuilder<int>(
                    stream: ChatRepository().getUnreadCountStream(),
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return IconButton(
                        onPressed: () {
                          GoRouter.of(context).push(AppRouter.kUserChat);
                        },
                        icon: Badge(
                          isLabelVisible: count > 0,
                          label: Text('$count'),
                          backgroundColor: Colors.red,
                          child: const Icon(Iconsax.message_text_copy),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ======= Search Bar =======
            Row(
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
                          onPressed: () {
                            // remove
                            AppRouter.router.go(AppRouter.kFavoriteScreen);
                            //
                          },
                          icon: const Icon(Icons.search),
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: const Text(
                              'Search for products...',
                              style: AppStyles.styleBold20Primary,
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
              ],
            ),
            const SizedBox(width: 8),

            const SizedBox(height: 16),

            // ======= Categories Buttons =======
            HorizontalCategoryButtons(
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),

            const SizedBox(height: 16),

            // ======= Products Grid / Empty State =======
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: AppColors.accent.withOpacity(0.5),
                child: StreamBuilder<List<Product>>(
                  stream: ProductService().getProductsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products found',
                          style: AppStyles.styleRegular12Muted,
                        ),
                      );
                    }

                    allProducts = snapshot.data!;

                    List<Product> filteredProducts =
                        selectedCategory == 'All'
                            ? allProducts
                            : allProducts
                                .where((p) => p.category == selectedCategory)
                                .toList();

                    if (filteredProducts.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products found in this category',
                          style: AppStyles.styleRegular12Muted,
                        ),
                      );
                    }

                    return GridView.builder(
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
                          productId: product.id,
                          userId: user!.uid,
                          productImage: product.photoUrl,
                          productName: product.name,
                          productRating: product.rate,
                          productReviews: product.reviews,
                          productPrice: product.price,
                          productType: product.category,
                          onTap: () async {
                            context.push(
                              AppRouter.kProductDetails,
                              extra: product,
                            );
                          },
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
    );
  }
}
