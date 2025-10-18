import 'package:depi_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class PageIndicatorsWidget extends StatelessWidget {
  final int total;
  final int current;

  const PageIndicatorsWidget({required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 12 : 8,
          height: isActive ? 12 : 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
