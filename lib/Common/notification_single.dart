import 'package:flutter/material.dart';
import 'package:runnerz/Utils/const.dart';

class NotificationSingle extends StatelessWidget {
  final String? id;
  final String title;
  final String subtitle;

  NotificationSingle({
    Key? key,
     this.id,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Constants.primary,
                child: Image.asset('assets/logo.png'),
                // child: Icon(
                //   Icons.check,
                //   color: Colors.white,
                // ),
              ),
              title: Text(title),
              subtitle: Text(subtitle),
              onTap: () {},
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
