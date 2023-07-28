// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:runnerz/Customer/screens/home.dart';
// import 'package:runnerz/Utils/const.dart';
// import 'package:runnerz/Welcome.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class SplashScreen1 extends StatefulWidget {
//   @override
//   _SplashScreen1State createState() => _SplashScreen1State();
// }

// class _SplashScreen1State extends State<SplashScreen1> {
//   int value;

//   startTimeout() {
//     return Timer(Duration(seconds: 2), checkFirstSeen);
//   }

//   Future checkFirstSeen() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool _seen = (prefs.getBool('seen') ?? false);

//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     value = preferences.getInt("value")!;
//     if (value == 1) {
//       Navigator.of(context).pushReplacement(new MaterialPageRoute(
//           builder: (context) => new HomeScreen(),
//           settings: RouteSettings(name: 'home')));
//     } else if (_seen) {
//       Navigator.of(context).pushReplacement(
//           new MaterialPageRoute(builder: (context) => new Welcome()));
//     } else {
//       await prefs.setBool('seen', true);
//       Navigator.of(context).pushReplacement(
//           new MaterialPageRoute(builder: (context) => new HomeScreen()));
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setEnabledSystemUIOverlays([]);
//     startTimeout();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       body: Container(
//         margin: EdgeInsets.only(left: 40.0, right: 40.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Image.asset(
//                 'assets/appicons.jpg',
//                 height: 150,
//                 width: 150,
//               ),
//               // Icon(
//               //   Icons.fastfood,
//               //   size: 150.0,
//               //   color: Colors.orange,
//               // ),
//               SizedBox(width: 40.0),
//               Container(
//                 alignment: Alignment.center,
//                 margin: EdgeInsets.only(),

//                 child: Image.asset(
//                   'assets/logo.png',
//                   color: Constants.primary,
//                   height: 70,
//                   width: 100,
//                 ),
//                 // child: Text(
//                 //   "Manjaros",
//                 //   style: TextStyle(
//                 //     fontSize: 25.0,
//                 //     fontWeight: FontWeight.w700,
//                 //     color: Theme.of(context).accentColor,
//                 //   ),
//                 // ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // import 'dart:async';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:runnerz/Common/login.dart';
// // import 'package:runnerz/Welcome.dart';

// // class SplashScreen extends StatefulWidget {
// //   @override
// //   _SplashScreenState createState() => _SplashScreenState();
// // }

// // class _SplashScreenState extends State<SplashScreen> {
// //   int value;

// //   startTimeout() {
// //     return Timer(Duration(seconds: 2), checkFirstSeen);
// //   }

// //   Future checkFirstSeen() async {
// //     Navigator.of(context).pushReplacement(
// //         new MaterialPageRoute(builder: (context) => new Welcome()));
// // //         SharedPreferences prefs = await SharedPreferences.getInstance();
// // //         bool _seen = (prefs.getBool('seen') ?? false);

// // //     SharedPreferences preferences = await SharedPreferences.getInstance();
// // //       value = preferences.getInt("value");
// // // if(value == 1){
// // //  Navigator.of(context).pushReplacement(
// // //             new MaterialPageRoute(builder: (context) => new MainScreen(),
// // //                 settings: RouteSettings(name: 'home')));

// // //  }else if (_seen) {
// // //         Navigator.of(context).pushReplacement(
// // //             new MaterialPageRoute(builder: (context) => new JoinApp()));
// // //         } else {
// // //         await prefs.setBool('seen', true);
// // //         Navigator.of(context).pushReplacement(
// // //             new MaterialPageRoute(builder: (context) => new Walkthrough()));
// // //         }
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     SystemChrome.setEnabledSystemUIOverlays([]);
// //     startTimeout();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         image: DecorationImage(
// //           image: AssetImage(
// //             'assets/splash_screen.jpg',
// //           ),
// //           fit: BoxFit.cover,
// //         ),
// //       ),
// //       child: null /* add child content here */,
// //     );
// //   }
// // }
