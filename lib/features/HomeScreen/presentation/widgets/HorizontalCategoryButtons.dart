import 'package:depi_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class HorizontalCategoryButtons extends StatefulWidget {
  final Function(String) onCategorySelected;

  const HorizontalCategoryButtons({
    super.key,
    required this.onCategorySelected,
  });

  @override
  _HorizontalCategoryButtonsState createState() =>
      _HorizontalCategoryButtonsState();
}

class _HorizontalCategoryButtonsState extends State<HorizontalCategoryButtons> {
  final List<String> categories = [
    "All",
    "Grocery",
    "Electronics",
    "Apparel",
    "Sports",
    "Books",
    "Toys",
  ];

  int? selectedIndex = 0; // All هو الافتراضي

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;

          Color bgColor =
              isSelected ? AppColors.accent : AppColors.accent.withOpacity(0.5);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                // بعت الكاتيجوري المختار للـ HomeScreen
                widget.onCategorySelected(categories[index]);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
