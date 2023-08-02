import 'package:flutter/material.dart';
import 'package:runnerz/Customer/screens/packagess/package_details.dart';

class CancelledSingle extends StatefulWidget {
  final String packageId;
  final String pickUpLocation;
  final String dropLocation;
  final String date;
  final String time;
  final String totalAmount;
  final String couponapplied;

  CancelledSingle({
    Key? key,
    required this.packageId,
    required this.pickUpLocation,
    required this.dropLocation,
    required this.date,
    required this.time,
    required this.totalAmount,
    required this.couponapplied,
  }) : super(key: key);

  @override
  _CancelledSingleState createState() => _CancelledSingleState();
}

class _CancelledSingleState extends State<CancelledSingle> {
  String? _selection;

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.4;

    return InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (BuildContext context) {
        //       return PackageDetails(
        //         cancelChecker: true,
        //         id: widget.packageId,
        //       );
        //     },
        //   ),
        // );
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(05.0)),
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5.0, 15.0, 13.0, 0.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  left: 2,
                  top: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                'o',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff1fa2f2),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              ' PICKUP LOCATION',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff1fa2f2),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          width: c_width,
                          child: new Column(
                            children: <Widget>[
                              new Text('${widget.pickUpLocation}',
                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                        // Text(
                        //   '$pickUpLocation',
                        //   overflow: TextOverflow.ellipsis,
                        //   style: TextStyle(
                        //     color: Colors.black54,
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                'o',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              ' DROP LOCATION',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          width: c_width,
                          child: new Column(
                            children: <Widget>[
                              new Text('${widget.dropLocation}',
                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ),

                        // Text(
                        //   '$dropLocation',
                        //   overflow: TextOverflow.ellipsis,
                        //   style: TextStyle(
                        //     color: Colors.black54,
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        PopupMenuButton<String>(
                          onSelected: (String value) {
                            setState(() {
                              _selection = value;
                            });
                          },
                          child: Icon(
                            Icons.more_vert,
                            size: 35,
                            color: Colors.black54,
                          ),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Value1',
                              child: Text('Choose value 1'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Value2',
                              child: Text('Choose value 2'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Value3',
                              child: Text('Choose value 3'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.motorcycle),
                        Text('  ${widget.date} AT '),
                        Text(widget.time),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          ' \$${widget.totalAmount}',
                          style: TextStyle(
                              color: Color(0xff1fa2f2),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
