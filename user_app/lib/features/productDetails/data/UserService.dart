import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/selectedProduct.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToCart(String userId, ProductSelected product) async {
    await _firestore.collection('users').doc(userId).update({
      'cart': FieldValue.arrayUnion([product.toMap()]),
    });
  }

  Future<bool> isProductInCart(String userId, ProductSelected product) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    List cart = userDoc['cart'] ?? [];
    return cart.any((item) => item['id'] == product.productId);
  }

  Future<void> increeseProductQuantity(
    String userId,
    String productId,
    int quantity,
  ) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    List cart = userDoc['cart'] ?? [];
    for (var item in cart) {
      if (item['id'] == productId) {
        item['quantity'] += quantity;
        break;
      }
    }
    await _firestore.collection('users').doc(userId).update({'cart': cart});
  }
}
