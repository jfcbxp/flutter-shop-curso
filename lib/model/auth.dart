import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/exception/AuthException.dart';

class Auth with ChangeNotifier {
  Future<void> signup(String email, String senha) async {
    try {
      final credential =
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
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: senha);
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
