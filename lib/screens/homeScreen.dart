// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:tangtangtang/utility/constants.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentScreen = 0;
  DateTime daySelect = DateTime.now();
  List data = [
    {'name': 'A', 'color': Colors.red},
    {'name': 'B', 'color': Colors.green},
    {'name': 'C', 'color': Colors.blue},
    {'name': 'D', 'color': Colors.green},
    {'name': 'E', 'color': Colors.red},
  ];

  @override
  void initState() {
    super.initState();
  }

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
              // SizedBox(height: 10),
              myDate(),
              SizedBox(height: 20),
              myData(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: myBottomBar(),
    );
  }

  Widget myBottomBar() {
    return BubbleBottomBar(
      currentIndex: currentScreen,
      fabLocation: BubbleBottomBarFabLocation.end,
      opacity: .2,
      elevation: 0,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      backgroundColor: Colors.transparent,
      tilesPadding: EdgeInsets.symmetric(vertical: 8),
      items: const [
        BubbleBottomBarItem(
          backgroundColor: Colors.red,
          icon: Icon(
            Icons.dashboard,
            color: Colors.black,
          ),
          activeIcon: Icon(
            Icons.dashboard,
            color: Colors.red,
          ),
          title: Text("Home"),
        ),
        BubbleBottomBarItem(
          badgeColor: Colors.red,
          backgroundColor: Colors.red,
          icon: Icon(
            Icons.dashboard,
            color: Colors.black,
          ),
          activeIcon: Icon(
            Icons.dashboard,
            color: Colors.red,
          ),
          title: Text("Home"),
        ),
        BubbleBottomBarItem(
          badgeColor: Colors.red,
          backgroundColor: Colors.red,
          icon: Icon(
            Icons.dashboard,
            color: Colors.black,
          ),
          activeIcon: Icon(
            Icons.dashboard,
            color: Colors.red,
          ),
          title: Text("Home"),
        ),
      ],
    );
  }

  Widget myData() {
    return Expanded(
      child: Stack(
        children: [
          Container(
            // padding: const EdgeInsets.all(14),
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(6),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.grey.withOpacity(0.1),
            //       spreadRadius: 5,
            //       blurRadius: 7,
            //       offset: Offset(0, 3),
            //     ),
            //   ],
            // ),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int i) {
                return Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: data[i]['color']),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(data[i]['name']),
                );
              },
            ),
          ),
          Positioned(
            child: HawkFabMenu(
              blur: 0,
              fabColor: Constants.COLOR_MAIN,
              backgroundColor: Colors.transparent,
              body: Text(''),
              items: [
                HawkFabMenuItem(
                  label: 'เพิ่มร่ายจ่าย',
                  icon: const Icon(Icons.monetization_on),
                  color: Colors.black,
                  labelColor: Colors.red,
                  labelBackgroundColor: Colors.transparent,
                  ontap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => DraggableScrollableSheet(
                        initialChildSize: 0.9,
                        maxChildSize: 0.9,
                        minChildSize: 0.5,
                        builder: (_, controller) => Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Text("A"),
                        ),
                      ),
                    );
                  },
                ),
                HawkFabMenuItem(
                  label: 'เพิ่มร่ายรับ',
                  icon: const Icon(Icons.account_balance_wallet),
                  color: Colors.black,
                  labelColor: Colors.green,
                  labelBackgroundColor: Colors.transparent,
                  ontap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget myDate() {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextButton(
          style: ButtonStyle(splashFactory: NoSplash.splashFactory),
          child: Row(children: [
            SizedBox(width: 10),
            Icon(Icons.date_range, color: Colors.black),
            SizedBox(width: 6),
            Text(
              // '${daySelect.year.toString().split(' ')[0]}-${daySelect.month.toString().split(' ')[0]}-${daySelect.day.toString().split(' ')[0]}',
              DateFormat.yMMMMEEEEd('th').format(daySelect),
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ]),
          onPressed: () {
            DatePicker.showDatePicker(
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
              onConfirm: (date) {
                setState(() => daySelect = date);
              },
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
          Row(
            children: const [
              SizedBox(width: 16),
              Icon(Icons.account_circle),
              SizedBox(width: 6),
              Text(
                "Tae",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            splashRadius: 20,
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
