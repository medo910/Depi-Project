import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// إضافة منتج للمفضلة
  Future<void> addToFavorite(String userId, String productId) async {
    final userRef = _firestore.collection('users').doc(userId);
    await userRef.update({
      'favorite': FieldValue.arrayUnion([productId])
    });
  }

  /// إزالة منتج من المفضلة
  Future<void> removeFromFavorite(String userId, String productId) async {
    final userRef = _firestore.collection('users').doc(userId);
    await userRef.update({
      'favorite': FieldValue.arrayRemove([productId])
    });
  }

  /// التحقق إذا المنتج في المفضلة
  Future<bool> isFavorite(String userId, String productId) async {
    final snapshot = await _firestore.collection('users').doc(userId).get();
    if (!snapshot.exists) return false;

    final data = snapshot.data();
    final favoriteList = data?['favorite'] as List<dynamic>? ?? [];
    return favoriteList.contains(productId);
  }



  /// toggle (إضافة أو إزالة حسب الحالة الحالية)
  Future<void> toggleFavorite(String userId, String productId) async {
    final isFav = await isFavorite(userId, productId);
    if (isFav) {
      await removeFromFavorite(userId, productId);
    } else {
      await addToFavorite(userId, productId);
    }
  }
}


  /// جلب قائمة المفضلة


  // Future<List<String>> getFavorites(String userId) async {
  //   final snapshot = await _firestore.collection('users').doc(userId).get();
  //   if (!snapshot.exists) return [];

  //   final data = snapshot.data();
  //   final favoriteList = data?['favorite'] as List<dynamic>? ?? [];
  //   return favoriteList.map((e) => e.toString()).toList();
  // }