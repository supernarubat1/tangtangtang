// ignore_for_file: file_names, unused_field

import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
  // 0 หมายถึงยังไม่ได้เลือก
  int selectCat = 0;
  int currentTab = 0;
  String modeCat = "null";

  void setCat({required int id, required String mode}) {
    if (id != 0) {
      selectCat = id;
      modeCat = mode;
      if (mode == "exp") {
        currentTab = 0;
      } else {
        currentTab = 1;
      }
    }

    notifyListeners();
  }

  void clear() {
    selectCat = 0;
    currentTab = 0;
    modeCat = "null";

    notifyListeners();
  }
}
