import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());

  Future<void> loadUserProfile() async {
    emit(UserProfileLoading());

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final data = doc.data();

      if (data == null) {
        emit(UserProfileError("User not found"));
        return;
      }

      emit(UserProfileLoaded(
        name: data['fullName'],
        email: data['email'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        cart:  (data['cart'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList() ?? [],
        favorite:  (data['favorite'] as List<String>?)
            ?.map((e) => e)
            .toList() ?? [],
      ));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }
}
