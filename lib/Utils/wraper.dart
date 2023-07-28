import 'package:flutter/material.dart';
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Customer/screens/home.dart';
import 'package:runnerz/Driver/Screens/Home_D.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  final String? role;
  final int? value;
  Wrapper({ this.role, this.value, Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int? value;
  String? role;
  bool homec = false;
  bool homed = false;
  bool login = false;

  checkFirstSeen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    value = preferences.getInt("value");
    role = preferences.getString("role");

    if (value == 1 && role == '0') {
      // setState(() {
      //   homec = true;
      // });
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (context) => new HomeScreen(),
          settings: RouteSettings(name: 'home')));
    } else if (value == 1 && role != '0') {
      // setState(() {
      //   homed = true;
      // });

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeScreenD()));
    } else {
      // setState(() {
      //   login = true;
      // });
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new LoginScreen()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkFirstSeen();
  }

  @override
  Widget build(BuildContext context) {
    if (value == 1 && role == '0') {
      return HomeScreen();
    } else if (value == 1 && role != '0') {
      return HomeScreenD();
    } else {
      return LoginScreen();
    }
  }
}
