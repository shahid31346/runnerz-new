import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:runnerz/Common/listCons/fare_detailCons.dart';
import 'package:runnerz/Customer/screens/coupon_on_map.dart';
import 'package:runnerz/Customer/screens/packagess/add_package_one.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DropMap extends StatefulWidget {
  final String farePrice;
  final String pickUpLocation;
  final String dropLocation;
  final double dropLat;
  final double dropLng;
  final double pickLat;
  final double pickLng;

  DropMap({
    required this.farePrice,
    required this.pickUpLocation,
    required this.dropLocation,
    required this.dropLat,
    required this.dropLng,
    required this.pickLat,
    required this.pickLng,
  });
  @override
  _DropMapState createState() => _DropMapState();
}

class _DropMapState extends State<DropMap> {
  String? searchAddr;
  GoogleMapController? mapController;
  FareDetail? detail;
  bool loading = false;
  bool apiCalled = false;
  String responseDynamic = "";
  bool _isLoading = false;
  final Map<String, Marker> _markers = {};

  var location = loc.Location();

  LatLng? center;
  Position? currentLocation;

  Future<Position> locateUser() async {
    // return Geolocator()
    //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    Position? position;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) => {position = value});

    setState(
      () {},
    );
    return position!;
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    setState(() {
      center = LatLng(widget.dropLat, widget.dropLng);
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(widget.dropLat, widget.dropLng),
        infoWindow: InfoWindow(title: 'Drop Location'),
      );
      _markers["Drop Location"] = marker;
    });

    mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: center!, zoom: 16.0)));

    print('center $center');
  }

  Future _checkGps() async {
    if (!await location.serviceEnabled()) {
      print('${location.requestService()}' + 'khannnnn');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _checkGps();

    getUserLocation();
  }
  //Get Api for showing

  Future<Map> getJsonDetail() async {
    String _fareid = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();

    _fareid = pref1.getString("fare_id")!;

    Uri apiUrl = Uri.parse(
        'http://35.158.106.116/api/packages/get_fare_by_id?fare_id=$_fareid');
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

  _getDetail() async {
    setState(() {
      loading = true;
      apiCalled = true;
    });
    try {
      Map _data1 = await getJsonDetail();

      if (_data1['data'] is List) {
        FareDetailResponse prodDetailResponse =
            FareDetailResponse.fromJson(_data1);
        setState(() {
          loading = false;
          detail = prodDetailResponse.data![0];
        });
      } else {
        setState(() {
          detail = FareDetail();
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        detail = null;
        loading = false;
      });
    }
  }
  //Get Api for showing finish

  //post api for sending details start

  Future<Map> _getJson() async {
    String _value = '';
    String _packageid = '';
    String _fareid = '';

    Map _data1 = await getJsonDetail();

    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;
    _packageid = pref1.getString("package_id")!;
    _fareid = pref1.getString("fare_id")!;
    print(_value);
    print(_packageid);

    //'http://35.158.106.116/api/packages/add_package_process_four?user_id=7&package_id=2&fare_id=1';

    Uri apiUrl = Uri.parse(Constants.baseUrl +
        'packages/add_package_process_four?user_id=' +
        _value +
        '&package_id=' +
        _packageid +
        '&fare_id=' +
        _fareid);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };
    final msg = jsonEncode({
      "drop_location": 'mingora bazar swat kpk pakistan',
      "amount": _data1['data'][0]['price'],
      "weight": _data1['data'][0]['weight'],
      "size": _data1['data'][0]['size'],
    });

    http.Response response = await http.post(
      apiUrl,
      headers: headers,
      body: msg,
    );

    return json.decode(response.body); // returns a List type
  }

  void khan() async {
//    getJson();
    String _body = "";

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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return CouponMap(
                farePrice: widget.farePrice,
                pickUpLocation: Constants.mainAdressPickup!,
                dropLocation: Constants.addressForDrop!,
                dropLat: Constants.latitudeForDrop!,
                dropLng: Constants.longitudeForDrop!,
                amount: widget.farePrice,
                pickLat: Constants.latitudeForPickup!,
                pickLng: Constants.longitudeForPickup!,
              );
            },
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

  //post finish

  @override
  Widget build(BuildContext context) {
    if (!apiCalled) {
      Future.delayed(Duration(milliseconds: 2), () {
        _getDetail();
      });
    }
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: _getDetailWidget(context),
    );
  }

  Widget _getDetailWidget(BuildContext context) {
    if (!loading) {
      return Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: onMapCreated,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.dropLat, widget.dropLng),
              zoom: 16.6,
            ),
            markers: _markers.values.toSet(),
            // markers: {
            //   currentLocationMarker,
            // },
          ),
          Positioned(
            top: 7.0,
            right: 5.0,
            left: 5.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 0.0),
              child: Column(
                children: [
                  Card(
                    elevation: 3.0,
                    child: Container(
                      width: double.infinity,
                      height: 44,
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

                  // Card(
                  //   elevation: 3.0,
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: 50,
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(5.0),
                  //       ),
                  //     ),
                  //     child: Center(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //             'Drop Location',
                  //             style: TextStyle(
                  //                 color: Colors.pinkAccent,
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.w500),
                  //           ),
                  //           Center(
                  //             child: Padding(
                  //               padding: const EdgeInsets.only(left: 8.0),
                  //               child: Row(
                  //                 children: [
                  //                   Padding(
                  //                     padding:
                  //                         const EdgeInsets.only(bottom: 7.0),
                  //                     child: Text(
                  //                       'o',
                  //                       style: TextStyle(
                  //                         fontSize: 20,
                  //                         color: Colors.pinkAccent,
                  //                         fontWeight: FontWeight.w600,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   Column(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.center,
                  //                     children: [
                  //                       Center(
                  //                         child: Padding(
                  //                           padding: const EdgeInsets.only(
                  //                               left: 15.0),
                  //                           child: Text(
                  //                             '${widget.dropLocation}',
                  //                             overflow: TextOverflow.ellipsis,
                  //                             style: TextStyle(
                  //                                 color: Colors.grey,
                  //                                 fontWeight: FontWeight.bold),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 225,
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
                        height: 120,
                        decoration: BoxDecoration(
                            border: Border.all(color: Constants.primary),
                            borderRadius: BorderRadius.circular(3.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text('package size'),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text(
                                            '${detail!.size}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text('package Weight'),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text(
                                            '${detail!.weight} kg',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(
                              color: Constants.primary,
                              thickness: 0.5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Text('Min Fare'.toUpperCase()),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2),
                                          child: Text(
                                            '${Constants.currency} ${widget.farePrice} (${Constants.currency} ${detail!.price}/${detail!.rateType})',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    new AddPackageOne()));
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.edit),
                                          Text(
                                            'Edit',
                                            style: TextStyle(
                                                color: Constants.primary),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 77, // match_parent
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 23.0,
                          right: 23.0,
                          top: 20,
                        ),
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.black54),
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  "Next".toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isLoading = true;
                                    khan();
                                  });
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
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  // searchandNavigate() {
  //   Geolocator().placemarkFromAddress(searchAddr).then((result) {
  //     mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //         target:
  //             LatLng(result[0].position.latitude, result[0].position.longitude),
  //         zoom: 10.0)));
  //   });
  // }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}

class FareDetailResponse {
  final List<FareDetail>? data;
  final String status;

  FareDetailResponse({required this.data, required this.status});

  factory FareDetailResponse.fromJson(Map<dynamic, dynamic> json) {
    return FareDetailResponse(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => FareDetail.fromJson(i)).toList()
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
