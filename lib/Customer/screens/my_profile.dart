import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Common/changepassword.dart';
import 'package:runnerz/Common/edit_details.dart';
import 'package:runnerz/Common/listCons/user_details.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = true;
  bool apiCalled = false;
  UserDetail? detail;

  Future<Map> _getJson() async {
    String value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value = pref1.getString("user_id")!;

    Uri apiUrl = Uri.parse(
        Constants.baseUrl + 'customers/get_user_detail?user_id=' + value);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };

    http.Response response = await http.get(
      apiUrl,
      headers: headers,
    );

    print(apiUrl);
    return json.decode(response.body); // returns a List type
  }

  List user = [];

  _getDetail() async {
    setState(() {
      apiCalled = true;
    });
    try {
      Map? _data2 = await _getJson();

      user = _data2['user'];
      print("valueeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
      print(user);

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        detail = null;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    _getDetail();
  }

  @override
  Widget build(BuildContext context) {
    if (!apiCalled) {
      Future.delayed(Duration(milliseconds: 2), () {
        _getDetail();
      });
    }
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : _getDetailWidget(context),
    );
  }

  Widget _getDetailWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 0.0, left: 0.0),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(0.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0, left: 15.0),
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Center(
                      child: ClipOval(
                        child: Image.network(
                          "${user[0]['photo'].toString()}",
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  //  CircleAvatar(
                  //       radius: 20,
                  //       backgroundImage: AssetImage(
                  //         'assets/splash_screen.jpg',
                  //       ),
                  //     ),

                  // Positioned(
                  //   right: -10.0,
                  //   bottom: 3.0,
                  //   child: RawMaterialButton(
                  //     onPressed: null,
                  //     fillColor: Colors.white,
                  //     shape: CircleBorder(),
                  //     elevation: 4.0,
                  //     child: Padding(
                  //       padding: EdgeInsets.all(5),
                  //       child: Icon(Icons.favorite),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 50),
                child: Divider(
                  thickness: 1.0,
                  color: Colors.black26,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.phone,
                      color: Colors.grey,
                      size: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 11),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Mobile',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              "${user[0]['phone'].toString()}",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                child: Divider(
                  thickness: 1.0,
                  color: Colors.black26,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, top: 10.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.email,
                      color: Colors.grey,
                      size: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Email ID',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              "${user[0]['email'].toString()}",
                              style: TextStyle(
                                  color: Color(0xff1fa2f2),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 11),
                child: Divider(
                  thickness: 1.0,
                  color: Colors.black26,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          // width: double.infinity,
                          height: 47, // match_parent

                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 15.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff1fa2f2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                "Edit Details",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditDetails()),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          // width: double.infinity,
                          height: 47, // match_parent

                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 20.0),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                        color: Colors.grey, width: 2)),
                                backgroundColor: Colors.white,
                                textStyle: TextStyle(color: Colors.black),
                                padding: EdgeInsets.all(8.0),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChangePassword()),
                                );
                              },
                              child: Text(
                                "Change Password".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class UserDetailsResponse {
  final List<UserDetail>? data;
  final String status;

  UserDetailsResponse({required this.data, required this.status});

  factory UserDetailsResponse.fromJson(Map<dynamic, dynamic> json) {
    return UserDetailsResponse(
      data: json['user'] != null
          ? (json['user'] as List).map((i) => UserDetail.fromJson(i)).toList()
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['user'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
