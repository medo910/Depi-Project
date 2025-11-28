import 'package:depi_app/core/cubit/FavoritesCubit/favorites_cubit.dart';
import 'package:depi_app/core/cubit/FavoritesCubit/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  final String userId;
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final String productType;
  final double productRating;
  final int productReviews;
  final VoidCallback? onTap;

  const ProductItem({
    super.key,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productType,
    required this.productRating,
    required this.productReviews,
    required this.userId,
    required this.productId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    late final theme=Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(
                    color: Colors.white,
                    child: Image.network(
                      productImage,
                      fit: BoxFit.fill,
                      height: 140,
                      width: double.infinity,
                      errorBuilder: (context, error, _) {
                        return Container(
                          height: 140,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, size: 50),
                        );
                      },
                    ),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      final isFav = state.favorites.contains(productId);

                      return GestureDetector(
                        onTap: () {
                          context.read<FavoritesCubit>().toggleFavorite(
                            productId,
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          radius: 16,
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "${productRating.toStringAsFixed(1)} ($productReviews reviews)",
                        style: theme.textTheme.labelSmall),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Text(
                    "\$${productPrice.toStringAsFixed(2)}",
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),

                  Text(
                    productType,
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
