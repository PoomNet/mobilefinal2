import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'json.dart';
import 'login.dart';
import 'profile_screen.dart';
import 'register.dart';
import 'sqlprofile.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class CounterStorage {
  //ต้องส่ง storage: CounterStorage() สำคัญมากๆๆๆๆๆๆๆๆๆ
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "";
    }
  }

  Future<File> writeCounter(String counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class TodoListScreen extends StatefulWidget {
  final CounterStorage storage;
  TodoListScreen({Key key, this.title, @required this.storage})
      : super(key: key);

  final String title;

  @override
  _TodoListScreenState createState() => new _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  var id;
  var name = "";
  var _counter = "";
  Future<List<ProfileItem>> _todoItems;
  List<ProfileItem> _completeItems = List();
  DataAccess _dataAccess = DataAccess();
  List<ProfileItem> user;

  @override
  initState() {
    super.initState();
    loadData();
    widget.storage.readCounter().then((String value) {
      setState(() {
        _counter = value;
      });
      print(_counter);
      print(value);
    });
    _dataAccess.open();
    _todoItems = _dataAccess.getAllUser();
    _createTodoItemWidget(_todoItems);
  }

  void _createTodoItemWidget(Future<List<ProfileItem>> item) async {
    var a = await item;
    setState(() {
      user = a;
      print(user);
    });
  }

  Future loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('username') ?? '';
      name = prefs.getString('name') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Hello $name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Text(
                    "this is my quote $_counter",
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            Container(
              height: 500,
              child: Column(
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 300.0,
                    child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text("PROFILE SETUP"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      storage: CounterStorages())));
                        }),
                  ),
                  ButtonTheme(
                    minWidth: 300.0,
                    child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text("MY FRIENDS"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FriendPage()));
                        }),
                  ),
                  ButtonTheme(
                    minWidth: 300.0,
                    child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text("SIGN OUT"),
                        onPressed: () async {
                          SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                          prefs.setString('username', "");
                          prefs.setString('name', "");
                          Navigator.pop(context);
                        }),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
