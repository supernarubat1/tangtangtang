// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tangtangtang/providers/categoryProvider.dart';

class ExpenseTab extends StatefulWidget {
  const ExpenseTab({Key? key}) : super(key: key);

  @override
  State<ExpenseTab> createState() => _ExpenseTabState();
}

class _ExpenseTabState extends State<ExpenseTab> {
  List expList = [
    {"id": 1, "title": "อาหาร"},
    {"id": 2, "title": "เดินทาง"},
    {"id": 3, "title": "ที่พัก"},
    {"id": 4, "title": "ของใช้"},
    {"id": 5, "title": "ค่ารักษา"},
    {"id": 6, "title": "อาหารสัตว์"},
    {"id": 7, "title": "ค่ารักษาสัตว์"},
  ];

  @override
  Widget build(BuildContext context) {
    CategoryProvider catePro = Provider.of<CategoryProvider>(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.only(top: 6, left: 6, bottom: 6, right: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.09),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(border: InputBorder.none, hintText: "เพิ่มหมวดหมู่ใหม่"),
                  ),
                ),
              ),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  child: Icon(Icons.add),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: expList.length,
              padding: const EdgeInsets.all(6),
              itemBuilder: (context, int i) {
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: catePro.types == "exp" && catePro.selectCat == expList[i]["id"] ? Border.all(color: Colors.black, width: 2) : Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.09),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 6,
                          right: 6,
                          child: catePro.types == "exp" && catePro.selectCat == expList[i]["id"] ? Icon(Icons.check_circle_rounded) : Text(""),
                        ),
                        Center(child: Text(expList[i]["title"])),
                      ],
                    ),
                  ),
                  onTap: () {
                    catePro.setCat(cateId: expList[i]["id"], type: "exp");
                    Future.delayed(Duration(milliseconds: 400), () => Navigator.pop(context));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
