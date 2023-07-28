import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forgot_password_changer.dart';

class ForgotEmail extends StatefulWidget {
  @override
  ForgotEmailState createState() => ForgotEmailState();
}

class ForgotEmailState extends State<ForgotEmail> {
  bool _isLoading = false;
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String responseDynamic = "";

  getJson() async {
    var uri = Uri.parse(Constants.baseUrl + 'password_reset/sendCode');

    var request = http.MultipartRequest('POST', uri)
      ..fields['email'] = _emailController.text;

    // request.headers.addAll({
    //     'Content-Type': 'multipart/form-data',
    //     'Authorization':'your token'
    //   });

    var response = await request.send();
    if (response.statusCode == 200) print('Done!');

    final respStr = await response.stream.bytesToString();

    return json.decode(respStr);
  }

  void check() async {
    String _body = "";

    Map _data = await getJson();

    print(_data);

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
      SharedPreferences pref3 = await SharedPreferences.getInstance();
      pref3.setString("id", _data['id']);
      print("success");
      setState(() {
        _isLoading = false;
      });

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 230,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15),
                      Container(
                        height: 50,
                        width: 50,
                        child: ClipOval(
                          child: Material(
                            color: Constants.primary, // button color
                            child: InkWell(
                              splashColor: Colors.red, // inkwell color
                              child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.check,
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
                        'Code Sent Successfully'.toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Center(
                          child: Text(
                            'Please check your email, code will be expired in 24 hours',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Constants.primary,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) => ForgotChange(),
                              settings: RouteSettings(name: 'home')));
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
          "Forgot Password?",
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
                    height: 240.0,
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
                            "Enter Your Email to recover",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 35, left: 15, right: 15),
                          child: Form(
                            key: _formKey,
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
                                            BorderRadius.circular(10.0),
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
                                      hintText: "Enter your Email ID",
                                      prefixIcon: Icon(
                                        Icons.mail_outline,
                                        color: Theme.of(context).colorScheme.secondary ,
                                      ),
                                      hintStyle: TextStyle(
                                          fontSize: 15.0, color: Colors.grey),
                                    ),
                                    //obscureText: true,
                                    maxLines: 1,
                                    controller: _emailController,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Container(
                            width: 150,
                            height: 50.0,
                            child: _isLoading
                                ? Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.secondary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    child: Text(
                                      "send now".toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _formKey.currentState!.validate();
                                        if (_formKey.currentState!.validate()) {
                                          _isLoading = true;
                                          check();
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
    );
  }
}
