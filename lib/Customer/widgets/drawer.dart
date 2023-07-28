import 'package:flutter/material.dart';
import 'package:runnerz/Common/about.dart';
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Common/notifications.dart';
import 'package:runnerz/Common/support.dart';
import 'package:runnerz/Customer/screens/coupon_offers.dart';
import 'package:runnerz/Customer/screens/home.dart';

import 'package:runnerz/Customer/screens/invoice.dart';
import 'package:runnerz/Customer/screens/my_packages.dart';
import 'package:runnerz/Customer/screens/my_profile.dart';

import 'package:runnerz/Customer/screens/payment.dart';
import 'package:runnerz/Customer/screens/rate_card.dart';
import 'package:runnerz/Customer/screens/rating_reviews.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  nameData() async {
    String name = '';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("name")!;
    });

    return name;
  }

  pictureData() async {
    String photo = '';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      photo = preferences.getString("photo")!;
    });

    return photo;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  )),
          Divider(),
          _createDrawerItem(
              icon: Icons.verified_user,
              text: 'My Profile',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  )),
          Divider(),
          _createDrawerItem(
              icon: Icons.adjust,
              text: 'My Packages',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PackageScreen()),
                  )),
          Divider(),
          _createDrawerItem(
              icon: Icons.cloud_upload,
              text: 'Coupons/Offers',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CouponScreen()),
                  )),

          Divider(),
          _createDrawerItem(
              icon: Icons.card_membership,
              text: 'Rate Card',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RateCardScreen()),
                  )),

          Divider(),
          _createDrawerItem(
              icon: Icons.rate_review,
              text: 'Rating and Review',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RateReviewsScreen()),
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
              icon: Icons.stars,
              text: 'Support',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SupportScreen()),
                  )),
          Divider(),
          _createDrawerItem(
              icon: Icons.payment,
              text: 'Payment',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen()),
                  )),
          Divider(),
          _createDrawerItem(
              icon: Icons.notifications,
              text: 'Notification',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen()),
                  )),
          _createDrawerItem(
              icon: Icons.home,
              text: 'test invoice',
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Invoice()),
                  )),
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
            bottom: 15.0,
            left: 10.0,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.width / 6.0,
                      width: MediaQuery.of(context).size.width / 6.0,
                      child: ClipOval(
                        child: FutureBuilder(
                            future: pictureData(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return FadeInImage.assetNetwork(
                                  placeholder: 'assets/placeholder.png',
                                  image: snapshot.data.toString(),
                                  height: 15,
                                  width: 10,
                                  fit: BoxFit.cover,
                                );

                                // Image.network(
                                //   snapshot.data.toString(),
                                //   height: 15,
                                //   width: 10,
                                //   fit: BoxFit.cover,
                                // );
                              }
                              return Container();
                            }),
                        // child: Image.asset(
                        //   'assets/profile.jpeg',
                        //   height: 15,
                        //   width: 10,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 3.0),

                          FutureBuilder(
                              future: nameData(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  );
                                }
                                return Container();
                              }),
                          // Text(
                          //   "BalaKrishna",
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 15,
                          //     fontWeight: FontWeight.w500,
                          //   ),
                          // ),
                          // SizedBox(height: 2.0),
                        ],
                      ),
                    ),
                  ],
                ),
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
                        //   pref1.setString("user_id", null);

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
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {required  IconData icon, required String text,
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
}
