import 'package:depi_app/features/HomeScreen/data/repos/ProductService.dart';
import 'package:flutter/material.dart';
import 'package:depi_app/core/models/product.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: StreamBuilder<List<Product>>(
        stream: ProductService().getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products available"));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ListTile(
                leading: Image.network(p.photoUrl),
                title: Text(p.name),
                subtitle: Text("${p.price} EGP"),
              );
            },
          );
        },
      ),
    );
  }
}
