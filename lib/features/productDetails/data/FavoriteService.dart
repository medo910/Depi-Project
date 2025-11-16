import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/product.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// إضافة منتج للمفضلة
  Future<void> addToFavorite(String userId, String productId) async {
    final userRef = _firestore.collection('users').doc(userId);
    await userRef.update({
      'favorite': FieldValue.arrayUnion([productId]),
    });
  }

  /// إزالة منتج من المفضلة
  Future<void> removeFromFavorite(String userId, String productId) async {
    final userRef = _firestore.collection('users').doc(userId);
    await userRef.update({
      'favorite': FieldValue.arrayRemove([productId]),
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

  // Stream للاستماع للتغييرات في الـ favorites
  Stream<bool> favoriteStream(String userId, String productId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(productId)
        .snapshots()
        .map((snapshot) => snapshot.exists);
  }

  Future<List<String>> getAllFavorites(String userId) async {
    try {
      final snapshot =
          await _firestore
              .collection("users")
              .doc(userId)
              .collection("favorites")
              .get();

      // هنرجع الـ productId (الـ document ID)
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print("Error in getAllFavorites: $e");
      return [];
    }
  }

  Stream<List<Product>> favoriteProductsStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .asyncMap((snapshot) async {
          final favoriteIds = List<String>.from(snapshot['favorite'] ?? []);
          if (favoriteIds.isEmpty) return [];
          final productSnapshots =
              await FirebaseFirestore.instance
                  .collection('products')
                  .where(FieldPath.documentId, whereIn: favoriteIds)
                  .get();
          return productSnapshots.docs
              .map((doc) => Product.fromMap(doc.data()))
              .toList();
        });
  }

  Stream<List<String>> favoriteIdsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => d.id).toList());
  }
}
