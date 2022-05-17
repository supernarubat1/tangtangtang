// ignore_for_file: prefer_const_constructors, file_names, avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:tangtangtang/db/tangDb.dart';
import 'package:tangtangtang/models/addModel.dart';
import 'package:tangtangtang/screens/addScreen.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:tangtangtang/screens/editScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = "HomeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentScreen = 0;
  DateTime daySelect = DateTime.now();
  Uint8List? myImage;
  List<AddModel> listAdd = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // getData();
    getByDate(daySelect);
  }

  getData() async {
    final data = await TangDb.instance.getAll();
    for (var element in data) {
      final d = AddModel.fromJson(element);
      listAdd.add(d);
    }
    setState(() => isLoading = false);
  }

  getByDate(DateTime date) async {
    setState(() => isLoading = true);
    listAdd.clear();
    String myDate = DateFormat('yyyy-MM-dd').format(date);
    final data = await TangDb.instance.getByDate(myDate);
    if (data != null) {
      for (var element in data) {
        final d = AddModel.fromJson(element);
        listAdd.add(d);
      }
    }
    setState(() {
      daySelect = date;
      isLoading = false;
    });
  }

  // showData(AddModel _listAdd) {
  //   dynamic decodeImage;
  //   if (_listAdd.image.toString() != "") {
  //     decodeImage = base64Decode(_listAdd.image.toString());
  //   } else {
  //     decodeImage = 'assets/images/no-image.jpg';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0, left: 14, right: 14, top: 14),
          child: Column(
            children: [
              myHeader(),
              SizedBox(height: 10),
              myDate(),
              SizedBox(height: 20),
              isLoading ? CircularProgressIndicator() : myData(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: myBottomBar(),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        child: Icon(Icons.add, size: 26),
        onPressed: () => Navigator.pushNamed(context, AddScreen.id),
      ),
    );
  }

  Widget myBottomBar() {
    return BubbleBottomBar(
      currentIndex: currentScreen,
      fabLocation: BubbleBottomBarFabLocation.end,
      opacity: 0.2,
      elevation: 0,
      // borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      backgroundColor: Colors.transparent,
      tilesPadding: EdgeInsets.symmetric(vertical: 10),
      items: const [
        BubbleBottomBarItem(
          backgroundColor: Colors.black,
          icon: Icon(
            Icons.home,
            color: Colors.black,
          ),
          activeIcon: Icon(
            Icons.home,
            color: Colors.black,
          ),
          title: Text("Home"),
        ),
        BubbleBottomBarItem(
          badgeColor: Colors.black,
          backgroundColor: Colors.black,
          icon: Icon(
            Icons.message,
            color: Colors.black,
          ),
          activeIcon: Icon(
            Icons.message,
            color: Colors.black,
          ),
          title: Text("Home"),
        ),
        BubbleBottomBarItem(
          badgeColor: Colors.black,
          backgroundColor: Colors.black,
          icon: Icon(
            Icons.settings,
            color: Colors.black,
          ),
          activeIcon: Icon(
            Icons.settings,
            color: Colors.black,
          ),
          title: Text("Home"),
        ),
      ],
    );
  }

  Widget myData() {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: listAdd.length,
        itemBuilder: (BuildContext context, int i) {
          dynamic decodeImage;
          if (listAdd[i].image.toString() != "") {
            decodeImage = base64Decode(listAdd[i].image.toString());
          } else {
            decodeImage = 'assets/images/no-image.jpg';
          }

          return Container(
            padding: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.09),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      left: BorderSide(
                        color: listAdd[i].catMode == "exp" ? Colors.black : Colors.grey,
                        width: 6,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          listAdd[i].image.toString() != ""
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.memory(
                                    decodeImage,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.asset(
                                    decodeImage,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      listAdd[i].catName.toString(),
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 4),
                                      decoration: BoxDecoration(
                                        color: listAdd[i].catMode == "exp" ? Colors.black : Colors.grey,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        listAdd[i].catMode == "exp" ? "รายจ่าย" : "รายรับ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${listAdd[i].money.toString()} บาท",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(listAdd[i].detail.toString()),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('${listAdd[i].time.toString()} น'),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () => Navigator.pushNamed(context, EditScreen.id, arguments: listAdd[i]),
            ),
          );
        },
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
              color: Colors.grey.withOpacity(0.09),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: TextButton(
          style: ButtonStyle(splashFactory: NoSplash.splashFactory),
          child: Row(children: [
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
              onConfirm: (date) => getByDate(date),
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
              child: Icon(Icons.more_vert, size: 28),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
