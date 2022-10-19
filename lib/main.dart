import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/cart.dart';
import 'package:shop/model/order_list.dart';
import 'package:shop/model/product_list.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/orders_page.dart';
import 'package:shop/pages/product_datail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/product_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductList()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => OrderList())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Minha Loja',
        theme: tema.copyWith(
          colorScheme: tema.colorScheme.copyWith(
            primary: Colors.purple,
            secondary: Colors.amber[800],
          ),
          textTheme: tema.textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'Anton',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'Lato',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        routes: {
          AppRoutes.PRODUCT_DATAIL: (ctx) => ProductDetailPage(),
          AppRoutes.CART: (ctx) => CartPage(),
          AppRoutes.HOME: (ctx) => ProductsOverviewPage(),
          AppRoutes.ORDER: (ctx) => OrderPage(),
          AppRoutes.PRODUCT: (ctx) => ProductPage(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormPage(),
        },
      ),
    );
  }
}
