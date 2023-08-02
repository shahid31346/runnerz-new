import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_google_map_polyline_point/flutter_polyline_point.dart';
import 'package:flutter_google_map_polyline_point/point_lat_lng.dart';
import 'package:flutter_google_map_polyline_point/utils/polyline_result.dart';
import 'package:flutter_google_map_polyline_point/utils/request_enums.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'driver_info_map.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CouponMap extends StatefulWidget {
  final String farePrice;
  final String amount;
  final String pickUpLocation;
  final String dropLocation;
  final double dropLat;
  final double dropLng;
  final double pickLat;
  final double pickLng;

  CouponMap({
    required this.farePrice,
    required this.amount,
    required this.pickUpLocation,
    required this.dropLocation,
    required this.dropLat,
    required this.dropLng,
    required this.pickLat,
    required this.pickLng,
  });
  @override
  _CouponMapState createState() => _CouponMapState();
}

class _CouponMapState extends State<CouponMap> {
  String? searchAddr;
  GoogleMapController? mapController;
  bool _isLoading = false;
  bool amountChecker = false;
  String responseDynamic = "";
  String amount1 = '';
  String amounterr = '';
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _couponControl = new TextEditingController();

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  @override
  void initState() {
    super.initState();

    /// origin marker
    _addMarker(LatLng(widget.pickLat, widget.pickLng), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(widget.dropLat, widget.dropLng), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  Future<dynamic> _getJson() async {
    String value = '';
    String packageid = '';
    String _identifier = '';

    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value = pref1.getString("user_id")!;
    packageid = pref1.getString("package_id")!;
    _identifier = pref1.getString("identifier")!;

    Uri apiUrl = Uri.parse(Constants.baseUrl +
        'packages/add_package_process_five?user_id=' +
        value +
        '&package_id=' +
        _identifier);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };
    final msg = jsonEncode({
      "coupon": _couponControl.text,
    });

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
          amountChecker = true;
          _isLoading = false;
          amounterr = (_data['total_price']);
          print(amounterr);
        });
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

  Future<dynamic> _getJsonForDelivery() async {
    String sendinAmount;
    String value = '';
    String _packageid = '';
    String _identifier = '';

    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value = pref1.getString("user_id")!;
    _packageid = pref1.getString("package_id")!;
    _identifier = pref1.getString("identifier")!;

    Uri apiUrl = Uri.parse(
        '${Constants.baseUrl}packages/add_package_process_six?user_id=$value&package_id=$_identifier');

    print(
        '${Constants.baseUrl}packages/add_package_process_six?user_id=$value&package_id=$_identifier');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };

    if (amountChecker == false) {
      sendinAmount = amount1;
    } else {
      sendinAmount = amounterr;
    }
    final msg = jsonEncode({
      "amount": sendinAmount,
    });

    print(msg);


    http.Response response = await http.post(
      apiUrl,
      headers: headers,
      body: msg,
    );

    return json.decode(response.body); // returns a List type
  }

  void requestOfDelivery() async {
//    getJson();
    String _body = "";

    //String amount = "";

    try {
      Map _data = await _getJsonForDelivery();

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriverInfoMap(
              dropLat: widget.dropLat,
              dropLng: widget.dropLng,
              pickLat: widget.pickLat,
              pickLng: widget.pickLng,
            ),
          ),
        );
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
    amount1 = widget.amount;
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
                target: LatLng(widget.pickLat, widget.pickLng), zoom: 12.5),
            myLocationEnabled: true,
            tiltGesturesEnabled: true,
            compassEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: onMapCreated,
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
            top: 15.0,
            right: 15.0,
            left: 15.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 0.0),
              child: Column(
                children: [
                  Card(
                    elevation: 3.0,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xffececec),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: Text(
                                      'o',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xff1fa2f2),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '  PickUp Location',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff1fa2f2),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${widget.pickUpLocation}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 3.0,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: Text(
                                      'o',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.pinkAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '  Drop Location',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.pinkAccent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${widget.dropLocation}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 207,
                color: Colors.white.withOpacity(0.9),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                        left: 15,
                        right: 15,
                      ),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(color: Constants.primary),
                            borderRadius: BorderRadius.circular(3.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              width: 180,
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(10.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white,
                                      ),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    hintText: "Coupon Code",
                                    hintStyle: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.length > 0) return null;
                                    return 'This field is required';
                                  },
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  controller: _couponControl,
                                ),
                              ),
                            ),
                            _isLoading
                                ? Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.black54),
                                    ),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      _formKey.currentState!.validate();
                                      if (_formKey.currentState!.validate()) {
                                        sendRequest();
                                        setState(() {
                                          _isLoading = true;
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Apply',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Constants.primary),
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${Constants.currency}'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          amountChecker
                              ? Text(
                                  '$amounterr'.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  '${widget.farePrice}'.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                    ),
                    Text('Total Amount'),
                    SizedBox(
                      width: double.infinity,
                      height: 77, // match_parent
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 23.0, right: 23.0, top: 10, bottom: 5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            "Request of Delivery".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            requestOfDelivery();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
      infoWindow: InfoWindow(title: 'Location'),
    );
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Constants.primary,
        width: 4,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Constants.api_key,
      PointLatLng(widget.pickLat, widget.pickLng),
      PointLatLng(widget.dropLat, widget.dropLng),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
