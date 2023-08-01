import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Customer/screens/home.dart';
import 'package:runnerz/Driver/Screens/Home_D.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:runnerz/Welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_email.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _validate = false;
  bool _validatePassword = false;

  final TextEditingController _usernameControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();
  String responseDynamic = "";

  Future<Map> getJson() async {
    Uri apiUrl = Uri.parse(Constants.baseUrl + 'customers/login_process');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };
    final msg = jsonEncode({
      "email": _usernameControl.text,
      "password": _passwordControl.text,
      //"user_role": Constants.userrole,
    });

    http.Response response = await http.post(
      apiUrl,
      headers: headers,
      body: msg,
    );
    //  .timeout(Duration(seconds: 20));

    print(headers);
    print(msg);
    print(json.decode(response.body));

    return json.decode(response.body); // returns a List type
  }

  void sendLogin() async {
//    getJson();
    String _body = "";

    try {
      Map _data = await getJson();

      Map<String, dynamic> dataMap = _data["data"];
      dataMap.keys.forEach((k) {
        responseDynamic = (dataMap[k].toString());
        print(dataMap[k]);
      });

      _body = (_data['status']);
      print(_body);

      if (_body == 'ERROR') {
        setState(() {
          _isLoading = false;
        });
        print("error");

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: Container(
                 // height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 15),
                        Container(
                          height: 50,
                          width: 50,
                          child: ClipOval(
                            child: Material(
                              color: Colors.red, // button color
                              child: InkWell(
                                splashColor: Colors.blue, // inkwell color
                                child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 40,
                                    )),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'oops'.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(responseDynamic),
                        SizedBox(height: 20),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Constants.primary,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      } else {
        SharedPreferences pref1 = await SharedPreferences.getInstance();
        pref1.setString("user_id", _data['data']['id']);

        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setInt("value", 1);
        preferences.setString("role", _data['data']['user_role']);
        //to be
        preferences.setString("email", _data['data']['email']);
        preferences.setString("id", _data['data']['id']);
        preferences.setString("created_at", _data['data']['created_at']);
        preferences.setString("name", _data['data']['name']);
        preferences.setString("username", _data['data']['username']);
        preferences.setString("photo", _data['data']['photo']);

        setState(() {
          _isLoading = false;
        });

        if (_data['data']['user_role'] == '0') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (c) => HomeScreen(),
              settings: RouteSettings(name: 'home')));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (c) => HomeScreenD(),
              settings: RouteSettings(name: 'home')));
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      var error = e.toString();
      if (e is SocketException) error = 'No internet';

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                //  height: 230,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 15),
                      Container(
                        height: 50,
                        width: 50,
                        child: ClipOval(
                          child: Material(
                            color: Colors.red, // button color
                            child: InkWell(
                              splashColor: Colors.red, // inkwell color
                              child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 40,
                                  )),
                              onTap: () {},
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'oops'.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        error,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Constants.primary,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Ok",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 31, 162, 242),
            Color.fromARGB(255, 29, 161, 245),
          ],
        )),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 20),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Expanded(
                              //   child: new Container(
                              //       margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                              //       child: Divider(
                              //         color: Colors.black,
                              //         height: 50,
                              //       )),
                              // ),

                              Text(
                                "_______________   ",
                                style: TextStyle(color: Colors.white38),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),

                              Text(
                                "   _______________",
                                style: TextStyle(color: Colors.white38),
                              ),
                              // Expanded(
                              //   child: new Container(
                              //       margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                              //       child: Divider(
                              //         color: Colors.white,
                              //         height: 50,
                              //       )),
                              // ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 5.0),
                child: Text(
                  'Email Id'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 2),
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
                        hintText: "Enter your Email",
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.grey),
                        errorText: _validate ? 'Email Can\'t Be Empty' : null,
                      ),
                      maxLines: 1,
                      controller: _usernameControl,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 5.0),
                child: Text(
                  'Password'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 2.0),
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
                        hintStyle:
                            TextStyle(fontSize: 15.0, color: Colors.grey),
                        errorText: _validatePassword
                            ? 'Password Can\'t Be Empty'
                            : null,
                      ),
                      maxLines: 1,
                      obscureText: true,
                      controller: _passwordControl,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextButton(
                    child: Text(
                      'Forgot Password?',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotEmail()),
                      );
                    },
                  ),
                ],
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
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.black54),
                          ),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 6, 101, 159),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            "Sign In".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _usernameControl.text.isEmpty
                                  ? _validate = true
                                  : _validate = false;
                              _passwordControl.text.isEmpty
                                  ? _validatePassword = true
                                  : _validatePassword = false;

                              if (_validate == false &&
                                  _validatePassword == false) {
                                _isLoading = true;
                                sendLogin();
                              }
                            });
                          },
                        ),
                ),
              ),
              Container(
                  margin:
                      const EdgeInsets.only(top: 15, left: 15.0, right: 15.0),
                  child: Divider(
                    color: Colors.white,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 20, top: 10),
                child: Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          child: Text(
                            'Sign Up',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromARGB(255, 6, 101, 159),
                                fontSize: 17,
                                fontWeight: FontWeight.w800),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Welcome()),
                            );
                          },
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
