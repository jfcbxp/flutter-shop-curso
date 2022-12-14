import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromRGBO(215, 117, 255, 0.5),
            Color.fromRGBO(255, 188, 117, 0.9)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        ),
        Center(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 100),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, 2))
                          ],
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context).colorScheme.primary),
                      child: Text(
                        'Minha Loja',
                        style: TextStyle(
                            fontSize: 45,
                            fontFamily: 'Anton',
                            color: Colors.white),
                      ),
                    ),
                    AuthForm()
                  ]),
            ),
          ),
        )
      ]),
    );
  }
}
