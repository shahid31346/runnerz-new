import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Common/notifications.dart';
import 'package:runnerz/Driver/Screens/TripSummary/Accepted_D.dart';
import 'package:runnerz/Driver/Screens/TripSummary/Cancelled_D.dart';
import 'package:runnerz/Driver/Screens/TripSummary/Completed_D.dart';
import 'package:runnerz/Driver/Screens/TripSummary/Declined_D.dart';
import 'package:runnerz/Driver/Screens/TripSummary/Later_D.dart';
import 'package:runnerz/Driver/Screens/TripSummary/OnRide_D.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'New_D.dart';

class TripSummaryD extends StatefulWidget {
  @override
  _TripSummaryDState createState() => _TripSummaryDState();
}

class _TripSummaryDState extends State<TripSummaryD>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 7);
   // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            tooltip: "Notification",
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new),
            //color: Colors.black,
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              SharedPreferences pref1 = await SharedPreferences.getInstance();
              pref1.setString("user_id", "");

              preferences.setInt("value", 10);
              preferences.setString("role", "");
              preferences.setString("email", "");
              preferences.setString("id", "");
              preferences.setString("created_at", "");
              preferences.setString("name", "");
              preferences.setString("username", "");

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
              text: "New",
            ),
            Tab(
              text: "Accepted",
            ),
            Tab(
              text: "Declined",
            ),
            Tab(
              text: "On Ride",
            ),
            Tab(
              text: "Completed",
            ),
            Tab(
              text: "Cancelled",
            ),
            Tab(
              text: "Later",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          NewTripD(),
          AcceptedTripD(),
          DeclinedTripD(),
          OnRideTripD(),
          CompletedTripD(),
          CancelledD(),
          LaterTripD(),
        ],
      ),
    );
  }
}
