import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Common/about.dart';
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Common/notifications.dart';
import 'package:runnerz/Common/support.dart';
import 'package:runnerz/Driver/Screens/BankAccountView_D.dart';
import 'package:runnerz/Driver/Screens/BankAccount_D.dart';
import 'package:runnerz/Driver/Screens/DriverDashboard_D.dart';
import 'package:runnerz/Driver/Screens/MyProfile_D.dart';
import 'package:runnerz/Driver/Screens/TripSummary/TripSummary_D.dart';
import 'package:runnerz/Driver/Screens/later2_D.dart';
import 'package:runnerz/Driver/Screens/packagerequest_New2_D.dart';
import 'package:runnerz/Driver/Screens/payment_D.dart';
import 'package:runnerz/Driver/Screens/rating_reviews_D.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:runnerz/dummy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawerD extends StatefulWidget {
  @override
  _AppDrawerDState createState() => _AppDrawerDState();
}

class _AppDrawerDState extends State<AppDrawerD> {
  //location stream
  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;

  // CollectionReference collectionReferenceLocation =
  //     FirebaseFirestore.instance.collection('locations');
  bool _isSwitched = false;
  bool _isSwitched2 = false;
  String? onlineStatus;
  String responseDynamic = "";
  bool _isLoading = false;
  String? valueforSharedprefrences;

