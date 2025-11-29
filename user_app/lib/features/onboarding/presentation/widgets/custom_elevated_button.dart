// import 'package:flutter/material.dart';

// class CustomElevatedButton extends StatelessWidget {
//   const CustomElevatedButton({
//     super.key,
//     this.onPressed,
//     required this.slides,
//     required this.currentPage,
//   });
//   final void Function()? onPressed;
//   final int slides;
//   final int currentPage;
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Theme.of(context).primaryColor,
//         padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//       child: Row(
//         children: [
//           Text(
//             currentPage == slides - 1 ? 'Get Started' : 'Next',
//             style: const TextStyle(fontSize: 16, color: Colors.white),
//           ),
//           const SizedBox(width: 6),
//           const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
//         ],
//       ),
//     );
//   }
// }

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
    final size = MediaQuery.sizeOf(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        // Padding يعتمد على عرض وطول الشاشة
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.08,
          vertical: size.height * 0.015,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // عشان الزرار مياخدش عرض زيادة
        children: [
          Text(
            currentPage == slides - 1 ? 'Get Started' : 'Next',
            style: TextStyle(
              fontSize: size.width * 0.04, // حجم الخط
              color: Colors.white,
            ),
          ),
          SizedBox(width: size.width * 0.015),
          Icon(
            Icons.arrow_forward_ios,
            size: size.width * 0.04,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
