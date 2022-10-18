import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/badge.dart';
import 'package:shop/model/cart.dart';
import 'package:shop/model/product_list.dart';
import 'package:shop/utils/app_routes.dart';

import '../components/product_grid.dart';

enum FilterOptions { Favorite, All }

class ProductsOverviewPage extends StatelessWidget {
  ProductsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente Favoritos'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.All,
              )
            ],
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favorite) {
                provider.showFavoriteOnly();
              } else {
                provider.showAll();
              }
            },
          ),
          Consumer<Cart>(
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.CART);
                  },
                  icon: Icon(Icons.shopping_cart)),
              builder: (ctx, cart, child) => Badge(
                    value: cart.itemsCount.toString(),
                    child: child!,
                  ))
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ProductGrid(),
      ),
      drawer: AppDrawer(),
    );
  }
}
