import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Common/rating.dart';
import 'package:runnerz/Customer/screens/packagess/package_details.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeliveredSingle extends StatefulWidget {
  final String packageId;
  final String profilePic;
  final String driverName;
  final String vechilename;
  final String mobileNo;
  final String email;
  final String pickUpLocation;
  final String dropLocation;
  final String date;
  final String time;
  final String totalAmount;
  final String couponapplied;
  final String driverId;
  final String rideId;

  DeliveredSingle({
    Key? key,
    required this.packageId,
    required this.profilePic,
    required this.driverName,
    required this.vechilename,
    required this.mobileNo,
    required this.email,
    required this.pickUpLocation,
    required this.dropLocation,
    required this.date,
    required this.time,
    required this.totalAmount,
    required this.couponapplied,
    required this.driverId,
    required this.rideId,
  }) : super(key: key);

  @override
  _DeliveredSingleState createState() => _DeliveredSingleState();
}

class _DeliveredSingleState extends State<DeliveredSingle> {
  void onSubmit(String result) {
    print(result);
  }

  String? _selection;

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.4;

    return InkWell(
      splashColor: Colors.green,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PackageDetails(
                cancelChecker: false,
                id: widget.packageId,
              );
            },
          ),
        );
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(05.0)),
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(5.0, 15.0, 13.0, 0.0),
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
                              "${widget.driverName}".toUpperCase(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              "${widget.vechilename}",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 6.0, bottom: 6),
                              child: Row(
                                children: <Widget>[
                                  // Container(
                                  //   height: 25,
                                  //   decoration: BoxDecoration(
                                  //       border: Border.all(
                                  //         color: Colors.grey[500],
                                  //       ),
                                  //       borderRadius: BorderRadius.all(
                                  //           Radius.circular(2))),
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.only(
                                  //         left: 3.0, right: 3),
                                  //     child: Center(
                                  //       child: Text(
                                  //         "Alqsa2345",
                                  //         style: TextStyle(
                                  //           fontSize: 12,
                                  //           fontWeight: FontWeight.w500,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 3.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        child: Row(
                                          children: <Widget>[
                                            // button width and height

                                            Material(
                                              color:
                                                  Colors.orange, // button color
                                              child: InkWell(
                                                splashColor: Colors
                                                    .blueAccent, // splash color
                                                onTap: () async {
                                                  SharedPreferences
                                                      prefdriverRide =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefdriverRide.setString(
                                                      "driverr_id",
                                                      widget.driverId);
                                                  prefdriverRide.setString(
                                                      "ridee_id",
                                                      widget.rideId);
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          DriverRAtingBox(
                                                              onSubmit:
                                                                  onSubmit));
                                                }, // button pressed
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 2.0,
                                                          right: 3.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(Icons.star), // icon
                                                      Text(
                                                        "Rate This Driver",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
                                                        ),
                                                      ), // text
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  )
                                ],
                              ),
                            ),
                            Text(
                              "${widget.mobileNo}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "${widget.email}",
                              style: TextStyle(
                                color: Color(0xff1fa2f2),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                        //   Text('  sgAThj '),

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
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Coupon Applied: ',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${widget.couponapplied}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

typedef void DriverRAtingBoxCallback(String result);

class DriverRAtingBox extends StatefulWidget {
  final DriverRAtingBoxCallback? onSubmit;

  DriverRAtingBox({this.onSubmit});

  @override
  _DriverRAtingBoxState createState() => _DriverRAtingBoxState();
}

class _DriverRAtingBoxState extends State<DriverRAtingBox> {
  String value = "foo";
  double rating = 3.0;
  bool _isLoading = false;

  final _formKeyy = GlobalKey<FormState>();
  TextEditingController _commentController = TextEditingController();

  // Future<Map> _getJson() async {
  //   String _value = '';
  //   String _driverId = '';
  //   String _riderId = '';

  //   SharedPreferences pref1 = await SharedPreferences.getInstance();
  //   _value = pref1.getString("user_id");

  //   SharedPreferences prefdriverRide = await SharedPreferences.getInstance();
  //   _driverId = prefdriverRide.getString("driverr_id");
  //   _riderId = prefdriverRide.getString("ridee_id");

  //   String apiUrl = Constants.baseUrl +
  //       'customers/rate_a_driver?user_id=' +
  //       _value +
  //       '&driver_id=' +
  //       _driverId +
  //       '&ride_id=' +
  //       _riderId;
  //   print(apiUrl);
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': Constants.authToken,
  //   };
  //   final msg = jsonEncode({
  //     "rating": rating,
  //     "review": _commentController.text,
  //   });

  //   http.Response response = await http.post(
  //     apiUrl,
  //     headers: headers,
  //     body: msg,
  //   );

  //   return json.decode(response.body); // returns a List type
  // }

  getJson() async {
    String _value = '';
    String _driverId = '';
    String _riderId = '';

    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;

    SharedPreferences prefdriverRide = await SharedPreferences.getInstance();
    _driverId = prefdriverRide.getString("driverr_id")!;
    _riderId = prefdriverRide.getString("ridee_id")!;

    var uri = Uri.parse(Constants.baseUrl +
        'customers/rate_a_driver?user_id=' +
        _value +
        '&driver_id=' +
        _driverId +
        '&ride_id=' +
        _riderId);

    var request = http.MultipartRequest('POST', uri)
      ..fields['rating'] = rating.toString()
      ..fields['review'] = _commentController.text;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': Constants.authToken
    });

    var response = await request.send();
    if (response.statusCode == 200) print('Done!');

    final respStr = await response.stream.bytesToString();

    return json.decode(respStr);
  }

  void rateReviewGiver() async {
    String _body = "";
    String values = "";

    try {
      // _isLoading = false;

      Map _data = await getJson();

      print(_data);

      Map<String, dynamic> dataMap = _data["data"];
      dataMap.keys.forEach((k) {
        values = (dataMap[k].toString());
        print(dataMap[k]);
      });

      _body = (_data['status']);

      // print(_data);

      if (_body == 'ERROR') {
        Navigator.pop(context);
        setState(() {
          _isLoading = false;
        });
        // print("$_data");
        showDialog(
            context: context,
            builder: (c) {
              return AlertDialog(
                title: Text("oops"),
                content: Text(values),
                actions: <Widget>[
                  // TextButton(
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   child: Text("Close"),
                  // )
                ],
              );
            });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('donee');
        Navigator.pop(context);

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: Container(
                  height: 170,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 15),
                        Container(
                          height: 60,
                          width: 60,
                          child: ClipOval(
                            child: Material(
                              color: Colors.blue, // button color
                              child: InkWell(
                                splashColor: Colors.red, // inkwell color
                                child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 50,
                                    )),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25),
                        Text(
                          'Got it'.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('Thanks for your feedback'),
                      ],
                    ),
                  ),
                ),
              );
            });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      var title = e.toString();
      if (e is SocketException) title = 'No internet';
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(title),
//        content: Text(values),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Close"),
                  )
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.9;

    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Center(
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)), //this right here
              child: Container(
                height: 360,
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
                              'Rate this driver'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: StarRating(
                              size: 35,
                              rating: rating,
                              onRatingChanged: (rating) =>
                                  setState(() => this.rating = rating),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: Text(
                              'Description',
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
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                              ),
                              hintText: 'Enter description here',
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
                          ? Center(child: CircularProgressIndicator())
                          : TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Constants.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _formKeyy.currentState!.validate();
                                  if (_formKeyy.currentState!.validate()) {
                                    _isLoading = true;
                                    rateReviewGiver();
                                  }
                                });
                              },
                              child: new Text(
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
          ),
        ),
      ],
    );
  }
}
