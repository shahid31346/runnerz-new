import 'package:flutter/material.dart';
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Customer/screens/home.dart';
import 'package:runnerz/Driver/Screens/Home_D.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(),
          settings: RouteSettings(name: 'home')));
    } else if (value == 1 && role != '0') {
      // setState(() {
      //   homed = true;
      // });

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreenD()));
    } else {
      // setState(() {
      //   login = true;
      // });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 3)).then((val) {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        height: mQ.height,
        width: mQ.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
            ),
            SizedBox(height: 35,),
            Center(
              child: CircularProgressIndicator(color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }
}
