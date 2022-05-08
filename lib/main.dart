import 'package:flutter/material.dart';
import 'package:tangtangtang/screens/homeScreen.dart';
import 'package:tangtangtang/screens/initialScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final routes = {
    InitialScreen.id: (_) => const InitialScreen(),
    HomeScreen.id: (_) => const HomeScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TangTangTang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: routes,
      home: const InitialScreen(),
    );
  }
}