  onlineStatusFunction() async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    setState(() {
      _isSwitched = pref1.getBool("online_status")!;
    });
  }

  // nameData() async {
  //   onlineStatusFunction();
  //   String name = '';
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     name = preferences.getString("name");
  //   });
  //   return name;
  // }

  // pictureData() async {
  //   String photo = '';
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     photo = preferences.getString("photo");
  //   });

  //   return photo;
  // }

  Future<Map> _getJsonOnline() async {
    String value = '';

    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value = pref1.getString("user_id")!;
    print(value);

    if (_isSwitched) {
      onlineStatus = '15';
      pref1.setBool("online_status", true);

      // _toggleListening(value);
    } else {
      onlineStatus = '16';
      pref1.setBool("online_status", false);
      // _toggleListening(value);
    }

    Uri apiUrl = Uri.parse(Constants.baseUrl +
        'customers/switch_user?driver_id=$value&is_visible=$onlineStatus'); // +
    //vechiletype;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };

    http.Response response = await http.get(
      apiUrl,
      headers: headers,
    );

    return json.decode(response.body); // returns a List type
  }

  void onlineStatusGetter() async {
//    getJson();
    String _body = "";

    //String amount = "";

    try {
      Map _data = await _getJsonOnline();

      print(_data);

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
            builder: (c) {
              return AlertDialog(
                title: Text("oops"),
                content: Text(responseDynamic),
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
        setState(() {
          _isLoading = false;
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
          builder: (c) {
            return AlertDialog(
              title: Text("oops"),
              content: Text(error),
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
    }
  }

  void initState() {
    super.initState();
    _loadSwitchState();
  }

  void _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSwitched = prefs.getBool('switch_state') ?? false;
    });
  }

  void _toggleSwitch(bool newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSwitched = newValue;
    });

    prefs.setBool('switch_state', newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),

          // Container(
          //   child: _createHeader(),
          //   color: Constants.primary,
          // ),
          // _createDrawerItem(
          //     icon: Icons.home,
          //     text: 'Home',
          //     onTap: () => Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => HomeScreenD()),
          //         )),

          _createDrawerItem(
              icon: Icons.verified_user,
              text: 'My Profile',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreenD()),
                  )),
          Divider(),

          _createDrawerItem(
              icon: Icons.airline_seat_recline_normal,
              text: 'Packages Request',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NewTrip2D()),
                  )),
          Divider(),
          _createDrawerItem(
              icon: Icons.adjust,
              text: 'Driver Dashboard',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DriverDashboard()),
                  )),
          Divider(),

          _createDrawerItem(
              icon: Icons.score,
              text: 'Trip  Summary',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TripSummaryD()),
                  )),
          Divider(),

          _createDrawerItem(
              icon: Icons.motorcycle,
              text: 'Ride Later',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LaterTrip2()),
                  )),
          Divider(),

          _createDrawerItem(
              icon: Icons.account_balance_wallet,
              text: 'Bank Account',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BankAccount()),
                  )),
          Divider(),

          _createDrawerItem(
              icon: Icons.account_balance_wallet, text: 'track', onTap: () {}
              // onTap: () => Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Dummy()),
              // ),
              ),
          Divider(),
          _createDrawerItem(
              icon: Icons.card_membership,
              text: 'Payment Details',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreenD()),
                  )),
          Divider(),

          _createDrawerItem(
              icon: Icons.rate_review,
              text: 'Rating & Reviews',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RateReviewsScreenD()),
                  )),
          Divider(),

          _createDrawerItem(
              icon: Icons.person_pin_circle,
              text: 'About the App',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  )),
          Divider(),

          _createDrawerItem(
              icon: Icons.settings,
              text: 'Support',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SupportScreen()),
                  )),

          _createDrawerItem(
              icon: Icons.notifications,
              text: 'App Notifications',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  )),

          _createDrawerItem(
              icon: Icons.notifications,
              text: 'Bank Account View',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BankAccountView()),
                  )),

          // ListTile(
          //   title: Text('0.0.1'),
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(color: Constants.primary
          // image: DecorationImage(
          //   fit: BoxFit.fill,
          //   image: AssetImage('assets/drawer_header.jpg'),
          // ),
          ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 10.0,
            left: 5.0,
            right: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Row(
                //   children: <Widget>[
                //     Container(
                //       height: MediaQuery.of(context).size.width / 6.0,
                //       width: MediaQuery.of(context).size.width / 6.0,
                //       child: ClipOval(
                //         child: FutureBuilder(
                //             future: pictureData(),
                //             builder:
                //                 (BuildContext context, AsyncSnapshot snapshot) {
                //               if (snapshot.hasData) {
                //                 return Image.network(
                //                   snapshot.data.toString(),
                //                   height: 15,
                //                   width: 10,
                //                   fit: BoxFit.cover,
                //                 );
                //               }
                //               return Container();
                //             }),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(left: 10.0),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisSize: MainAxisSize.min,
                //         children: <Widget>[
                //           Text(
                //             "Welcome",
                //             style: TextStyle(
                //               fontSize: 14,
                //               fontWeight: FontWeight.w400,
                //               color: Colors.white,
                //             ),
                //           ),
                //           SizedBox(height: 3.0),
                //           FutureBuilder(
                //               future: nameData(),
                //               builder: (BuildContext context,
                //                   AsyncSnapshot snapshot) {
                //                 if (snapshot.hasData) {
                //                   return Text(
                //                     snapshot.data.toString(),
                //                     style: TextStyle(
                //                       color: Colors.white,
                //                       fontSize: 15,
                //                       fontWeight: FontWeight.w500,
                //                     ),
                //                     textAlign: TextAlign.center,
                //                   );
                //                 }
                //                 return Container();
                //               }),
                //           // SizedBox(height: 2.0),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                      ),
                      //color: Colors.black,
                      onPressed: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();

                        SharedPreferences pref1 =
                            await SharedPreferences.getInstance();
                        //    pref1.setString("user_id", null);

                        preferences.setInt("value", 5);
                        // preferences.setString("role", null);
                        // preferences.setString("email", null);
                        // preferences.setString("id", null);
                        // preferences.setString("created_at", null);
                        // preferences.setString("name", null);
                        // preferences.setString("username", null);

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                          builder: (BuildContext context) {
                            return LoginScreen();
                          },
                        ), (route) => false);
                      },
                      tooltip: "logout",
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 1.0,
            left: 8.0,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: [
                        _isSwitched
                            ? Text(
                                "Go offline".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(
                                "Go online".toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w500),
                              ),
                        Switch(
                          value: _isSwitched,
                          onChanged: _toggleSwitch,
                          activeTrackColor: Color(0xff7eb923),
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
                Container(),
                // Row(
                //   children: <Widget>[
                //     Column(
                //       children: <Widget>[
                //         Text(
                //           "Multiple Package".toUpperCase(),
                //           style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 10.0,
                //               fontWeight: FontWeight.w500),
                //         ),
                //         Switch(
                //           value: _isSwitched2,
                //           onChanged: (value) {
                //             setState(() {
                //               _isSwitched2 = value;
                //               print(_isSwitched2);
                //             });
                //           },
                //           activeTrackColor: Color(0xff7eb923),
                //           activeColor: Colors.green,
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Color(0xff1fa2f2),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 8.0,
            ),
            child: Text(text),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  // bool _isListening() => !(_positionStreamSubscription == null ||
  //     _positionStreamSubscription.isPaused);

  // Color _determineButtonColor() {
  //   return _isListening() ? Colors.green : Colors.red;
  // }

  // void _toggleListening(String value) {
  //   if (_positionStreamSubscription == null) {
  //     final positionStream = Geolocator.getPositionStream();
  //     _positionStreamSubscription = positionStream.handleError((error) {
  //       _positionStreamSubscription?.cancel();
  //       _positionStreamSubscription = null;
  //     }).listen((position) {
  //       collectionReferenceLocation.doc(value).set({
  //         "lat": position.latitude,
  //         "long": position.longitude,
  //       }).then((value) {
  //         //   print(value.id);
  //       });

  //       setState(() {});
  //     });
  //     _positionStreamSubscription?.pause();
  //   }

  //   setState(() {
  //     if (_positionStreamSubscription == null) {
  //       return;
  //     }

  //     if (_positionStreamSubscription.isPaused) {
  //       _positionStreamSubscription.resume();
  //     } else {
  //       _positionStreamSubscription.pause();
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   if (_positionStreamSubscription != null) {
  //     _positionStreamSubscription.cancel();
  //     _positionStreamSubscription = null;
  //   }

  //   super.dispose();
  // }
}

enum _PositionItemType {
  permission,
  position,
}

class _PositionItem {
  _PositionItem(this.type, this.displayValue);

  final _PositionItemType type;
  final String displayValue;
}
