import 'dart:async';
import 'package:sqflite/sqflite.dart';

final String profileTable = "user";
final String idColumn = "id";
final String userColumn = "user";
final String nameColumn = "name";
final String ageColumn = "age";
final String passColumn = "pass";

class ProfileItem {
  int id;
  String user;
  String name;
  String age;
  String pass;

  ProfileItem();

  ProfileItem.formMap(Map<String, dynamic> map) {
    this.id = map[idColumn];
    this.user = map[userColumn];
    this.age = map[ageColumn];
    this.name = map[nameColumn];
    this.pass = map[passColumn];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      userColumn: user,
      nameColumn: name,
      ageColumn: age,
      passColumn: pass,
    };
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }
  @override
  String toString() { return 'id: ${this.id}, user:  ${this.user}, name:  ${this.name}, age:  ${this.age}, password:  ${this.pass}'; }
}

class DataAccess {
  Database db;
  String path = "user.db";

  Future open() async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
  create table $profileTable ( 
    $idColumn integer primary key autoincrement, 
    $userColumn text not null,
    $nameColumn text not null,
    $passColumn text not null,
    $ageColumn text not null)
  ''');
    });
  }

  Future<ProfileItem> insertUser(ProfileItem item) async {
    item.id = await db.insert(profileTable, item.toMap());
    return item;
  }

  Future<ProfileItem> getUser(int id) async {
    List<Map<String, dynamic>> maps = await db.query(profileTable,
        columns: [idColumn, userColumn, nameColumn, ageColumn, passColumn],
        where: '$idColumn = ?',
        whereArgs: [id]);
    maps.length > 0 ? new ProfileItem.formMap(maps.first) : null;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(profileTable, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> update(ProfileItem todo) async {
    return await db.update(profileTable, todo.toMap(),
        where: '$idColumn = ?', whereArgs: [todo.id]);
  }

  Future<List<ProfileItem>> getAllUser() async {
    await this.open();
    var res = await db.query(profileTable,
        columns: [idColumn, userColumn, nameColumn, ageColumn, passColumn]);
    List<ProfileItem> userList =
        res.isNotEmpty ? res.map((c) => ProfileItem.formMap(c)).toList() : [];
    return userList;
  }

  Future close() async => db.close();
}
