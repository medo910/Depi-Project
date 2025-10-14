import 'package:depi_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.slides,
    required this.currentPage,
  });
  final void Function()? onPressed;
  final int slides;
  final int currentPage;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        children: [
          Text(
            currentPage == slides - 1 ? 'Get Started' : 'Next',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
        ],
      ),
    );
  }
}
