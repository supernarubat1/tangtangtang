// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables
// '${daySelect.year.toString().split(' ')[0]}-${daySelect.month.toString().split(' ')[0]}-${daySelect.day.toString().split(' ')[0]}',

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:tangtangtang/providers/categoryProvider.dart';
import 'package:tangtangtang/screens/tabs/expenseTab.dart';
import 'package:tangtangtang/screens/tabs/incomeTab.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);
  static const String id = "AddScreen";

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  DateTime daySelect = DateTime.now();
  List expList = [
    {"id": 1, "title": "อาหาร"},
    {"id": 2, "title": "เดินทาง"},
    {"id": 3, "title": "ที่พัก"},
    {"id": 4, "title": "ของใช้"},
    {"id": 5, "title": "ค่ารักษา"},
    {"id": 6, "title": "อาหารสัตว์"},
    {"id": 7, "title": "ค่ารักษาสัตว์"},
  ];
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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              myHeader(),
              SizedBox(height: 10),
              myDateTime(),
              SizedBox(height: 14),
              myCategory(catePro),
              SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget myCategory(CategoryProvider catePro) {
    return Center(
      child: Container(
        width: double.infinity,
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
        child: TextButton(
          style: ButtonStyle(splashFactory: NoSplash.splashFactory),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.category, color: Colors.black, size: 40),
                SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "หมวดหมู่",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 2),
                      catePro.selectCat == 0
                          ? Text(
                              "กรุณาเลือกหมวดหมู่",
                              style: TextStyle(color: Colors.grey),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  catePro.types == "exp" ? expList[catePro.selectCat - 1]['title'] : incList[catePro.selectCat - 1]['title'],
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                catePro.types != "null"
                    ? Container(
                        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          catePro.types == "exp" ? "รายจ่าย" : "รายรับ",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Text(""),
              ],
            ),
          ),
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: context,
              builder: (context) => DraggableScrollableSheet(
                initialChildSize: 0.9,
                maxChildSize: 0.9,
                minChildSize: 0.5,
                builder: (_, controller) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                    ),
                    child: DefaultTabController(
                      initialIndex: catePro.currentTab,
                      length: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 14),
                          Text(
                            "หมวดหมู่",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 14),
                          TabBar(
                            physics: BouncingScrollPhysics(),
                            tabs: [
                              Tab(text: "รายจ่าย"),
                              Tab(text: "รายรับ"),
                            ],
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            indicator: RectangularIndicator(
                              verticalPadding: 2,
                              horizontalPadding: 20,
                              bottomLeftRadius: 100,
                              bottomRightRadius: 100,
                              topLeftRadius: 100,
                              topRightRadius: 100,
                            ),
                          ),
                          SizedBox(height: 14),
                          Expanded(
                            child: TabBarView(
                              physics: BouncingScrollPhysics(),
                              children: [
                                ExpenseTab(),
                                IncomeTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget myDateTime() {
    return Center(
      child: Container(
        width: double.infinity,
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
        child: TextButton(
          style: ButtonStyle(splashFactory: NoSplash.splashFactory),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.date_range, color: Colors.black, size: 40),
                SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "วันที่และเวลา",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        // '${daySelect.year.toString().split(' ')[0]}-${daySelect.month.toString().split(' ')[0]}-${daySelect.day.toString().split(' ')[0]}',
                        DateFormat.yMMMMEEEEd('th').add_Hm().format(daySelect),
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {
            DatePicker.showDateTimePicker(
              context,
              showTitleActions: true,
              minTime: DateTime(2022, 1, 1),
              maxTime: DateTime(2030, 1, 1),
              theme: DatePickerTheme(
                itemStyle: TextStyle(color: Colors.black),
                doneStyle: TextStyle(color: Colors.black),
              ),
              currentTime: daySelect,
              locale: LocaleType.th,
              onConfirm: (date) => setState(() => daySelect = date),
            );
          },
        ),
      ),
    );
  }

  Widget myHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          // color: Colors.red,
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(4),
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
              child: Icon(Icons.keyboard_arrow_left, size: 28),
            ),
            onTap: () => Navigator.pop(context),
          ),
          Text(
            "เพิ่มรายการ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.account_circle),
        ],
      ),
    );
  }
}
