import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Customer/screens/my_packages.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverInfoSingle extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String profielPic;
  final String rating;
  final String vehicleName;
  final String vehicleNumber;
  final String id;

  DriverInfoSingle({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.profielPic,
    required this.rating,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.id,
  }) : super(key: key);

  @override
  _DriverInfoSingleState createState() => _DriverInfoSingleState();
}

class _DriverInfoSingleState extends State<DriverInfoSingle> {
  String? _selection;
  String responseDynamic = "";
  bool _isLoading = false;

  Future<dynamic> _getJson() async {
    String value = '';
    String _packageid = '';
    String _identifier = '';

    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value = pref1.getString("user_id")!;
    _packageid = pref1.getString("package_id")!;
    _identifier = pref1.getString("identifier")!;

    Uri apiUrl = Uri.parse(Constants.baseUrl +
        'packages/add_package_process_assign_driver?user_id=' +
        value +
        '&package_id=' +
        _identifier);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };

    print(widget.id);
    final msg = jsonEncode({
      "driver_id": widget.id,
    });

    print(msg);

    http.Response response = await http.post(
      apiUrl,
      headers: headers,
      body: msg,
    );

    return json.decode(response.body); // returns a List type
  }

  void sendRequest() async {
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
        setState(() {
          _isLoading = false;
        });
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
        setState(() {
          _isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PackageScreen()),
        );

        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => PackageScreen()),
        //   (Route<dynamic> route) => false,
        // );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 8.0, 13.0, 0.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'EST.TIME',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              '8 Minutes',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ],
                        ),

                        Stack(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage('${widget.profielPic}'),
                              radius: 50.0,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Color(0xffe3c026).withOpacity(0.8)),
                                margin: EdgeInsets.only(left: 65, top: 65),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "${widget.rating}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Icon(Icons.star), // icon
                                    // text
                                  ],
                                ),
                              ),

                              //             ElevatedButton(
                              //   shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(10.0),
                              //       side: BorderSide(
                              //           color: Colors.grey.withOpacity(0.5))),
                              //   onPressed: () {},
                              //   // splash color
                              //   // button pressed

                              //   color: Color(0xffe3c026),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: <Widget>[
                              //       Text("${widget.rating}"),
                              //       SizedBox(
                              //         width: 8,
                              //       ),
                              //       Icon(Icons.star), // icon
                              //       // text
                              //     ],
                              //   ),
                              // ),
                            ),
                          ],
                        ),

                        // ClipOval(
                        //   child: Image.network(
                        //     '${widget.profielPic}',
                        //     height: 100,
                        //     width: 100,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        Column(
                          children: <Widget>[
                            Text(
                              '${widget.vehicleName}',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 1.5, bottom: 1.5),
                              child: Text(
                                '${widget.vehicleNumber}',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Container(
                              height: 25,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[500]!,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(2))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 3.0, right: 3),
                                child: Center(
                                  child: Text(
                                    "ALQ1S16235",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      thickness: 1.3,
                    ),
                    SizedBox(
                      height: 9,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${widget.name}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              '${widget.phone}',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              '${widget.email}',
                              style: TextStyle(
                                  color: Constants.primary, fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.black54),
                                  ),
                                )
                              : OutlinedButton(
                                  child: new Text(
                                    "Assign".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16, color: Constants.primary),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isLoading = true;
                                      sendRequest();
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1.0),
                                    ),
                                  ),
                                ),
                        ),
                        // Expanded(
                        //   child: new OutlineButton(
                        //     child: new Text(
                        //       "Cancel",
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //       ),
                        //     ),
                        //     onPressed: () {},
                        //     highlightedBorderColor: Constants.primary,
                        //     shape: new RoundedRectangleBorder(
                        //       borderRadius: new BorderRadius.circular(1.0),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
