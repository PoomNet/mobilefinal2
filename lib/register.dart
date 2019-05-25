import 'package:flutter/material.dart';
import 'sqlprofile.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  DataAccess dataAccess = DataAccess();
  final userController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final passController = TextEditingController();

  // final GlobalKey<ScaffoldState> _scafkey = GlobalKey<ScaffoldState>();
  final fkey = GlobalKey<FormState>();
  var check = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        // key: _scafkey,
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Form(
            key: fkey,
            child: Container(
                margin: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_box),
                          hintText: 'User Id'),
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
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_circle),
                          hintText: 'Name'),
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
                    TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.event_note), hintText: 'Age'),
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
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock), hintText: 'Password'),
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
                    ButtonTheme(
                      minWidth: 400.0,
                      child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Text("Register New Account"),
                          onPressed: () async {
                            if (fkey.currentState.validate()) {
                              await dataAccess.open();

                              ProfileItem data =
                                  ProfileItem(); //สร้างไว้สร้างข้อมูลใหม่ไม่ต้องมีidจะสร้างให้เอง
                              data.user = userController.text;
                              data.name = nameController.text;
                              data.age = ageController.text;
                              data.pass = passController.text;

                              userController.text = '';
                              nameController.text = '';
                              ageController.text = '';
                              passController.text = '';

                              await dataAccess.insertUser(data);
                              Navigator.pop(context);
                            }
                          }),
                    ),
                  ],
                ))));
  }
}
