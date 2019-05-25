import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
// import './myfriendPage.dart';

class TodoFriendPage extends StatefulWidget {
  int id;
  TodoFriendPage({Key key, @required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FriendPageState();
  }
}

Future<List<User>> fetchUsers(int userid) async {
  final response = await http
      .get('https://jsonplaceholder.typicode.com/todos?userId=${userid}');

  List<User> userApi = [];

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    // print(body);
    for (int i = 0; i < body.length; i++) {
      var user = User.fromJson(body[i]);
      userApi.add(user);
    }
    //  print(userApi);
    return userApi;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class User {
  final int id;
  final String title;
  final bool completed;

  User({this.id, this.title, this.completed});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

class FriendPageState extends State<TodoFriendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Friends"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            ButtonTheme(
              minWidth: 400.0,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text("BACK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            FutureBuilder(
              future: fetchUsers(widget.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Text('loading...');
                  default:
                    if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      return createListView(context, snapshot);
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<User> values = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          if (values[index].completed == true) {
            return new Card(
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      values[index].id.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                    Text(
                      values[index].title.toString(),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                    Text(
                      "completed",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                onTap: () {},
              ),
            );
          } else {
            return new Card(
              child: InkWell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      values[index].id.toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                    Text(
                      values[index].title.toString(),
                    ),
                  ],
                ),
                onTap: () {},
              ),
            );
          }
        },
      ),
    );
  }
}
