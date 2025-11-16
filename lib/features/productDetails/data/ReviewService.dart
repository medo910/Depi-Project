import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/product.dart';
import 'package:depi_app/core/models/review.dart';

class ProductReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// إضافة تعليق وتحديث rate وعدد التعليقات
  Future<void> addReviewToProduct(String productId, Review review) async {
    final docRef = _firestore.collection('products').doc(productId);

    // 1️⃣ أضف التعليق إلى comments
    await docRef.update({
      'comments': FieldValue.arrayUnion([review.toMap()]),
    });

    // 2️⃣ احصل على جميع التعليقات الحالية لحساب المعدل
    final docSnapshot = await docRef.get();
    final data = docSnapshot.data();
    if (data == null) return;

    final commentsData = (data['comments'] as List<dynamic>?) ?? [];
    final comments = commentsData.map((e) => Review.fromMap(e)).toList();

    // 3️⃣ حساب المعدل
    double totalRate = comments.fold(0, (sum, r) => sum + r.rate);
    double avgRate = comments.isEmpty ? 0.0 : totalRate / comments.length;

    // 4️⃣ تحديث معدل التقييم وعدد المراجعات
    await docRef.update({
      'rate': avgRate,
      'reviews': comments.length,
    });
  }

  /// Stream لمتابعة تغييرات المنتج
  Stream<Product> getProductStream(String productId) {
    return _firestore
        .collection('products')
        .doc(productId)
        .snapshots()
        .map((snapshot) => Product.fromMap(snapshot.data()!));
  }
}
