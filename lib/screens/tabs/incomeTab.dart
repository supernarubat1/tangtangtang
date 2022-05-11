// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tangtangtang/providers/categoryProvider.dart';

class IncomeTab extends StatefulWidget {
  const IncomeTab({Key? key}) : super(key: key);

  @override
  State<IncomeTab> createState() => _IncomeTabState();
}

class _IncomeTabState extends State<IncomeTab> {
  List incList = [
    {"id": 1, "title": "เงินเดือน"},
    {"id": 2, "title": "ขายของ"},
    {"id": 3, "title": "กู้ยืม"},
    {"id": 4, "title": "ของขวัญ"},
    {"id": 5, "title": "ขโมย"},
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
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
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
              itemCount: incList.length,
              padding: const EdgeInsets.all(6),
              itemBuilder: (context, int i) {
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: catePro.types == "inc" && catePro.selectCat == incList[i]["id"] ? Border.all(color: Colors.black, width: 2) : Border.all(color: Colors.transparent),
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
                          child: catePro.types == "inc" && catePro.selectCat == incList[i]["id"] ? Icon(Icons.check_circle_rounded) : Text(""),
                        ),
                        Center(child: Text(incList[i]["title"])),
                      ],
                    ),
                  ),
                  onTap: () {
                    catePro.setCat(cateId: incList[i]["id"], type: "inc");
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
