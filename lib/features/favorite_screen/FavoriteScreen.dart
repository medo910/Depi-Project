import 'package:depi_app/core/models/product.dart';
import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/utils/app_styles.dart';
import 'package:depi_app/features/favorite_screen/data/GetFavoriteService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final GetFavoriteService _favoriteService = GetFavoriteService();
  List<Product> favoritesProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final products = await _favoriteService.getFavoriteProducts(user!.uid);
      setState(() {
        favoritesProducts = products;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading favorites: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Favorites', style: AppStyles.styleBold24Dark),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 28,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8),
                  Text('Favorites', style: AppStyles.styleBold24Dark),
                  SizedBox(width: 4),
                  Text(
                    "(${favoritesProducts.length})",
                    style: AppStyles.styleBold24Dark,
                  ),
                ],
              ),
            ),

            // Products List
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFE8F5E9), // Light green background
                ),
                child:
                    isLoading
                        ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        )
                        : favoritesProducts.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No favorites yet!',
                                style: AppStyles.styleBold24Dark.copyWith(
                                  color: Colors.grey[600],
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: favoritesProducts.length,
                          itemBuilder: (context, index) {
                            final product = favoritesProducts[index];
                            return _buildFavoriteItem(product);
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteItem(Product product) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with yellow background
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFDD835), Color(0xFFFBC02D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  product.photoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.headphones,
                        size: 40,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 16),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),

                  // Brand
                  Text(
                    product.brand,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),

                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        '${product.rate}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '(${product.reviews})',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Price and Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      // Action Buttons
                      Row(
                        children: [
                          // Add to Cart Button
                          Container(
                            height: 40,
                            width: 95,
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  iconSize: 20,
                                  icon: Icon(Icons.shopping_cart_outlined),
                                  onPressed: () {
                                    context.push(
                                      AppRouter.kProductDetails,
                                      extra: product,
                                    );
                                  },
                                  color: Colors.black,
                                ),
                                Text(
                                  'Add',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 15),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          // Remove from Favorites Button
                          GestureDetector(
                            onTap: () => _removeFromFavorites(product.id),
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.favorite,
                                size: 20,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeFromFavorites(String productId) async {
    if (user == null) return;

    try {
      // Show loading
      setState(() => isLoading = true);

      // Remove from Firestore
      await _favoriteService.removeFromFavorites(user!.uid, productId);

      // Reload favorites
      await _loadFavorites();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed from favorites'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error removing from favorites: $e');
      setState(() => isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove from favorites'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
