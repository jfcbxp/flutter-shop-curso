import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/utils/app_routes.dart';

import '../model/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          automaticallyImplyLeading: false,
          title: Text('Bem vindo!'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Loja'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_OR_HOME);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Pedidos'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.ORDER);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Gerenciar Produtos'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.PRODUCT);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Sair'),
          onTap: () {
            Provider.of<Auth>(
              context,
              listen: false,
            ).logout();
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.AUTH_OR_HOME,
            );
          },
        ),
      ]),
    );
  }
}
