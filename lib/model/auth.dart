import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/exception/AuthException.dart';

class Auth with ChangeNotifier {
  UserCredential? credential;
  DateTime? expiration;
  String? token;

  bool get isAuth {
    if (credential != null && expiration != null) {
      if (DateTime.now().compareTo(expiration!) == -1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> signup(String email, String senha) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException(message: 'Digite uma senha mais forte.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException(message: 'A conta ja existe.');
      }
    } catch (e) {
      throw AuthException(message: 'Tente novamente mais tarde.');
    }
  }

  Future<void> login(String email, String senha) async {
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);

      await credential!.user?.getIdTokenResult(false).then((value) {
        expiration = value.expirationTime ?? DateTime.now();
        token = value.token;
      });

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException(message: 'Usuario não encontrado.');
      } else if (e.code == 'wrong-password') {
        throw AuthException(message: 'Senha invalida.');
      }
    } catch (e) {
      throw AuthException(message: 'Tente novamente mais tarde.');
    }
  }
}
