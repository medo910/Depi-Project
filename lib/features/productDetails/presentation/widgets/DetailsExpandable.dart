import 'package:flutter/material.dart';

class ProductDetailsExpandable extends StatelessWidget {
  final String description;
  final List<String> instruction;

  const ProductDetailsExpandable({
    super.key,
    required this.description,
    required this.instruction,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: Column(
        children: [
          ExpansionTile(
            title: const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Text(description, style: const TextStyle(height: 1.5)),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text(
              'Instruction',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            children:
                instruction.map<Widget>((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check, size: 16, color: Colors.green),
                        const SizedBox(width: 6),
                        Expanded(child: Text(e)),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
