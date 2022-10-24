import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/data/store.dart';
import 'package:shop/exception/AuthException.dart';

class Auth with ChangeNotifier {
  UserCredential? credential;
  DateTime? expiration;
  String? token;
  Timer? _logotTimer;

  bool get isAuth {
    if (token != null && expiration != null) {
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
      login(email, senha);
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
        final secondsToLogout =
            expiration?.difference(DateTime.now()).inSeconds;
        Store.saveString('email', email);
        Store.saveString('senha', senha);
        Store.saveString('token', token ?? '');
        //  _logotTimer = Timer(Duration(seconds: secondsToLogout ?? 0), logout());
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

  Future<void> autoLogin() async {
    if (!isAuth) {
      final email = await Store.getString('email');
      final senha = await Store.getString('senha');
      final token = await Store.getString('token');
      if (email.isNotEmpty && senha.isNotEmpty) {
        await login(email, senha);
      }
    }
  }

  logout() {
    FirebaseAuth.instance.signOut();
    _logotTimer?.cancel();
    _logotTimer = null;
    credential = null;
    expiration = null;
    token = "";
    Store.remove('email');
    Store.remove('senha');
    Store.remove('token');
    notifyListeners();
  }
}
