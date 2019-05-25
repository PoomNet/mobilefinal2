import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'todofri.dart';

// import 'fripage.dart';

class FriendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FriendPageState();
  }
}

Future<List<User>> fetchUsers() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');

  List<User> userApi = [];

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    // print(body);
    for (int i = 0; i < body.length; i++) {
      var user = User.fromJson(body[i]);
      userApi.add(user);
    }

    return userApi;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  User({this.id, this.name, this.email, this.phone, this.website});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}

class FriendPageState extends State<FriendPage> {
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
            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
            FutureBuilder(
              future: fetchUsers(),
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
          return new Card(
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${(values[index].id).toString()} : ${values[index].name}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
                  Text(
                    values[index].email,
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
                  Text(
                    values[index].phone,
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
                  Text(
                    values[index].website,
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0,0, 0, 10)),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TodoFriendPage(id: values[index].id),
                  ),
                );
              },
            ),
          );
        },
      ),
      
    );
  }
}
