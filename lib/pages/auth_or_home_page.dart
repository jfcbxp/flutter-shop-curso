import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/auth.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/products_overview_page.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
        future: auth.autoLogin(),
        builder: (ctx, snapshop) {
          if (snapshop.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return auth.isAuth ? ProductsOverviewPage() : AuthPage();
          }
        });
  }
}
