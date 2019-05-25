import 'package:flutter/material.dart';
import 'profile.dart';
import 'sqlprofile.dart';
import 'register.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Loginstate();
  }
}

class Loginstate extends State<Loginpage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  DataAccess _dataAccess = DataAccess();
  Future<List<ProfileItem>> alluser;
  final GlobalKey<ScaffoldState> _scafkey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  CurrentUser currentUser;
  var username = "";
  var name = "";

  Future loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
      name = prefs.getString('name') ?? '';
    });
  }

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    loadData();
    print(username);
    if (CurrentUser.USER != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TodoListScreen()));
    }
    print(CurrentUser.USER);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scafkey,
        body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Image.asset("image/1.png", width: 200),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_box), hintText: 'User ID'),
                    controller: userController,
                    validator: (value) {},
                    keyboardType: TextInputType.text,
                    onSaved: (value) => print(value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock), hintText: 'Password'),
                    controller: passController,
                    validator: (value) {},
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    onSaved: (value) => print(value),
                  ),
                ),
                ButtonTheme(
                  minWidth: 300.0,
                  child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      child: Text("Login"),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        _dataAccess.open();
                        int check = 0, i = 0;
                        alluser = _dataAccess.getAllUser();

                        var user = await alluser;
                        for (i = 0; i < user.length; i++) {
                          print(user[i].user);
                          if (user[i].user == userController.text &&
                              user[i].pass == passController.text) {
                            check += 1;
                            break;
                          }
                        }
                        print(check);
                        _formKey.currentState.validate();
                        if (userController.text == "" ||
                            passController.text == "") {
                          _scafkey.currentState.showSnackBar(SnackBar(
                            content: Text('Please fill out this form'),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ));
                        } else if (check != 1) {
                          _scafkey.currentState.showSnackBar(SnackBar(
                            content: Text('Invalid user or password'),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          // final myString = prefs.getString('my_string_key') ?? '';
                          prefs.setString('username', user[i].user);
                          prefs.setString('name', user[i].name);
                          userController.text = "";
                          passController.text = "";
                          CurrentUser.USERID = user[i].id;
                          CurrentUser.USER = user[i].user;
                          CurrentUser.NAME = user[i].name;
                          CurrentUser.AGE = user[i].age;
                          CurrentUser.PASSWORD = user[i].pass;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TodoListScreen(
                                      storage: CounterStorage())));
                        }
                      }),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        child: Text(
                          "Register New Account",),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        })),
              ],
            ),
          ),
        ));
  }
}
