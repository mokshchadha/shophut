import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem({required this.id, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: Image.network(imageUrl, fit: BoxFit.cover),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: TextButton.icon(
                onPressed: () {}, icon: Icon(Icons.favorite), label: Text('')),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            trailing: TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.shopping_bag),
                label: Text('')),
          )),
    );
  }
}
