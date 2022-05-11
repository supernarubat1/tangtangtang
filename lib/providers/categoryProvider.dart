// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  // 0 หมายถึงยังไม่ได้เลือก
  int selectCat = 0;
  int currentTab = 0;
  String types = "null";

  void setCat({required int cateId, required String type}) {
    if (cateId != 0) {
      selectCat = cateId;
      types = type;
      if (type == "exp") {
        currentTab = 0;
      } else {
        currentTab = 1;
      }
    }

    notifyListeners();
  }
}
