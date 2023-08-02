import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class PackageDetailSingleD extends StatefulWidget {
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String packageCategory;
  final String packageType;
  final String packageWeight;
  final String packageSize;
  final String handleWithCare;
  final String description;
  final String comments;
  final String pickupLocation;
  final String dropLocation;
  final String pickdate;
  final String pickTime;
  final String amount;
  final String photo1;
  final String photo2;
  final String photo3;
  final String photo4;
  final String perKmPrice;
  final bool cancelChecker;

  PackageDetailSingleD({
    Key? key,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.packageCategory,
    required this.packageType,
    required this.packageWeight,
    required this.packageSize,
    required this.handleWithCare,
    required this.description,
    required this.comments,
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickdate,
    required this.pickTime,
    required this.amount,
    required this.photo1,
    required this.photo2,
    required this.photo3,
    required this.photo4,
    required this.perKmPrice,
    required this.cancelChecker,
  }) : super(key: key);

  @override
  _PackageDetailSingleDState createState() => _PackageDetailSingleDState();
}

class _PackageDetailSingleDState extends State<PackageDetailSingleD> {
  bool _isSwitched = false;
  String? _selection;
  bool _isLoading = false;
  bool _isLoading2 = false;
  String responseDynamic = "";

  _getJson() async {
    String _value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("ridee_idd")!;
    print(_value);
    var uri = Uri.parse(Constants.baseUrl +
        'summary/accept_or_declined_ride?ride_id=' +
        _value);

    var request = http.MultipartRequest('POST', uri)..fields['status'] = '7';

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': Constants.authToken,
    });

    var response = await request.send();
    if (response.statusCode == 200) print('Done!');

    final respStr = await response.stream.bytesToString();

    return json.decode(respStr);
  }

  void _acceptOrDecline() async {
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
          _isLoading2 = false;
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
            'Package Accepted Successfully',
          );

          _isLoading = false;
          _isLoading2 = false;
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
    double c_width = MediaQuery.of(context).size.width * 0.8;
    double d_width = MediaQuery.of(context).size.width * 0.4;

    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(05.0)),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 9.0,
            top: 15,
            right: 9.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${widget.customerName}'.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        '${widget.customerPhone}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        '${widget.customerEmail}',
                        style: TextStyle(
                          color: Color(0xff1fa2f2),
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        '${Constants.currency} ${widget.amount}',
                        style: TextStyle(
                            color: Color(0xff1fa2f2),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue)),
                          backgroundColor: Constants.primary,
                        ),

                        icon: Icon(
                          Icons.call,
                          color: Colors.white,
                        ), //`Icon` to display
                        label: Text(
                          'CALL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ), //`Text` to display

                        onPressed: () {
                          launch(('tel:// ${widget.customerPhone}'));

                          //Code to execute when Floating Action Button is clicked
                          //...
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(
                thickness: 1,
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Image.network(
                    '${widget.photo1}',
                    height: 80,
                    width: 70,
                  ),
                  Image.network(
                    '${widget.photo2}',
                    height: 80,
                    width: 70,
                  ),
                  Image.network(
                    '${widget.photo3}',
                    height: 80,
                    width: 70,
                  ),
                  Image.network(
                    '${widget.photo4}',
                    height: 80,
                    width: 70,
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Package Category :  ',
                    style: TextStyle(fontSize: 16.5),
                  ),
                  Text(
                    '${widget.packageCategory}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
                  )
                ],
              ),
              SizedBox(height: 2),
              Divider(),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Package Type',
                    style: TextStyle(fontSize: 16.5),
                  ),
                  Text(
                    '${widget.packageType}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
                  )
                ],
              ),
              SizedBox(height: 2),
              Divider(),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Package Weight :  ',
                    style: TextStyle(fontSize: 16.5),
                  ),
                  Text(
                    '${widget.packageWeight}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )
                ],
              ),
              SizedBox(height: 2),
              Divider(),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Package Size :  ',
                    style: TextStyle(fontSize: 16.5),
                  ),
                  Text(
                    '${widget.packageSize}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
                  )
                ],
              ),
              SizedBox(height: 2),
              Divider(),
              SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Handle with Care :  ',
                    style: TextStyle(fontSize: 16.5),
                  ),
                  Text(
                    '${widget.handleWithCare}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
                  )
                ],
              ),
              SizedBox(height: 0.5),
              Divider(),
              ExpansionTile(
                title: Text(
                  "Package Description",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text(
                      '${widget.description}',
                    ),
                  )
                ],
              ),
              ExpansionTile(
                title: Text(
                  "Comments",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text(
                      '${widget.comments}',
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(
                  right: 0.0,
                  left: 0,
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
                                  fontSize: 25,
                                  color: Color(0xff1fa2f2),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              ' PICKUP LOCATION',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff1fa2f2),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          width: d_width,
                          child: new Column(
                            children: <Widget>[
                              new Text('${widget.pickupLocation}',
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
                                fontSize: 14,
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          width: d_width,
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
                    )
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('  ${widget.pickdate} AT  '),
                        Text('${widget.pickTime}'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              Divider(),
              widget.cancelChecker
                  ? SizedBox(
                      height: 0.1,
                    )
                  : _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.black54),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 77, // match_parent
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 25,
                            ),
                            child: ElevatedButton(
                              onPressed: _isSwitched
                                  ? null
                                  : () {
                                      setState(() {
                                        _isLoading = true;

                                        _acceptOrDecline();
                                      });
                                    },
              

                              style: ElevatedButton.styleFrom(

                                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                backgroundColor: Constants.primary,
                              ),
                              child: Text(
                                "Accept Package Request".toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
        ));
  }
}
