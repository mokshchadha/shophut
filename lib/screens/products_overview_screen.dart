import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shophut/providers/cart.dart';
import 'package:shophut/providers/products.dart';
import 'package:shophut/screens/cart_screen.dart';
import 'package:shophut/widgets/badge.dart';

import '../widgets/products_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool showFavourites = false;
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              print(selectedValue);
              if (selectedValue == FilterOptions.Favourites) {
                setState(() {
                  showFavourites = true;
                });
              } else {
                setState(() {
                  showFavourites = false;
                });
              }
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => const [
              PopupMenuItem(
                  child: Text('Only Favourites'),
                  value: FilterOptions.Favourites),
              PopupMenuItem(child: Text('All Items'), value: FilterOptions.All),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
                child: ch != null ? ch : Text(''),
                value: cartData.itemsCount.toString(),
                color: Colors.amber),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: ProductsGrid(showFavourites),
    );
  }
}
