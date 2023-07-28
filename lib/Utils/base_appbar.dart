import 'package:flutter/material.dart';
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Common/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  // final Color backgroundColor = Colors.red;
//final Text title;
  final AppBar appBar;

  /// you can add more fields that meet your needs

  const BaseAppBar({
    Key? key,
    // this.title,
    required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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

            preferences.setInt("value", 9);
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
          tooltip: "logout",
        ),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
