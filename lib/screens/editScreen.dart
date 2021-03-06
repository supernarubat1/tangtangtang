// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, avoid_print
// '${daySelect.year.toString().split(' ')[0]}-${daySelect.month.toString().split(' ')[0]}-${daySelect.day.toString().split(' ')[0]}',

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:tangtangtang/db/tangDb.dart';
import 'package:tangtangtang/models/addModel.dart';
import 'package:tangtangtang/providers/categoryProvider.dart';
import 'package:tangtangtang/screens/homeScreen.dart';
import 'package:tangtangtang/screens/tabs/expenseTab.dart';
import 'package:tangtangtang/screens/tabs/incomeTab.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);
  static const String id = "EditScreen";

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  bool isLoading = true;
  late AddModel myData;
  late CategoryProvider catePro;
  TangDb tangDb = TangDb.instance;
  DateTime daySelect = DateTime.now();
  var moneyCon = TextEditingController();
  var detailCon = TextEditingController();
  String date = "";
  String time = "";
  String catMode = "";
  String catId = "";
  String catName = "";
  String money = "0";
  String detail = "";
  String img64string = "";
  File? image;
  String imageSize = "";
  dynamic decodeImage;
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
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () => getData());
  }

  getData() async {
    DateTime myDateTime = DateTime.parse("${myData.date} ${myData.time}");
    catePro.modeCat = myData.catMode.toString();
    catePro.selectCat = int.parse(myData.catId.toString());
    catePro.currentTab = myData.catMode == "exp" ? 0 : 1;
    moneyCon.text = myData.money.toString();
    detailCon.text = myData.detail.toString();

    if (myData.image.toString() != "") {
      decodeImage = base64Decode(myData.image.toString());
    }

    setState(() {
      daySelect = myDateTime;
      isLoading = false;
    });
  }

  Future getImage(ImageSource ims) async {
    bool perCam = await Permission.camera.request().isGranted;
    bool perSto = await Permission.storage.request().isGranted;

    if (perCam && perSto) {
      final picker = await ImagePicker().pickImage(source: ims, imageQuality: 50, maxWidth: 1000, maxHeight: 1000);
      if (picker == null) return;

      setState(() => image = File(picker.path));

      final bytes = File(picker.path).readAsBytesSync().lengthInBytes;
      final kb = bytes / 1024;
      final mb = kb / 1024;

      if (kb.toInt() > 1024) {
        imageSize = '${mb.toStringAsFixed(2)} MB';
      } else {
        imageSize = '${kb.toStringAsFixed(2)} KB';
      }
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text("แจ้งเตือน"),
          content: Text("กรุณาเปิดสิทธิ์การใช้งาน"),
          actions: [
            TextButton(
              child: Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }

  myEdit(CategoryProvider catePro) async {
    date = DateFormat('yyyy-MM-dd').format(daySelect);
    time = DateFormat('HH:mm').format(daySelect);

    if (catePro.modeCat == "exp") {
      catMode = "exp";
      catId = expList[catePro.selectCat - 1]['id'].toString();
      catName = expList[catePro.selectCat - 1]['title'];
    }

    if (catePro.modeCat == "inc") {
      catMode = "inc";
      catId = incList[catePro.selectCat - 1]['id'].toString();
      catName = incList[catePro.selectCat - 1]['title'];
    }

    if (decodeImage != null) {
      img64string = myData.image.toString();
    } else if (image != null) {
      final bytes = await image!.readAsBytes();
      img64string = base64Encode(bytes);
    } else {
      img64string = "";
    }

    if (money == "0") money = myData.money.toString();
    if (detail == "") detail = myData.detail.toString();

    AddModel data = AddModel(
      id: myData.id,
      date: date,
      time: time,
      catMode: catMode,
      catId: catId,
      catName: catName,
      money: money,
      detail: detail,
      image: img64string,
    );

    final newEdit = await TangDb.instance.edit(data);

    if (newEdit > 0) {
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
    }
  }

  delete() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text("ลบรายการ"),
        content: Text("ต้องการลบรายการนี้ ใช่หรือไม่?"),
        actions: [
          TextButton(
            child: Text("ยกเลิก"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              "ตกลง",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              final del = await TangDb.instance.delete(myData.id!);
              if (del > 0) Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
            },
          ),
        ],
      ),
    );
  }

  back(CategoryProvider catePro) async {
    Navigator.pop(context);
    Future.delayed(Duration(milliseconds: 100), () {
      catePro.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    catePro = Provider.of<CategoryProvider>(context);
    myData = ModalRoute.of(context)!.settings.arguments as AddModel;

    return WillPopScope(
      onWillPop: () => back(catePro),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      myHeader(catePro),
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          children: [
                            myDateTime(),
                            SizedBox(height: 14),
                            myCategory(catePro),
                            SizedBox(height: 14),
                            myMoney(),
                            SizedBox(height: 14),
                            myDetail(),
                            SizedBox(height: 14),
                            myImage(),
                            SizedBox(height: 14),
                            catePro.modeCat != "null"
                                ? ElevatedButton(
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                                    child: Text("แก้ไข ${catePro.modeCat == 'exp' ? 'รายจ่าย' : 'รายรับ'}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    onPressed: () => myEdit(catePro),
                                  )
                                : Text(""),
                            TextButton(
                              child: Text("ลบรายการ"),
                              onPressed: () => delete(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget myImage() {
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
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.image, color: Colors.black, size: 40),
                  SizedBox(width: 6),
                  Text(
                    "รูปภาพ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        imageSize,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 300,
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: image == null && decodeImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                            child: Text("ถ่ายรูป", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            onPressed: () => getImage(ImageSource.camera),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black)),
                            child: Text("เลือกรูป", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            onPressed: () => getImage(ImageSource.gallery),
                          ),
                        ],
                      )
                    : image != null
                        ? Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                image: FileImage(image!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: FloatingActionButton(
                                elevation: 0,
                                mini: true,
                                backgroundColor: Color.fromARGB(100, 0, 0, 0),
                                child: Icon(Icons.close, color: Colors.white, size: 20),
                                onPressed: () => setState(() {
                                  image = null;
                                  imageSize = "";
                                }),
                              ),
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              image: DecorationImage(
                                image: MemoryImage(decodeImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: FloatingActionButton(
                                elevation: 0,
                                mini: true,
                                backgroundColor: Color.fromARGB(100, 0, 0, 0),
                                child: Icon(Icons.close, color: Colors.white, size: 20),
                                onPressed: () => setState(() {
                                  image = null;
                                  imageSize = "";
                                  decodeImage = null;
                                }),
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myDetail() {
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
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.assignment_rounded, color: Colors.black, size: 40),
              SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "รายละเอียด",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: TextField(
                        controller: detailCon,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.grey),
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: "...",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (d) => setState(() => detail = d),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget myMoney() {
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
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.monetization_on, color: Colors.black, size: 40),
              SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "จำนวนเงิน",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    // SizedBox(height: 2),
                    Container(
                      color: Colors.white,
                      child: TextField(
                        controller: moneyCon,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.grey),
                        keyboardType: TextInputType.number,
                        inputFormatters: [ThousandsFormatter()],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          hintText: "0",
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixText: "บาท",
                        ),
                        onChanged: (m) => setState(() => money = m),
                      ),
                    ),
                  ],
                ),
              ),
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
                                  catePro.modeCat == "exp" ? expList[catePro.selectCat - 1]['title'] : incList[catePro.selectCat - 1]['title'],
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                catePro.modeCat != "null"
                    ? Container(
                        padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8, top: 4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          catePro.modeCat == "exp" ? "รายจ่าย" : "รายรับ",
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

  Widget myHeader(CategoryProvider catePro) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
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
            onTap: () {
              Navigator.pop(context);
              Future.delayed(Duration(milliseconds: 100), () {
                catePro.clear();
              });
            },
          ),
          Text(
            "แก้ไขรายการ",
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

// Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(6),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.09),
//                             spreadRadius: 5,
//                             blurRadius: 7,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: SfDateRangePicker(
//                         selectionMode: DateRangePickerSelectionMode.single,
//                         showNavigationArrow: true,
//                         onSelectionChanged: (d) {
//                           print(d.value);
//                         },
//                       ),
//                     ),