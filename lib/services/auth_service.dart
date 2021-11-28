import 'package:contact_app/constant/app_string.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> registerUser(String email, String password) async {
    try {
      // print('Email --> $email');
      // print('Password --> $password');

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // print('UserCredential --> ${userCredential.user}');

      User? user = userCredential.user;

      // print('User --> $user');

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == AppString.weekPassword) {
        print('The password provided is too weak.');
      } else if (e.code == AppString.emailAlreadyUse) {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == AppString.userNotFound) {
        print('No user found for that email.');
      } else if (e.code == AppString.wrongPassword) {
        print('Wrong password provided for that user.');
      }
    }
  }
}
