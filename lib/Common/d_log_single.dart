import 'package:flutter/material.dart';

class DLogSingle extends StatelessWidget {
  final String ticketId;
  final String title;

  DLogSingle({
    Key? key,
    required this.ticketId,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.6;

    return InkWell(
      splashColor: Colors.green,
      onTap: () {},
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, right: 10, top: 5, bottom: 5),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(05.0)),
          elevation: 4.0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Ticket ID  : ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '$ticketId',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          height: 12,
                          width: 12,
                          child: RawMaterialButton(
                            onPressed: () {},
                            elevation: 2.0,
                            fillColor: Colors.green,
                            padding: EdgeInsets.all(15.0),
                            shape: CircleBorder(),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Title  : ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      width: c_width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              '$title',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
