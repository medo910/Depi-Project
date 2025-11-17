import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:depi_app/core/models/user.dart'; // استبدل بالمسار الصحيح

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // فانكشن تجيب اسم اليوزر باستخدام userId
  Future<String?> getUserName(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore
              .collection(
                'users',
              ) // غير اسم الـ collection حسب الـ database بتاعك
              .doc(userId)
              .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['name'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting user name: $e');
      return null;
    }
  }

  // فانكشن تجيب اسم اليوزر الحالي (المسجل دخول)
  Future<String?> getCurrentUserName() async {
    try {
      // جلب الـ current user من Firebase Auth
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        print('No user logged in');
        return null;
      }

      // جلب اسم اليوزر من Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['fullName'] as String?;
      }
      return null;
    } catch (e) {
      print('Error getting current user name: $e');
      return null;
    }
  }

  // فانكشن تجيب الـ MyUser object للـ current user
  Future<MyUser?> getCurrentUser() async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        print('No user logged in');
        return null;
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        data['id'] = userDoc.id;
        return MyUser.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // فانكشن تجيب أي MyUser object باستخدام userId
  Future<MyUser?> getUser(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        data['id'] = userDoc.id;
        return MyUser.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // فانكشن تجيب الـ current user ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }
}
