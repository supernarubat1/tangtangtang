// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class IncomeTab extends StatefulWidget {
  const IncomeTab({Key? key}) : super(key: key);

  @override
  State<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends State<IncomeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text("INCOME"),
    );
  }
}
