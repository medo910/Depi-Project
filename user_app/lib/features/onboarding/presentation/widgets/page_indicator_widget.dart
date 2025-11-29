import 'package:flutter/material.dart';

class PageIndicatorsWidget extends StatelessWidget {
  final int total;
  final int current;

  const PageIndicatorsWidget({
    super.key,
    required this.total,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),

          // المسافة بينهم نسبية بسيطة
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 12 : 8, // الحجم الثابت هنا مقبول للـ indicators
          height: isActive ? 12 : 8,
          decoration: BoxDecoration(
            color:
                isActive
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
