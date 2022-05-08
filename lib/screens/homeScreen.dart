// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tangtangtang/utility/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              SizedBox(height: 10),
              myHeader(),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                color: Colors.blue,
                child: Center(
                  child: Text("Today"),
                ),
              ),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                color: Colors.green,
                child: Center(
                  child: Text("data"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          // color: Colors.red,
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "TangTangTang",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Tae",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
