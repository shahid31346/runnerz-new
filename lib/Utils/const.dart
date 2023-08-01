import 'package:flutter/material.dart';

class Constants {
  // about status of packages
  // status 8 is for declined package and 7 for accepted package,
  // 9 is for on ride,completed 14,later 6, cancelled 13,new 16
  // Toast.show('please select vehicle', context);

  //final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  // void showSnackBar() {
  //   final snackBarContent = SnackBar(
  //     content: Text("Product Added to cart"),
  //     duration: const Duration(seconds: 1),
  //     // action: SnackBarAction(
  //     //     label: 'UNDO', onPressed: _scaffoldkey.currentState.hideCurrentSnackBar),
  //   );
  //   _scaffoldkey.currentState.showSnackBar(snackBarContent);
  // }

  static String about =
      "For a remarkable about page, all you need to do is figure out your company's unique identity, and then share it with the world. Easy, right? Of course not. Your About Us page is one of the most important pages on your Application, and it needs to be well crafted. This profile also happens to be one of the most commonly overlooked pages, which is why you should make it stand out.The good news? It can be done. In fact, there are some companies out there with remarkable About Us pages, the elements of which you can emulate on your own App. ";
  static String appname = 'runnerz';

  static Color primary = Color(0xff1fa2f2);
  static String currency = "\$";
  //static String baseUrl = 'http://35.158.106.116/api/';
  static String baseUrl = 'https://gocourier.iaoai.io/api/';

  
  static String authToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.InJ1bm5lcnp6QCEkMjAyMC1zdXZhc3R1dGVjaCI.E1SeaNVbLl7SZv7BcLIYshYrX1y-GwaO9KUGXGc1FG0';

  static String userrole = '0';
  static String api_key = 'AIzaSyCqi_-GdzTVjwKqvjxmTLyry-EgUHegE1Y';

  static String? mainAdressPickup;
  static String? addressForDrop;
  static double? latitudeForDrop;
  static double? longitudeForDrop;

  static double? latitudeForPickup;
  static double? longitudeForPickup;
}
