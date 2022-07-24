import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shophut/providers/products.dart';
import 'package:shophut/widgets/app_drawer.dart';
import 'package:shophut/widgets/user_product_item.dart';

import 'edit_products_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _onRefresh(ctx) {
    return Provider.of<Products>(ctx, listen: false).fetchAndStoreProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemBuilder: (ctx, idx) => Column(
                children: [
                  UserProductItem(
                      productsData.items[idx].id,
                      productsData.items[idx].title,
                      productsData.items[idx].imageUrl),
                  Divider()
                ],
              ),
              itemCount: productsData.items.length,
            ),
          ),
        ));
  }
}
