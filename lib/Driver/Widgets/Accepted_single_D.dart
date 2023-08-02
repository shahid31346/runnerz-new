import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Driver/Screens/package_details_D.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AcceptedSingleD extends StatefulWidget {
  final String profilePic;
  final String userName;
  final String mobileNo;
  final String email;
  final String pickUpLocation;
  final String dropLocation;
  final String date;
  final String totalAmount;
  final String rideId;
  final String packageId;

  AcceptedSingleD({
    Key? key,
    required this.profilePic,
    required this.userName,
    required this.email,
    required this.pickUpLocation,
    required this.mobileNo,
    required this.dropLocation,
    required this.date,
    required this.totalAmount,
    required this.rideId,
    required this.packageId,
  }) : super(key: key);

  @override
  _AcceptedSingleDState createState() => _AcceptedSingleDState();
}

class _AcceptedSingleDState extends State<AcceptedSingleD> {
  void onSubmit(String result) {
    print(result);
  }

  String? _selection;
  bool _isLoading = false;
  String responseDynamic = "";
  bool _isSwitched = false;

  _getJson() async {
    var uri = Uri.parse(
        Constants.baseUrl + 'summary/start_ride?ride_id=' + widget.rideId);

    var request = http.MultipartRequest('POST', uri)
      ..fields['lat'] = "34.8293"
      ..fields['long'] = "72.3459";

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': Constants.authToken,
    });

    var response = await request.send();
    if (response.statusCode == 200) print('Done!');

    final respStr = await response.stream.bytesToString();

    return json.decode(respStr);
  }

  void start() async {
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
    ToastContext().init(context);

        setState(() {
          Toast.show(
            'Package delivery is in progress',
          );
          _isLoading = false;
          _isSwitched = true;
        });

        print('donee');

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
                              "${widget.userName}".toUpperCase(),
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
                            SizedBox(height: 3.0),
                            Text(
                              "${widget.mobileNo}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
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
                  Column(
                    children: <Widget>[
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
                      SizedBox(
                        height: 20,
                      ),
                      // Column(
                      //   children: <Widget>[
                      //     SizedBox.fromSize(
                      //       size: Size(45, 45), // button width and height
                      //       child: ClipOval(
                      //         child: Material(
                      //           color: Constants.primary, // button color
                      //           child: InkWell(
                      //             splashColor: Colors.green, // splash color
                      //             onTap: () {}, // button pressed
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: <Widget>[
                      //                 Icon(
                      //                   Icons.call,
                      //                   color: Colors.white,
                      //                 ),
                      //                 // icon
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),
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
                          child: Column(
                            children: <Widget>[
                              Text('${widget.pickUpLocation}',
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
                          child: Column(
                            children: <Widget>[
                              Text('${widget.dropLocation}',
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
                    )
                  ],
                ),
              ),
              Divider(),
              // SizedBox(height: 10.0),
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
                    Row(
                      children: <Widget>[
                        _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black54),
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff1fa2f2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  "start".toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed: _isSwitched
                                    ? null
                                    : () {
                                        setState(() {
                                          _isLoading = true;

                                          start();
                                        });
                                      },
                              ),
                        SizedBox(
                          width: 5,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xff1fa2f2),
                            textStyle: TextStyle(color: Colors.black),
                            padding: EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.grey, width: 2)),
                          ),
                          onPressed: _isSwitched
                              ? null
                              : () async {
                                  SharedPreferences pref1 =
                                      await SharedPreferences.getInstance();
                                  pref1.setString("ride_id", widget.rideId);

                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        MyForm(onSubmit: onSubmit),
                                  );
                                },
                          child: Text(
                            "cancel".toUpperCase(),
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

typedef void MyFormCallback(String result);

class MyForm extends StatefulWidget {
  final MyFormCallback onSubmit;

  MyForm({required this.onSubmit});

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  String value = "foo";
  bool _isLoading = false;
  String responseDynamic = "";
  void _onSubmit(String result) {
    print(result);
  }

  _getJson() async {
    String value1 = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value1 = pref1.getString("ride_id")!;
    var uri =
        Uri.parse(Constants.baseUrl + 'summary/cancel_ride?ride_id=' + value1);

    var request = http.MultipartRequest('POST', uri)
      ..fields['reason'] = "$value";

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': Constants.authToken,
    });

    var response = await request.send();
    if (response.statusCode == 200) print('Done!');

    final respStr = await response.stream.bytesToString();

    return json.decode(respStr);
  }

  void cancel() async {
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
    ToastContext().init(context);

        setState(() {
          _isLoading = false;
        });

        print('donee');
        Navigator.pop(context);
        Toast.show(
          'Ride Cancelled Successfully',
        );

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
    double c_width = MediaQuery.of(context).size.width * 0.9;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: 550,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 110,
                color: Constants.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.departure_board,
                        size: 40,
                        color: Colors.white,
                      ),
                      //color: Colors.black,
                      onPressed: () {},
                      tooltip: "Cancellation",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text(
                        'Why did you Cancel?',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        'Let us know so we can improve',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.grey,
                  width: 1,
                )),
                // padding:
                //     EdgeInsets.only(left: 36.0),
                // margin: EdgeInsets.only(
                //     right: 72.0),
                // color: Color(0xff666666),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: value,
                              onChanged: (value) =>
                                  setState(() => this.value = value!),
                              value: "I expected a shorter wait time",
                            ),
                            Text(
                              'I expected a shorter wait time',
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: value,
                              onChanged: (value) =>
                                  setState(() => this.value = value!),
                              value: "Driver going in wrong direction",
                            ),
                            Text(
                              'Driver going in wrong direction',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: value,
                              onChanged: (value) =>
                                  setState(() => this.value = value!),
                              value: "I couldn\'t find my driver",
                            ),
                            Text(
                              'I couldn\'t find my driver',
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: value,
                              onChanged: (value) =>
                                  setState(() => this.value = value!),
                              value: "I was not ready for my ride",
                            ),
                            Text(
                              'I was not ready for my ride',
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: value,
                              onChanged: (value) =>
                                  setState(() => this.value = value!),
                              value: "My driver asked me to cancel",
                            ),
                            Text(
                              'My driver asked me to cancel',
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CupertinoButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (context) => DriverRAatingBox());
                              },
                              child: Text('My reason isn\'t listed'),
                            )
                          ],
                        ),
                        // Divider(),
                        _isLoading
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black54),
                                  ),
                                ),
                              )
                            : TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Constants.primary,
                                ),
                                onPressed: () {
    ToastContext().init(context);

                                  setState(() {
                                    if (value != 'foo') {
                                      _isLoading = true;
                                      cancel();
                                    } else {
                                      Toast.show(
                                        'please select a reason',
                                      );
                                    }
                                  });

                                  // Navigator.pop(context);
                                  // widget.onSubmit(value);
                                },
                                child: Text(
                                  "submit".toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DriverRAatingBox extends StatefulWidget {
  @override
  _DriverRAtingBoxState createState() => _DriverRAtingBoxState();
}

class _DriverRAtingBoxState extends State<DriverRAatingBox> {
  String value = "foo";
  double rating = 1.0;
  bool _isLoading = false;
  String responseDynamic = "";
  final _formKeyy = GlobalKey<FormState>();
  TextEditingController _commentController = TextEditingController();

  _getJson() async {
    String value1 = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value1 = pref1.getString("ride_id")!;
    var uri =
        Uri.parse(Constants.baseUrl + 'summary/cancel_ride?ride_id=' + value1);

    var request = http.MultipartRequest('POST', uri)
      ..fields['reason'] = _commentController.text;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': Constants.authToken,
    });

    var response = await request.send();
    if (response.statusCode == 200) print('Done!');

    final respStr = await response.stream.bytesToString();

    return json.decode(respStr);
  }

  void unListedReasoncancel() async {
//    getJson();
    String _body = "";

    //String amount = "";

    try {
      Map _data = await _getJson();
      print(_data);

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
    ToastContext().init(context);

        setState(() {
          _isLoading = false;
        });

        print('donee');
        Navigator.pop(context);
        Toast.show(
          'Ride Cancelled Successfully',
        );

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
    double c_width = MediaQuery.of(context).size.width * 0.9;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: 320,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: double.infinity,
                height: 60,
                color: Constants.primary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'My Reason isn\'t listed'.toUpperCase(),
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Reason',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25, top: 8.0, bottom: 8.0),
                child: Form(
                  key: _formKeyy,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.length > 0) return null;
                      return 'This field is required';
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      helperText: 'Enter your reason here',
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    controller: _commentController,
                  ),
                ),
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.black54),
                      ),
                    )
                  : TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Constants.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          _formKeyy.currentState!.validate();
                          if (_formKeyy.currentState!.validate()) {
                            _isLoading = true;
                            unListedReasoncancel();
                          }
                        });
                      },
                      child: Text(
                        "submit".toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
