import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Utils/const.dart';

class SupportTab extends StatefulWidget {
  @override
  _SupportTabState createState() => _SupportTabState();
}

class _SupportTabState extends State<SupportTab> {
  bool _isLoading = false;
  bool _validate = false;
  bool _validatePassword = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleControl = new TextEditingController();
  final TextEditingController _nameControl = new TextEditingController();
  final TextEditingController _emailControl = new TextEditingController();
  final TextEditingController _companyControl = new TextEditingController();
  final TextEditingController _discussionControl = new TextEditingController();
  String responseDynamic = "";

  bool validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  Future<Map> getJson() async {
    Uri apiUrl = Uri.parse(Constants.baseUrl + 'customers/support_form');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };
    final msg = jsonEncode({
      "title": _titleControl.text,
      "name": _nameControl.text,
      "email": _emailControl.text,
      "company": _companyControl.text,
      "discuss": _discussionControl.text,
    });

    http.Response response = await http.post(
      apiUrl,
      headers: headers,
      body: msg,
    );
    //  .timeout(Duration(seconds: 20));

    return json.decode(response.body); // returns a List type
  }

  void suportSubmit() async {
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
                  height: 250,
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
                              backgroundColor: Constants.primary),
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
        setState(() {
          _isLoading = false;
        });

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: Container(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 15),
                        Container(
                          height: 60,
                          width: 60,
                          child: ClipOval(
                            child: Material(
                              color: Colors.blue, // button color
                              child: InkWell(
                                splashColor: Colors.red, // inkwell color
                                child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 50,
                                    )),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Text(
                          'Thank You'.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('for contacting us, We will get'),
                        Text('back to you soon!'),
                      ],
                    ),
                  ),
                ),
              );
            });
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
                            backgroundColor: Constants.primary),
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 5.0),
                  child: Text(
                    'Title'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 1),
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
                        validator: (value) {
                          if (value!.isNotEmpty) return null;
                          return 'This field is required';
                        },
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
                          hintText: "Enter a title ",
                          hintStyle:
                              TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                        maxLines: 1,
                        controller: _titleControl,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, left: 5.0),
                  child: Text(
                    'name'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 0.0, right: 0.0, top: 1.0),
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
                        validator: (value) {
                          if (value!.isNotEmpty) return null;
                          return 'This field is required';
                        },
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
                          hintText: "Enter Your name",
                          hintStyle:
                              TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                        maxLines: 1,
                        controller: _nameControl,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, left: 5.0),
                  child: Text(
                    'email'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 0.0, right: 0.0, top: 1.0),
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
                        validator: (value) {
                          if (value!.isNotEmpty) return null;
                          return 'This field is required';
                        },
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
                          hintText: "Enter your email",
                          hintStyle:
                              TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                        maxLines: 1,
                        controller: _emailControl,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0, left: 5.0),
                  child: Text(
                    'company name'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 0.0, right: 0.0, top: 1.0),
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
                        validator: (value) {
                          if (value!.isNotEmpty) return null;
                          return 'This field is required';
                        },
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
                          hintText: "Enter your company name",
                          hintStyle:
                              TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                        maxLines: 1,
                        controller: _companyControl,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 9.0),
                  child: Text(
                    'What would you like to discuss ?'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 2.0,
                  ),

                  //  key: _formKeyy,

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
                        validator: (value) {
                          if (value!.isNotEmpty) return null;
                          return 'This field is required';
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        maxLength: 500,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 2.0),
                          ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(
                          //     color: Colors.grey,
                          //     width: 2.0,
                          //   ),
                          // ),
                          hintText: 'Discuss',
                          contentPadding: EdgeInsets.all(10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        controller: _discussionControl,
                      ),
                    ),
                  ),
                ),
                _isLoading
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Container(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.black54),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 77, // match_parent
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 05.0,
                            right: 05.0,
                            top: 10,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff1fa2f2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _formKey.currentState!.validate();

                                if (_formKey.currentState!.validate()) {
                                  _isLoading = true;
                                  suportSubmit();
                                }
                              });
                            },
                            child: Text(
                              "I'm Interested".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800),
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
