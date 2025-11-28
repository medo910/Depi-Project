import 'package:depi_app/core/cubit/FavoritesCubit/favorites_cubit.dart';
import 'package:depi_app/core/cubit/FavoritesCubit/favorites_state.dart';
import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/utils/FavoriteService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_app/core/models/product.dart';
import 'package:lottie/lottie.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final user = FirebaseAuth.instance.currentUser;
  late final theme=Theme.of(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:theme.scaffoldBackgroundColor,
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.loading && state.favorites.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<List<Product>>(
            stream: FavoriteService().favoriteProductsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(color: theme.cardColor),
                          height: 120,

                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                 Icon(
                                  Icons.favorite,
                                  color:theme.primaryColor,
                                  size: 26,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Favorites',
                                  style: theme.textTheme.headlineMedium
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Lottie.asset(
                        'assets/animations/Like.json',
                        width: 400,
                        height: 300,
                      ),
                      Text(
                        'No favorites yet',
                        style: theme.textTheme.displaySmall,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Save items you love to your favorites list',
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(height: 20),

                      Container(
                        color: theme.scaffoldBackgroundColor,
                        padding: const EdgeInsets.all(16),
                        width: 250,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:theme.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            AppRouter.router.go(AppRouter.kHome);
                          },

                          child: const Text(
                            'Start Shopping',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final products = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      decoration: BoxDecoration(color:theme.cardColor),
                      height: 120,

                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                             Icon(
                              Icons.favorite,
                              color: theme.primaryColor,
                              size: 26,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Favorites (${products.length})',
                              style: theme.textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return FavoriteProductCard(
                          product: product,
                          userId: user!.uid,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class FavoriteProductCard extends StatelessWidget {
  final Product product;
  final String userId;

  const FavoriteProductCard({
    Key? key,
    required this.product,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final theme=Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color:  Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      product.brand,
                      style: theme.textTheme.labelSmall,
                    ),
                    const Text(' 😊'),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${product.rate.toStringAsFixed(1)}(${product.reviews})',
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style:theme.textTheme.headlineSmall?.copyWith(color: theme.primaryColor),
                ),
              ],
            ),
          ),

          Column(
            children: [
              BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  return IconButton(
                    icon: Icon(
                      state.favorites.contains(product.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed:
                        state.loading
                            ? null
                            : () {
                              context.read<FavoritesCubit>().removeFavorite(
                                product.id,
                              );
                            },
                  );
                },
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon:  Icon(Icons.shopping_cart,color: theme.primaryColor,),
                  onPressed: () {
                    AppRouter.router.go(
                      AppRouter.kProductDetails,
                      extra: product,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
