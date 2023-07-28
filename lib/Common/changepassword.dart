import 'package:flutter/material.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../Customer/screens/my_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isLoading = false;
  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  final _formKeyy = GlobalKey<FormState>();

  String responseDynamic = "";

  Future<Map> getJson() async {
    String value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value = pref1.getString("user_id")!;
    print(value);
 
    Uri apiUrl = Uri.parse('http://35.158.106.116/api/customers/change_password?user_id=' + value);


    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };
    final msg = jsonEncode({
      "old_password": _oldPassword.text,
      "password": _passwordController.text,
      "confirm_password": _confirmController.text,
    });

    http.Response response = await http.post(
      apiUrl,
      headers: headers,
      body: msg,
    );

    return json.decode(response.body); // returns a List type
  }

  void _check() async {
    String _body = "";

    String values = "";

    Map _data = await getJson();

    print(_data);
    Map<String, dynamic> dataMap = _data["data"];
    dataMap.keys.forEach((k) {
      values = (dataMap[k].toString());
      print(dataMap[k]);
    });

    _body = (_data['status']);

    if (_body == 'ERROR') {
      setState(() {
        _isLoading = false;
      });
      print("error");
      showDialog(
          context: context,
          builder: (c) {
            return AlertDialog(
              title: Text("oops"),
              content: Text(values),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                )
              ],
            );
          });
    } else {
      print("success");
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
                title: Text("Congratulations"),
                content: Text('Password Updated Successfuly'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (c) => JoinApp(),
                      //     settings: RouteSettings(name: 'home')));
                    },
                    child: Text("Ok"),
                  )
                ],
              ));
    }

    print("khan $_data");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
              child: Column(
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
                          'Change Password',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Column(children: <Widget>[]),
                        Padding(
                          padding: const EdgeInsets.only(top: 28.0, left: 5.0),
                          child: Text(
                            'Old password'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 2),
                          child: Card(
                            elevation: 3.0,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Enter your old password",
                                  hintStyle: TextStyle(
                                      fontSize: 15.0, color: Colors.grey),
                                ),
                                maxLines: 1,
                                controller: _oldPassword,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 17.0, left: 5.0),
                          child: Text(
                            'New Password'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 2.0),
                          child: Card(
                            elevation: 3.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Enter password",
                                  hintStyle: TextStyle(
                                      fontSize: 15.0, color: Colors.grey),
                                ),
                                maxLines: 1,
                                obscureText: true,
                                controller: _passwordController,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 17.0, left: 5.0),
                          child: Text(
                            'Confirm new Password'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 2.0),
                          child: Card(
                            elevation: 3.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  hintText: "Enter password again",
                                  hintStyle: TextStyle(
                                      fontSize: 15.0, color: Colors.grey),
                                ),
                                maxLines: 1,
                                obscureText: true,
                                controller: _confirmController,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 77, // match_parent
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 05.0,
                              right: 05.0,
                              top: 20,
                            ),
                            child: _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.black54),
                                    ),
                                  )
                                :  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 6, 101, 159),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  onPressed: () {
                                      setState(() {
                                        _isLoading = true;

                                        _check();
                                      });
                                    },
                                    child:  Text(
                                      "Submit".toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                
                                
                                
                          
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
