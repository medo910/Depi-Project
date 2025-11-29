import 'package:flutter/material.dart';

Widget buildOrderItem({
  required String id,
  required String date,
  required String price,
  required String status,
  required Color color,
  required context,
}) {
  return Column(
    children: [
      ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text('#$id', style:Theme.of(context).textTheme.headlineSmall),
        subtitle: Text(date),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              price,
              style:Theme.of(context).textTheme.bodyLarge
            ),
          ],
        ),
      ),
    ],
  );
}