import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotChange extends StatefulWidget {
  @override
  ForgotChangeState createState() => ForgotChangeState();
}

class ForgotChangeState extends State<ForgotChange> {
  bool _isLoading = false;
  TextEditingController _codeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();
  final _formKeyy = GlobalKey<FormState>();

  String responseDynamic = "";

  getJson() async {
    String value = '';
    SharedPreferences pref3 = await SharedPreferences.getInstance();
    value = pref3.getString("id")!;

    var uri = Uri.parse(
        Constants.baseUrl + 'password_reset/update_password?user_id=' + value);

    var request = http.MultipartRequest('POST', uri)
      ..fields['password'] = _passwordController.text
      ..fields['password_confirmation'] = _confirmController.text
      ..fields['code'] = _codeController.text;

    // request.headers.addAll({
    //     'Content-Type': 'multipart/form-data',
    //     'Authorization':'your token'
    //   });

    var response = await request.send();
    if (response.statusCode == 200) print('Done!');

    final respStr = await response.stream.bytesToString();

    return json.decode(respStr);
  }

  void _check() async {
    String _body = "";
    Map _data = await getJson();

    //print(_data);

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
              content: Text(_data['data']['msg']),
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
                title: Text("Successful"),
                content: Text('Please login with your new password'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => LoginScreen(),
                          settings: RouteSettings(name: 'home')));
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Change Password",
        ),
        elevation: 0.0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(50, 31, 162, 242),
            Color.fromARGB(255, 29, 161, 245),
          ],
        )),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: Form(
            key: _formKeyy,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50,
                    left: 5.0,
                    right: 5.0,
                  ),
                  child: Card(
                    elevation: 8.0,
                    child: Container(
                      height: 367.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(300.0),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              "Please Enter below details",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 15, right: 15),
                            child: Card(
                              elevation: 3.0,
                              child: Container(
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    validator: (value) {
                                      if (value!.length > 0) return null;
                                      return 'This field is required';
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      hintText: "Enter Verification code",
                                      prefixIcon: Icon(
                                        Icons.mail_outline,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      hintStyle: TextStyle(
                                          fontSize: 15.0, color: Colors.grey),
                                    ),
                                    //obscureText: true,
                                    maxLines: 1,
                                    controller: _codeController,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 15, right: 15),
                            child: Card(
                              elevation: 3.0,
                              child: Container(
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    validator: (value) {
                                      if (value!.length > 0) return null;
                                      return 'This field is required';
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      hintText: "Enter New Password",
                                      prefixIcon: Icon(
                                        Icons.security,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      hintStyle: TextStyle(
                                          fontSize: 15.0, color: Colors.grey),
                                    ),
                                    obscureText: true,
                                    maxLines: 1,
                                    controller: _passwordController,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 15, right: 15),
                            child: Card(
                              elevation: 3.0,
                              child: Container(
                                height: 60.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: TextFormField(
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                    validator: (value) {
                                      if (value!.length > 0) return null;
                                      return 'This field is required';
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      hintText: "Confirm Password",
                                      prefixIcon: Icon(
                                        Icons.security,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      hintStyle: TextStyle(
                                          fontSize: 15.0, color: Colors.grey),
                                    ),
                                    obscureText: true,
                                    maxLines: 1,
                                    controller: _confirmController,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                              width: 150,
                              height: 50.0,
                              child: _isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.secondary ,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: Text(
                                        "Change now".toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _formKeyy.currentState!.validate();
                                          if (_formKeyy.currentState!
                                              .validate()) {
                                            _isLoading = true;
                                            _check();
                                          }
                                        });
                                      },
                                      
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
