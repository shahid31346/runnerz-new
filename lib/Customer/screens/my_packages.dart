import 'package:flutter/material.dart';
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Common/notifications.dart';
import 'package:runnerz/Customer/screens/packagess/PayNow.dart';
import 'package:runnerz/Customer/screens/packagess/cancelled.dart';
import 'package:runnerz/Customer/screens/packagess/delivered.dart';
import 'package:runnerz/Customer/screens/packagess/later.dart';
import 'package:runnerz/Customer/screens/packagess/undelivered.dart';
import 'package:runnerz/Customer/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class PackageScreen extends StatefulWidget {
  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 5);
    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (c) => HomeScreen(), settings: RouteSettings(name: 'home')));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 38,
            ),
            // Container(
            //     padding: const EdgeInsets.all(8.0), child: Text('YourAppTitle'))
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            //color: Colors.black,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return NotificationScreen();
                  },
                ),
              );
            },
            tooltip: "My Orders",
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new),
            //color: Colors.black,
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              SharedPreferences pref1 = await SharedPreferences.getInstance();
              pref1.setString("user_id", "");

              preferences.setInt("value", 12);
              preferences.setString("role", '');
              preferences.setString("email", '');
              preferences.setString("id", '');
              preferences.setString("created_at", '');
              preferences.setString("name", '');
              preferences.setString("username", '');

              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (BuildContext context) {
                  return LoginScreen();
                },
              ), (route) => false);
            },
            tooltip: "Log out",
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelStyle: TextStyle(
            fontSize: 18.5,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
          ),
          tabs: <Widget>[
            Tab(
              text: "Undelivered",
            ),
            Tab(
              text: "Accepted",
            ),
            Tab(
              text: "Delivered",
            ),
            Tab(
              text: "Later",
            ),
            Tab(
              text: "Cancelled",
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Undelivered(),
            Accepted(),
            Delivered(),
            Later(),
            Cancelled(),
          ],
        ),
      ),
    );
  }
}
