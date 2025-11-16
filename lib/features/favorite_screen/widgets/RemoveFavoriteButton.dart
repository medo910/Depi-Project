import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depi_app/core/cubit/FavoritesCubit/favorites_cubit.dart';
import 'package:depi_app/core/cubit/FavoritesCubit/favorites_state.dart';

class RemoveFavoriteButton extends StatelessWidget {
  final String productId;
  final double? size;

  const RemoveFavoriteButton({
    super.key,
    required this.productId,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        // لو لسه بيحمل الفيفوريت
        if (state.loading) {
          return SizedBox(
            width: size ?? 24,
            height: size ?? 24,
            child: const CircularProgressIndicator(strokeWidth: 2),
          );
        }

        // دايمًا أحمر لأن ده زر إزالة
        return GestureDetector(
          onTap: () {
            // إزالة المنتج من الفيفوريت وتحديث Cubit
            context.read<FavoritesCubit>().removeFavorite(productId);
          },
          child: Icon(
            Icons.favorite,
            color: Colors.red,
            size: size ?? 24,
          ),
        );
      },
    );
  }
}
