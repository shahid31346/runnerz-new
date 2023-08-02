import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Driver/Screens/package_details_D.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class NewSingleD extends StatefulWidget {
  final String profilePic;
  final String customerName;
  final String pickUpLocation;
  final String dropLocation;
  final String date;
  final String totalAmount;
  final String id;
  final String packageId;

  NewSingleD(
      {Key? key,
      required this.profilePic,
      required this.customerName,
      required this.pickUpLocation,
      required this.dropLocation,
      required this.date,
      required this.totalAmount,
      required this.id,
      required this.packageId})
      : super(key: key);

  @override
  _NewSingleDState createState() => _NewSingleDState();
}

class _NewSingleDState extends State<NewSingleD> {
  String? _selection;
  bool _isLoading = false;
  bool _isLoading2 = false;
  String responseDynamic = "";
  bool _isSwitched = false;

  // about status of packages
  // status 8 is for declined package and 7 for accepted package,
  // 9 is for on ride,completed 14,later 6, cancelled 13
  String status = '';

  _getJson() async {
    var uri = Uri.parse(Constants.baseUrl +
        'summary/accept_or_declined_ride?ride_id=' +
        widget.id);

    var request = http.MultipartRequest('POST', uri)..fields['status'] = status;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': Constants.authToken,
    });

    var response = await request.send();
    if (response.statusCode == 200) print('Done!');

    final respStr = await response.stream.bytesToString();

    return json.decode(respStr);
  }

  // Future<dynamic> _getJson() async {
  //   String apiUrl =
  //       Constants.baseUrl + 'summary/accept_or_declined_ride?ride_id=1';

  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': Constants.authToken,
  //   };
  //   print(status + 'khasn');

  //   final msg = jsonEncode({
  //     "status": '7',
  //   });

  //   http.Response response = await http.post(
  //     apiUrl,
  //     headers: headers,
  //     body: msg,
  //   );

  //   return json.decode(response.body); // returns a List type
  // }

  void acceptOrDecline() async {
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
    ToastContext().init(context);

    ToastContext().init(context);

        setState(() {
          if (status == '7') {
            Toast.show(
              'Package Accepted Successfully',
            );
          } else {
            Toast.show(
              'Package Declined Successfully',
            );
          }
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
    double c_width = MediaQuery.of(context).size.width * 0.4;

    return InkWell(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(05.0)),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 13.0, 0.0),
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
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              "\$${widget.totalAmount}",
                              style: const TextStyle(
                                color: Color(0xff1fa2f2),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                          ],
                        ),
                      ),
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
                        child: const Icon(
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
              const Divider(),
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
              const Divider(),
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
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black54),
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  backgroundColor: const Color(0xff1fa2f2),
                                ),
                                child: Text(
                                  "Accept".toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: _isSwitched
                                    ? null
                                    : () {
                                        setState(() {
                                          status = '7';
                                          _isLoading = true;

                                          acceptOrDecline();
                                        });
                                      },
                              ),
                        const SizedBox(
                          width: 5,
                        ),
                        _isLoading2
                            ? const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black54),
                                ),
                              )
                            : TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: Colors.grey, width: 2)),
                                  backgroundColor: Colors.grey.withOpacity(0.2),
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                ),
                                onPressed: _isSwitched
                                    ? null
                                    : () {
                                        setState(() {
                                          status = '8';
                                          _isLoading2 = true;

                                          acceptOrDecline();
                                        });
                                      },
                                child: Text(
                                  "Decline".toUpperCase(),
                                  style: const TextStyle(
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
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
      onTap: () async {
        SharedPreferences pref1 = await SharedPreferences.getInstance();
        pref1.setString("ridee_idd", widget.id);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PackageDetailsD(
                cancelChecker: false,
                id: widget.packageId,
              );
            },
          ),
        );
      },
    );
  }
}
