import 'dart:convert';

import 'package:assignment_1/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Model userModel;
  List<UserList> userList = [];

  Future<List<dynamic>> fetchUsersData() async {
    var result =
        await http.get(Uri.parse("https://randomuser.me/api/?results=5"));
    return json.decode(result.body)['results'];
  }

  // fetch DOB
  String _dob(Map<dynamic, dynamic> user) {
    String dob = user['dob'].toString().split("T")[0];
    String dob2 = dob.split(":")[1];
    return dob2;
  }

  String _uuid(Map<dynamic, dynamic> user) {
    return user['login']['uuid'].toString().split("-")[0];
  }

  String _name(dynamic user) {
    return user['name']['title'] +
        " " +
        user['name']['first'] +
        " " +
        user['name']['last'];
  }

  String _location(dynamic user) {
    return user['location']['country'];
  }

  String _email(Map<dynamic, dynamic> user) {
    return user['email'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black12,
          title: Text(
            "Random Users",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 17,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<List<dynamic>>(
          future: fetchUsersData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 155,
                            width: 112,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: NetworkImage(snapshot.data[index]
                                        ['picture']['large']),
                                    fit: BoxFit.fill),
                                shape: BoxShape.rectangle),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 5, bottom: 5),
                                child: Text(
                                  _name(snapshot.data[index]),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Country ",
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.grey)),
                                    Text(_location(snapshot.data[index]),
                                        style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Email ",
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.grey)),
                                    Text(_email(snapshot.data[index]),
                                        style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 7, bottom: 0),
                                    child: Text("D.O.B. ",
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.grey)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(_dob(snapshot.data[index]),
                                        style: TextStyle(fontSize: 15)),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("ID Number ",
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.grey)),
                                    Text(
                                        _uuid(snapshot.data[index])
                                            .toUpperCase(),
                                        style: TextStyle(fontSize: 15)),
                                  ],
                                ),
                              ),
                              Divider(thickness: 1, color: Colors.grey),
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
