import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Common/notifications.dart';
import 'package:runnerz/Customer/screens/packagess/PackageFromHome/packageNowHome.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'PackageLaterHome.dart';

class PackageSelectorHome extends StatefulWidget {


 
  @override
  _PackageSelectorHomeState createState() => _PackageSelectorHomeState();
}

class _PackageSelectorHomeState extends State<PackageSelectorHome>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  //  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: AppDrawer(),
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
            tooltip: "Notifications",
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new),
            //color: Colors.black,
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              preferences.setInt("value", 5);

              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (BuildContext context) {
                  return LoginScreen();
                },
              ), (route) => false);
            },
            tooltip: "Logout",
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
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
              text: "Collect now".toUpperCase(),
            ),
            Tab(
              text: "Collect later".toUpperCase(),
            ),
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[
          PackageNowFromHome(),
          PackageLaterHome(),
        ],
      ),
    );
  }
}
