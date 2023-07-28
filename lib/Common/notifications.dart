import 'package:flutter/material.dart';
import 'package:runnerz/Common/dummylist/notification_list.dart';
import 'package:runnerz/Common/notification_single.dart';
import 'package:runnerz/Utils/base_appbar.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    notification_list == null ? 0 : notification_list.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = notification_list[index];
                  return NotificationSingle(
                    title: cat['title'],
                    subtitle: cat['subtitle'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
