import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/product.dart';

class GetFavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// جلب قائمة معرفات المفضلة
  Future<List<String>> getFavoriteIds(String userId) async {
    final snapshot = await _firestore.collection('users').doc(userId).get();
    if (!snapshot.exists) return [];

    final data = snapshot.data();
    final favoriteList = data?['favorite'] as List<dynamic>? ?? [];
    return favoriteList.map((e) => e.toString()).toList();
  }

  /// جلب المنتجات المفضلة كاملة
  Future<List<Product>> getFavoriteProducts(String userId) async {
    try {
      // جلب معرفات المنتجات المفضلة
      final favoriteIds = await getFavoriteIds(userId);
      
      if (favoriteIds.isEmpty) return [];

      // جلب المنتجات من Firestore
      List<Product> products = [];
      
      for (String productId in favoriteIds) {
        final productDoc = await _firestore
            .collection('products')
            .doc(productId)
            .get();
        
        if (productDoc.exists) {
          products.add(Product.fromMap(productDoc.data()!));
        }
      }
      
      return products;
    } catch (e) {
      print('Error fetching favorite products: $e');
      return [];
    }
  }

  /// حذف منتج من المفضلة
  Future<void> removeFromFavorites(String userId, String productId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favorite': FieldValue.arrayRemove([productId])
      });
    } catch (e) {
      print('Error removing from favorites: $e');
      rethrow;
    }
  }

  /// إضافة منتج للمفضلة
  Future<void> addToFavorites(String userId, String productId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'favorite': FieldValue.arrayUnion([productId])
      });
    } catch (e) {
      print('Error adding to favorites: $e');
      rethrow;
    }
  }

  /// التحقق إذا كان المنتج في المفضلة
  Future<bool> isFavorite(String userId, String productId) async {
    try {
      final favoriteIds = await getFavoriteIds(userId);
      return favoriteIds.contains(productId);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }
}