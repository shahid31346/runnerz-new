import 'package:flutter/material.dart';
import 'package:runnerz/Common/d_log_single.dart';
import 'package:runnerz/Common/dummylist/d_log_list.dart';

class DLog extends StatefulWidget {
  @override
  _DLogState createState() => _DLogState();
}

class _DLogState extends State<DLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: dlog == null ? 0 : dlog.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = dlog[index];
                  return DLogSingle(
                    ticketId: cat['ticket_id'],
                    title: cat['title'],
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
