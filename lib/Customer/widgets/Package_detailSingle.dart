import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class PackageDetailSingle extends StatefulWidget {
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
  final String driverPic;
  final String driverName;
  final String vehicleName;
  final String vehicleNumber;
  final String driverPhone;
  final String driverEmail;
  final String photo1;
  final String photo2;
  final String photo3;
  final String photo4;
  final String perKmPrice;
  final bool cancelChecker;

  PackageDetailSingle({
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
    required this.driverPic,
    required this.driverName,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.driverPhone,
    required this.driverEmail,
    required this.photo1,
    required this.photo2,
    required this.photo3,
    required this.photo4,
    required this.perKmPrice,
    required this.cancelChecker,
  }) : super(key: key);

  @override
  _PackageDetailSingleState createState() => _PackageDetailSingleState();
}

class _PackageDetailSingleState extends State<PackageDetailSingle> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    double d_width = MediaQuery.of(context).size.width * 0.4;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(05.0)),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 15.0, 13.0, 0.0),
        child: Column(
          children: <Widget>[
            // Container(
            //     width: double.infinity,
            //     height: 50,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey,
            //           offset: Offset(0.0, 1.0), //(x,y)
            //           blurRadius: 6.0,
            //         ),
            //       ],
            //       borderRadius: BorderRadius.all(
            //         Radius.circular(0.0),
            //       ),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.only(top: 0, left: 15.0),
            //       child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: <Widget>[
            //             Text(
            //               'Package Details',
            //               textAlign: TextAlign.start,
            //               style: TextStyle(
            //                   fontSize: 20,
            //                   color: Colors.black,
            //                   fontWeight: FontWeight.bold),
            //             ),
            //           ]),
            //     ),
            //   ),

            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                top: 15,
                right: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${widget.customerName}'.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    '${widget.customerPhone}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${widget.customerEmail}',
                    style: const TextStyle(
                      color: Color(0xff1fa2f2),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Package Category :  ',
                        style: TextStyle(fontSize: 16.5),
                      ),
                      Text(
                        '${widget.packageCategory}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.5),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Divider(),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Package Type',
                        style: TextStyle(fontSize: 16.5),
                      ),
                      Text(
                        '${widget.packageType}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.5),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Divider(),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Package Weight :  ',
                        style: TextStyle(fontSize: 16.5),
                      ),
                      Text(
                        '${widget.packageWeight}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Divider(),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Package Size :  ',
                        style: TextStyle(fontSize: 16.5),
                      ),
                      Text(
                        '${widget.packageSize}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.5),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Divider(),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Handle with Care :  ',
                        style: TextStyle(fontSize: 16.5),
                      ),
                      Text(
                        '${widget.handleWithCare}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.5),
                      )
                    ],
                  ),
                  const SizedBox(height: 0.5),
                  const Divider(),
                  ExpansionTile(
                    title: const Text(
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
                    title: const Text(
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
                  const SizedBox(height: 15),
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
                            const Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5.0),
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
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              width: d_width,
                              child: Column(
                                children: <Widget>[
                                  Text('${widget.pickupLocation}',
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
                            const Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5.0),
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
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              width: d_width,
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
                  const Divider(),
                  const SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Icon(Icons.motorcycle),
                            Text('  ${widget.pickdate} AT  '),
                            Text('${widget.pickTime}'),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '${Constants.currency} ${widget.amount}',
                              style: const TextStyle(
                                  color: Color(0xff1fa2f2),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.width / 4.0,
                        width: MediaQuery.of(context).size.width / 4.0,
                        child: ClipOval(
                          child: Image.network(
                            "${widget.driverPic}",
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
                              "${widget.driverName} ".toUpperCase(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              "${widget.vehicleName}",
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 4),
                              child: Container(
                                height: 25,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[500]!,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(2))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 6.0, right: 6),
                                  child: Center(
                                    child: Text(
                                      "${widget.vehicleNumber}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              "${widget.driverPhone}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${widget.driverEmail}",
                              style: const TextStyle(
                                color: Color(0xff1fa2f2),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 05.0, right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'BASE FARE / KM',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${Constants.currency} ${widget.perKmPrice}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 25.0,
                      left: 10,
                      top: 07,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'TOTAL DISTANCE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '2 KM',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            const Text(
                              'TOTAL FARE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '${Constants.currency} ${widget.amount}',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Divider(),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 05.0, right: 30.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Text(
                  //         'PEAK TIME COST / MIN',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //       Text(
                  //         '\$5.00',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Divider(),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 05.0, right: 30.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Text(
                  //         'NIGHT CHARGES / KM',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //       Text(
                  //         '\$10.00',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Divider(),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 05.0, right: 30.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Text(
                  //         'OVERTIME CHARGES / HOUR',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //       Text(
                  //         '\$5.00',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Divider(),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 05.0, right: 30.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Text(
                  //         'SERVICE TAX',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //       Text(
                  //         '\$5.00',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  widget.cancelChecker
                      ? Container()
                      : SizedBox(
                          width: double.infinity,
                          height: 77, // match_parent
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                              top: 25,
                            ),
                            child: ElevatedButton(
                              onPressed: _isSwitched
                                  ? null
                                  : () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => MyFormmss(),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              child: Text(
                                "Package Cancel".toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),

                  const SizedBox(
                    height: 23,
                  ),
                  const Text(
                    '* Terms & Conditions Apply',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyFormmss extends StatefulWidget {
  @override
  _MyFormmState createState() => _MyFormmState();
}

class _MyFormmState extends State<MyFormmss> {
  String value = "foo";
  bool _isLoading = false;
  String responseDynamic = "";
  void _onSubmit(String result) {
    print(result);
  }

  _getJson() async {
    String _value = '';
    String package__id = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;
    package__id = pref1.getString("packaaaage_id")!;

    var uri = Uri.parse(Constants.baseUrl +
        'packages/cancel_package?user_id=' +
        _value +
        '&package_id=' +
        package__id);

    print(uri);
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
                title: const Text("oops"),
                content: Text(responseDynamic),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"),
                  )
                ],
              );
            });
      } else {
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
              title: const Text("oops"),
              content: Text(error),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
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
                      icon: const Icon(
                        Icons.departure_board,
                        size: 40,
                        color: Colors.white,
                      ),
                      //color: Colors.black,
                      onPressed: () {},
                      tooltip: "Cancellation",
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text(
                        'Why did you Cancel?',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 3.0),
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
                            const Text(
                              'I expected a shorter wait time',
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: value,
                              onChanged: (value) =>
                                  setState(() => this.value = value!),
                              value: "Driver going in wrong direction",
                            ),
                            const Text(
                              'Driver going in wrong direction',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: value,
                              onChanged: (value) =>
                                  setState(() => this.value = value!),
                              value: "I couldn\'t find my driver",
                            ),
                            const Text(
                              'I couldn\'t find my driver',
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: value,
                              onChanged: (value) =>
                                  setState(() => this.value = value!),
                              value: "I was not ready for my ride",
                            ),
                            const Text(
                              'I was not ready for my ride',
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: value,
                              onChanged: (value) =>
                                  setState(() => this.value = value!),
                              value: "My driver asked me to cancel",
                            ),
                            const Text(
                              'My driver asked me to cancel',
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CupertinoButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (context) => DriverRAatingBoxxx());
                              },
                              child: const Text('My reason isn\'t listed'),
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
                                  style: const TextStyle(
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

class DriverRAatingBoxxx extends StatefulWidget {
  @override
  _DriverRAtingBoxxState createState() => _DriverRAtingBoxxState();
}

class _DriverRAtingBoxxState extends State<DriverRAatingBoxxx> {
  String value = "foo";
  double rating = 1.0;
  bool _isLoading = false;
  String responseDynamic = "";
  final _formKeyy = GlobalKey<FormState>();
  TextEditingController _commentController = TextEditingController();

  _getJson() async {
    String _value = '';
    String package__id = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;
    package__id = pref1.getString("packaaaage_id")!;

    var uri = Uri.parse(Constants.baseUrl +
        'packages/cancel_package?user_id=' +
        _value +
        '&package_id=' +
        package__id);

    print(uri);
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
                title: const Text("oops"),
                content: Text(responseDynamic),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"),
                  )
                ],
              );
            });
      } else {
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
              title: const Text("oops"),
              content: Text(error),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
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
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 25.0),
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
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      helperText: 'Enter your reason here',
                      contentPadding: const EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
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
                 

                      style:TextButton.styleFrom(

                        backgroundColor:  Constants.primary,
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
