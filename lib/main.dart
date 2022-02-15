import 'package:flutter/material.dart';

import 'screens/product_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Hut App',
      theme: ThemeData(
        primaryColor: Colors.purple,
        accentColor: Colors.pink,
        primarySwatch: Colors.purple,
      ),
      home: ProductOverviewScreen(),
    );
  }
}
