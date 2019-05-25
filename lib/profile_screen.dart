import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'register.dart';
import 'sqlprofile.dart';
import 'dart:async';

class ProfileScreen extends StatefulWidget {
  final CounterStorages storage;

  ProfileScreen({Key key, this.title, @required this.storage})
      : super(key: key);

  final String title;

  @override
  ProfileScreenState createState() => new ProfileScreenState();
}

class CounterStorages {
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

class ProfileScreenState extends State<ProfileScreen> {
  var check = 0;
  final fkey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final passController = TextEditingController();
  final quoteController = TextEditingController();
  Future<List<ProfileItem>> _todoItems;
  List<ProfileItem> _completeItems = List();
  DataAccess dataAccess = DataAccess();
  List<ProfileItem> user;

  String _counter = "";

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((String value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter(String value) {
    setState(() {
      _counter = value;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo"),
        ),
        body: Form(
          key: fkey,
          child: Container(
              // height: 500,
              margin: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    height: 40.0,
                    child: new TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10.0),
                          border: OutlineInputBorder(),
                          hintText: "User Id"),
                      controller: userController,
                      validator: (value) {
                        if (value.length < 6) {
                          return "Please fill username 6-12";
                        } else if (value.length > 12) {
                          return "Please fill username 6-12";
                        } else if (value.isEmpty) {
                          return "Please fill username 6-12";
                        }
                      },
                      onSaved: (value) => print(value),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    height: 40.0,
                    child: new TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10.0),
                          border: OutlineInputBorder(),
                          hintText: "Name"),
                      controller: nameController,
                      validator: (value) {
                        int check = 0;
                        value.runes.forEach((int rune) {
                          var character = new String.fromCharCode(rune);
                          if (character == ' ') {
                            check += 1;
                          }
                        });
                        if (check == 0) {
                          return "Please fill name and lastname";
                        }
                      },
                      keyboardType: TextInputType.text,
                      onSaved: (value) => print(value),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    height: 40.0,
                    child: new TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10.0),
                          border: OutlineInputBorder(),
                          hintText: "Age"),
                      controller: ageController,
                      validator: (value) {
                        if (int.parse(value) < 10) {
                          return "Please fill age 10-80";
                        } else if (int.parse(value) > 80) {
                          return "Please fill age 10-80";
                        } else if (value.isEmpty) {
                          return "Please fill age 10-80";
                        }
                      },
                      keyboardType: TextInputType.text,
                      onSaved: (value) => print(value),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    height: 40.0,
                    child: new TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10.0),
                          border: OutlineInputBorder(),
                          hintText: "Password"),
                      controller: passController,
                      validator: (value) {
                        if (value.length < 6) {
                          return "Please fill password > 6";
                        } else if (value.isEmpty) {
                          return "Please fill password > 6";
                        }
                      },
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      onSaved: (value) => print(value),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    // height: 120.0,
                    child: new TextFormField(
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            top: 0,
                            bottom: 100,
                            left: 10,
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'Quote'),
                      controller: quoteController,
                      validator: (value) {},
                      keyboardType: TextInputType.text,
                      onSaved: (value) => print(value),
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 300.0,
                    child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        child: Text("Save"),
                        onPressed: () async {
                          await dataAccess.open();
                          if (fkey.currentState.validate()) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            ProfileItem update = ProfileItem();
                            update.id = prefs.getInt('username') ?? '';
                            update.user = userController.text;
                            update.name = nameController.text;
                            update.age = ageController.text;
                            update.pass = passController.text;
                            prefs.setString('name', nameController.text);
                            _incrementCounter(quoteController.text);
                            await dataAccess.update(update);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TodoListScreen(
                                        storage: CounterStorage())));
                          }
                        }),
                  ),
                ],
              )),
        ));
  }
}
