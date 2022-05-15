// ignore_for_file: file_names, unnecessary_new, prefer_collection_literals, unnecessary_this

class AddModel {
  int? id;
  String? date;
  String? time;
  String? catMode;
  String? catId;
  String? catName;
  String? money;
  String? detail;
  String? image;

  AddModel({this.id, this.date, this.time, this.catMode, this.catId, this.catName, this.money, this.detail, this.image});

  AddModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    catMode = json['catMode'];
    catId = json['catId'];
    catName = json['catName'];
    money = json['money'];
    detail = json['detail'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['catMode'] = this.catMode;
    data['catId'] = this.catId;
    data['catName'] = this.catName;
    data['money'] = this.money;
    data['detail'] = this.detail;
    data['image'] = this.image;
    return data;
  }
}
