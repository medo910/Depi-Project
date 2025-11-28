import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _GoogleSignInTestState();
}

class _GoogleSignInTestState extends State<Test> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      setState(() {
        user = userCredential.user;
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign-In Test')),
      body: Center(
        child:
            user == null
                ? ElevatedButton(
                  onPressed: signInWithGoogle,
                  child: const Text('Sign in with Google'),
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoURL ?? ''),
                      radius: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(user!.displayName ?? ''),
                    Text(user!.email.toString()),
                    ElevatedButton(
                      onPressed: () async {
                        await _auth.signOut();
                        await _googleSignIn.signOut();
                        setState(() => user = null);
                      },
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
      ),
    );
  }
}