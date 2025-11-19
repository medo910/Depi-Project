// import 'package:flutter/material.dart';
//
// Widget buildStatCard(String number, String label) {
//   return Expanded(
//     child: Card(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15),
//         child: Column(
//           children: [
//             Text(
//               number,
//               style: const TextStyle(
//                 fontSize: 24,
//                 color: Color(0xFF80AF81),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               label,
//               style: const TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';

Widget buildStatCard(BuildContext context, String number, String label) {
  final theme = Theme.of(context);

  return Expanded(
    child: Card(
      color:  theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 24,
                color:  Color(0xFF80AF81),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style:  theme.textTheme.bodyMedium, // نص الثيم الأساسي
            ),
          ],
        ),
      ),
    ),
  );
}
