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
    {'name': 'A', 'color': Colors.grey},
    {'name': 'B', 'color': Colors.grey},
    {'name': 'C', 'color': Colors.black},
    {'name': 'D', 'color': Colors.grey},
    {'name': 'E', 'color': Colors.black},
  ];

  Uint8List? myImage;

  List<AddModel> listAdd = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    final data = await TangDb.instance.getAll();

    for (var element in data) {
      AddModel d = AddModel.fromJson(element);
      // print(data.id);
      listAdd.add(d);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              myImage != null ? Image.memory(myImage!) : Text("data"),
              // SizedBox(height: 10),
              myHeader(),
              SizedBox(height: 10),
              myDate(),
              SizedBox(height: 20),
              myData(),
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
      opacity: .2,
      elevation: 0,
      // borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      backgroundColor: Colors.transparent,
      tilesPadding: EdgeInsets.symmetric(vertical: 8),
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
        itemCount: isLoading ? 0 : listAdd.length,
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
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: listAdd[i].image.toString() != ""
                          ? CircleAvatar(
                              radius: 27,
                              backgroundImage: MemoryImage(decodeImage),
                            )
                          : CircleAvatar(
                              radius: 27,
                              backgroundImage: AssetImage(decodeImage),
                            ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(listAdd[i].catName.toString()),
                        SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "${listAdd[i].money.toString()} บาท",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                    subtitle: Text(listAdd[i].detail.toString()),
                    trailing: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            listAdd[i].catMode == "exp" ? "รายจ่าย" : "รายรับ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(listAdd[i].time.toString()),
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () => getData(),
              // onTap: () async {
              //   AddModel getData = await TangDb.instance.getById(1);
              //   final decodeBytes = base64Decode(getData.image.toString());
              //   setState(() {
              //     myImage = decodeBytes;
              //   });
              // },
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
