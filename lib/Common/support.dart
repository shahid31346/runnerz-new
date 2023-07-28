import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:runnerz/Common/support/d_log_tab.dart';
import 'package:runnerz/Common/support/discussion_tab.dart';
import 'package:runnerz/Common/support/support_tab.dart';
import 'notifications.dart';
//import 'package:enrgfood/util/const.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class SupportScreen extends StatefulWidget {
  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
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
            icon: const Icon(Icons.notifications),
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
            icon: const Icon(Icons.power_settings_new),
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
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelStyle: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
          ),
          tabs: <Widget>[
            const Tab(
              text: "Support",
            ),
            const Tab(
              text: "Discussion",
            ),
            const Tab(
              text: "D.Log",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SupportTab(),
          Discussion(),
          DLog(),
        ],
      ),
    );
  }
}
