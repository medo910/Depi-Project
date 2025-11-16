import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/selectedProduct.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///  إضافة منتج للكارت
  Future<void> addToCart(String userId, ProductSelected product) async {
    await _firestore.collection('users').doc(userId).update({
      'cart': FieldValue.arrayUnion([product.toMap()]),
    });
  }

}






















  ///  حذف منتج من الكارت
  
  
  
  // Future<void> removeFromCart(String userId, ProductSelected product) async {
  //   await _firestore.collection('users').doc(userId).update({
  //     'cart': FieldValue.arrayRemove([product.toMap()]),
  //   });
  // }

  ///  زيادة كمية منتج داخل الكارت
  

  // Future<void> increaseQuantity(String userId, String productId) async {
  //   DocumentSnapshot userDoc =
  //       await _firestore.collection('users').doc(userId).get();

  //   List<dynamic> cart = List.from(userDoc['cart']);
  //   int index = cart.indexWhere((item) => item['productId'] == productId);

  //   if (index != -1) {
  //     cart[index]['productDetails']['quantity'] += 1;

  //     await _firestore.collection('users').doc(userId).update({
  //       'cart': cart,
  //     });
  //   }
  // }


  ///  تقليل الكمية (ولو وصلت 0 يشيل المنتج)
  
  
  
  
  // Future<void> decreaseQuantity(String userId, String productId) async {
  //   DocumentSnapshot userDoc =
  //       await _firestore.collection('users').doc(userId).get();

  //   List<dynamic> cart = List.from(userDoc['cart']);
  //   int index = cart.indexWhere((item) => item['productId'] == productId);

  //   if (index != -1) {
  //     cart[index]['productDetails']['quantity'] -= 1;

  //     // لو الكمية بقت 0 → احذف العنصر
  //     if (cart[index]['productDetails']['quantity'] <= 0) {
  //       cart.removeAt(index);
  //     }

  //     await _firestore.collection('users').doc(userId).update({
  //       'cart': cart,
  //     });
  //   }
  // }



  /// 🔍 الحصول على الكارت بالكامل
  
  
  
  // Future<List<ProductSelected>> getUserCart(String userId) async {
  //   DocumentSnapshot userDoc =
  //       await _firestore.collection('users').doc(userId).get();

  //   List<dynamic> cart = userDoc['cart'];

  //   return cart
  //       .map((prod) => ProductSelected.fromMap(prod as Map<String, dynamic>))
  //       .toList();
  // }