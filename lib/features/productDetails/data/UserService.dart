import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/selectedProduct.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(String userId, ProductSelected product) async {
    await _firestore.collection('users').doc(userId).update({
      'cart': FieldValue.arrayUnion([product.toMap()]),
    });
  }

}