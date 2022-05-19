// ignore_for_file: file_names, unused_field

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/addModel.dart';

// สร้าง class จัดการข้อมูล
class TangDb {
  String tbAdd = "add";

  // กำหนดตัวแปรฐานข้อมูล
  static Database? _database;
  // กำหนดตัวแปรสำหรับอ้างอิงฐานข้อมูล
  static final TangDb instance = TangDb._init();

  TangDb._init();

  Future<Database> get database async {
    // ถ้ามีฐานข้อมูลนี้แล้วคืนค่า
    if (_database != null) return _database!;
    // ถ้ายังไม่มี สร้างฐานข้อมูล กำหนดชื่อ นามสกุล .db
    _database = await _initDB("tang.db");
    // คืนค่าฐานข้อมูล
    return _database!;
  }

  // ฟังก์ชั่นสร้างฐานข้อมูล รับชื่อไฟล์ที่กำหนดเข้ามา
  Future<Database> _initDB(String filePath) async {
    // หาตำแหน่งที่จะจัดเก็บในระบบ ที่เตรียมไว้ให้
    Directory? dbPath = await getExternalStorageDirectory();
    // ต่อกับชื่อที่ส่งมา จะเป็น path เต็มของไฟล์
    final path = join(dbPath!.path, filePath);
    // สร้างฐานข้อมูล และเปิดใช้งาน หากมีการแก้ไข ให้เปลี่ยนเลขเวอร์ชั่น เพิ่มขึ้นไปเรื่อยๆ
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  // สร้างตาราง
  Future _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE "$tbAdd" ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'date TEXT,'
        'time TEXT,'
        'catMode TEXT,'
        'catId TEXT,'
        'catName TEXT,'
        'money TEXT,'
        'detail TEXT,'
        'image TEXT'
        ')');
  }

  Future<int> create(AddModel newAdd) async {
    final db = await instance.database;
    final res = await db.insert(tbAdd, newAdd.toJson());
    return res;
  }

  Future<int> edit(AddModel newEdit) async {
    final db = await instance.database;
    final res = await db.update(
      tbAdd,
      newEdit.toJson(),
      where: 'id = ?',
      whereArgs: [newEdit.id],
    );
    return res;
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    final res = await db.delete(
      tbAdd,
      where: 'id = ?',
      whereArgs: [id],
    );
    return res;
  }

  Future getAll() async {
    final db = await instance.database;
    final data = await db.query(tbAdd);
    return data;
  }

  Future getByDate(String date) async {
    final db = await instance.database;
    final data = await db.query(
      tbAdd,
      where: 'date = ?',
      whereArgs: [date],
    );

    if (data.isNotEmpty) {
      return data;
    } else {
      return null;
    }
  }
}
