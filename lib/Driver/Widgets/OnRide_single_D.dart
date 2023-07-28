import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Driver/Screens/package_details_D.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:toast/toast.dart';

class OnRideSingleD extends StatefulWidget {
  final String profilePic;
  final String customerName;
  final String email;
  final String pickUpLocation;
  final String dropLocation;
  final String date;
  final String totalAmount;
  final String rideId;
  final String packageId;

  OnRideSingleD({
    Key? key,
    required this.profilePic,
    required this.customerName,
    required this.email,
    required this.pickUpLocation,
    required this.dropLocation,
    required this.date,
    required this.totalAmount,
    required this.rideId,
    required this.packageId,
  }) : super(key: key);

  @override
  _OnRideSingleDState createState() => _OnRideSingleDState();
}

class _OnRideSingleDState extends State<OnRideSingleD> {
  bool _isSwitched = false;
  String? _selection;

  String responseDynamic = "";

  Future<Map> _getJson() async {
    Uri apiUrl = Uri.parse(Constants.baseUrl +
        'summary/complete_ride?ride_id=' +
        widget.rideId +
        '&driver_id=5');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };

    http.Response response = await http.get(
      apiUrl,
      headers: headers,
    );

    return json.decode(response.body); // returns a List type
  }

  void completeToggle() async {
//    getJson();
    String _body = "";

    //String amount = "";

    try {
      Map _data = await _getJson();

      Map<String, dynamic> dataMap = _data["data"];
      dataMap.keys.forEach((k) {
        responseDynamic = (dataMap[k].toString());
        print(dataMap[k]);
      });

      _body = (_data['status']);

      print(_body);

      if (_body == 'ERROR') {
        print("error");

        showDialog(
            context: context,
            builder: (c) {
              return AlertDialog(
                title: Text("oops"),
                content: Text(responseDynamic),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Close"),
                  )
                ],
              );
            });
      } else {
        setState(() {});

        print('donee');
        // Navigator.pop(context);
        Toast.show('Ride Completed Successfully',);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => PackageScreen()),
        // );

        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => PackageScreen()),
        //   (Route<dynamic> route) => false,
        // );
      }
    } catch (e) {
      var error = e.toString();
      if (e is SocketException) error = 'No internet';

      showDialog(
          context: context,
          builder: (c) {
            return AlertDialog(
              title: Text("oops"),
              content: Text(error),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.4;

    return InkWell(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(05.0)),
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 13.0, 0.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.width / 4.0,
                        width: MediaQuery.of(context).size.width / 4.0,
                        child: ClipOval(
                          child: Image.network(
                            "${widget.profilePic}",
                            height: 30,
                            width: 15,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "${widget.customerName}".toUpperCase(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "\$${widget.totalAmount}",
                              style: TextStyle(
                                color: Color(0xff1fa2f2),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              "${widget.email}",
                              style: TextStyle(
                                color: Color(0xff1fa2f2),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              PopupMenuButton<String>(
                                onSelected: (String value) {
                                  setState(() {
                                    _selection = value;
                                    print(value);
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
                          SizedBox(
                            height: 15,
                          ),
                          Switch(
                            value: _isSwitched,
                            onChanged: _isSwitched
                                ? null
                                : (value) {
                                    setState(() {
                                      _isSwitched = value;
                                      print(_isSwitched);
                                      completeToggle();
                                    });
                                  },
                            // onChanged:
                            //  (value) {
                            //   setState(() {
                            //     _isSwitched = value;
                            //     print(_isSwitched);
                            //     completeToggle();
                            //   });
                            // },
                            activeTrackColor: Color(0xff7eb923),
                            activeColor: Colors.green,
                          ),
                          Text(
                            'complete ride'.toUpperCase(),
                            style: TextStyle(fontSize: 9),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  left: 2,
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
                                  fontSize: 25,
                                  color: Color(0xff1fa2f2),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              ' PICKUP LOCATION',
                              style: TextStyle(
                                fontSize: 16,
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
                                  fontSize: 25,
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              ' DROP LOCATION',
                              style: TextStyle(
                                fontSize: 16,
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
                      ],
                    )
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('  ${widget.date}'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PackageDetailsD(
                cancelChecker: true,
                id: widget.packageId,
              );
            },
          ),
        );
      },
    );
  }
}
