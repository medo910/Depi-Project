import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<User?> signUp(String email, String password, String fullName) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'fullName': fullName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await user.updateDisplayName(fullName);
    }
    return user;
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  Future<User?> signInWithGoogle(context) async {
    try {
      await signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }
      print("Google user picked: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      return userCredential.user;
    } on Exception catch (e) {
      // TODO
      throw Exception('Google Sign-In failed: $e');
    }
  }

  User? get currentUser => _firebaseAuth.currentUser;
}
