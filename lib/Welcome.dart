import 'package:flutter/material.dart';
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Driver/Screens/register_D.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Customer/screens/register.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  // int value;

  // Future checkFirstSeen() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   value = preferences.getInt("value");
  //   if (value == 1) {
  //     Navigator.of(context).pushReplacement(new MaterialPageRoute(
  //         builder: (context) => new HomeScreen(),
  //         settings: RouteSettings(name: 'home')));
  //   } else {
  //     Navigator.of(context).pushReplacement(
  //         new MaterialPageRoute(builder: (context) => new Welcome()));
  //   }
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState

  //   checkFirstSeen();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 31, 162, 242),
            Color.fromARGB(255, 29, 161, 245),
          ],
        )),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
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
                        child: const Row(
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
                                "___________   ",
                                style: TextStyle(color: Colors.white38),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Welcome",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),

                              Text(
                                "   ___________",
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
              const SizedBox(
                height: 90,
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
                      backgroundColor: Color.fromARGB(255, 6, 101, 159),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      SharedPreferences pref2 =
                          await SharedPreferences.getInstance();
                      pref2.setString("user_role", '0');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      );
                    },
                    child: Text(
                      "Register as Customer".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
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
                      backgroundColor: Color.fromARGB(255, 6, 101, 159),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      SharedPreferences pref2 =
                          await SharedPreferences.getInstance();
                      pref2.setString("user_role", '1');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreenD()),
                      );
                    },
                    child: Text(
                      "Register as Driver".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Container(
                  margin:
                      const EdgeInsets.only(top: 15, left: 15.0, right: 15.0),
                  child: const Divider(
                    color: Colors.white,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 20, top: 10),
                child: Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          child: const Text(
                            'Log in',
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
                                  builder: (context) => LoginScreen()),
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
