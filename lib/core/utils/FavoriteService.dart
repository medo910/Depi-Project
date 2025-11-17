import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/product.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// إضافة منتج للمفضلة
  Future<void> addToFavorite(String userId, String productId) async {
    final userRef = _firestore.collection('users').doc(userId);
    await userRef.set({
      'favorite': FieldValue.arrayUnion([productId]),
    }, SetOptions(merge: true));
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

  /// جلب كل الـ favorites
  Future<List<String>> getAllFavorites(String userId) async {
    try {
      final snapshot = await _firestore.collection("users").doc(userId).get();

      if (!snapshot.exists) return [];

      final data = snapshot.data();
      final favoriteList = data?['favorite'] as List<dynamic>? ?? [];

      return favoriteList.map((e) => e.toString()).toList();
    } catch (e) {
      print("Error in getAllFavorites: $e");
      return [];
    }
  }

  /// Stream للـ favorites IDs
  Stream<List<String>> favoriteIdsStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) return <String>[];
      final data = snapshot.data();
      final favoriteList = data?['favorite'] as List<dynamic>? ?? [];
      return favoriteList.map((e) => e.toString()).toList();
    });
  }

  /// Stream للـ favorite products
  Stream<List<Product>> favoriteProductsStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().asyncMap((
      snapshot,
    ) async {
      if (!snapshot.exists) return [];

      final favoriteIds = List<String>.from(snapshot.data()?['favorite'] ?? []);
      if (favoriteIds.isEmpty) return [];

      final productSnapshots =
          await _firestore
              .collection('products')
              .where(FieldPath.documentId, whereIn: favoriteIds)
              .get();

      return productSnapshots.docs
          .map((doc) => Product.fromMap(doc.data()))
          .toList();
    });
  }
}
