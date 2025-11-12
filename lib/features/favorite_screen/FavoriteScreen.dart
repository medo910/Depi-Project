import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite_border_outlined,
                    size: 30,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 5),
                  Text('Favorites', style: AppStyles.styleBold24Dark),
                  SizedBox(width: 5),
                  Text(
                    "(3)",
                    style: AppStyles.styleBold24Dark,
                  ), // Example count
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
