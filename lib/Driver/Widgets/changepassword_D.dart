import 'package:flutter/material.dart';
import 'package:runnerz/Driver/Screens/MyProfile_D.dart';
import 'package:runnerz/Utils/base_appbar.dart';

class ChangePasswordD extends StatefulWidget {
  @override
  _ChangePasswordDState createState() => _ChangePasswordDState();
}

class _ChangePasswordDState extends State<ChangePasswordD> {
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
                                controller: null,
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
                                controller: null,
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
                                controller: null,
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
                            child: ElevatedButton(
                        

                                    style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff1fa2f2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                "Submit".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreenD()),
                                );
                              },
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
