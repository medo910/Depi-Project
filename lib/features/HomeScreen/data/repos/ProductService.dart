import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/product.dart';

class ProductService {
  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

  /// Stream — updates automatically if anything changes
  Stream<List<Product>> getProductsStream() {
    return productsRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  ///  Future — fetch once
  // Future<List<Product>> getProductsOnce() async {
  //   final snapshot = await productsRef.get();
  //   return snapshot.docs.map((doc) {
  //     return Product.fromMap(doc.data() as Map<String, dynamic>);
  //   }).toList();
  // }
}
