import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:location/location.dart' as loc;
import 'package:runnerz/Driver/Widgets/drawer_D.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenD extends StatefulWidget {
  @override
  _HomeScreenDState createState() => _HomeScreenDState();
}

class _HomeScreenDState extends State<HomeScreenD> {
  //  final List<_PositionItem> _positionItems = <_PositionItem>[];
  StreamSubscription<Position>? _positionStreamSubscription;

  // CollectionReference collectionReferenceLocation =
  //     FirebaseFirestore.instance.collection('locations');
  bool _isSwitched = false;
  bool _isSwitched2 = false;
  String? onlineStatus;
  String responseDynamic = "";
  bool _isLoading = false;
  String? valueforSharedprefrences;
  var location = loc.Location();
  String? searchAddr;
  GoogleMapController? mapController;

  bool animate = true;
  final Map<String, Marker> _markers = {};

  LatLng? _center;
  Position? currentLocation;
  Future<Position> locateUser() async {
    // return Geolocator()
    //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.requestPermission();

    // Test if location services are enabled.
    //serviceEnabled = await Geolocator.isLocationServiceEnabled();

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
      _center = LatLng(currentLocation!.latitude, currentLocation!.longitude);
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation!.latitude, currentLocation!.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker;
    });

    mapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _center!, zoom: 16.0)));

    print('center $_center');
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
    // getUserLocation();
   // _checkGps();
    getUserLocation();
  }

  onlineStatusFunction() async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    setState(() {
      _isSwitched = pref1.getBool("online_status")!;
    });
  }

  // nameData() async {
  //   onlineStatusFunction();
  //   String name = '';
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     name = preferences.getString("name");
  //   });
  //   return name;
  // }

  // pictureData() async {
  //   String photo = '';
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     photo = preferences.getString("photo");
  //   });

  //   return photo;
  // }

  Future<Map> _getJsonOnline() async {
    String value = '';

    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value = pref1.getString("user_id")!;
    print(value);

    if (_isSwitched) {
      onlineStatus = '15';
      pref1.setBool("online_status", true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You're Online Now"),
        ),
      );

      // _toggleListening(value);
    } else {
      onlineStatus = '16';
      pref1.setBool("online_status", false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You're Offline Now"),
        ),
      );
      // _toggleListening(value);
    }

    Uri apiUrl = Uri.parse(Constants.baseUrl +
        'customers/switch_user?driver_id=$value&is_visible=$onlineStatus'); // +
    //vechiletype;

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

  void onlineStatusGetter() async {
//    getJson();
    String _body = "";

    //String amount = "";

    try {
      Map _data = await _getJsonOnline();

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
        setState(() {
          _isLoading = false;
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

  void _toggleSwitch() {
    setState(() {
      _isSwitched = !_isSwitched;
      print(_isSwitched);
      onlineStatusGetter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawerD(),
        appBar: BaseAppBar(
          appBar: AppBar(),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: onMapCreated,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(40.7128, -74.0060),
                zoom: 11.0,
              ),
              markers: _markers.values.toSet(),
            ),
            // Positioned(
            //   top: 15.0,
            //   right: 15.0,
            //   left: 15.0,
            //   child: Container(
            //     height: 50.0,
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10.0),
            //       color: Colors.white70,
            //     ),
            //     child: TextField(
            //       decoration: InputDecoration(
            //           hintText: 'Enter Address',
            //           border: InputBorder.none,
            //           contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
            //           suffixIcon: IconButton(
            //               icon: Icon(Icons.search),
            //               onPressed: searchandNavigate,
            //               iconSize: 30.0)),
            //       onChanged: (val) {
            //         setState(() {
            //           searchAddr = val;
            //         });
            //       },
            //     ),
            //   ),
            // ),
            Positioned.fill(
              bottom: 18.0,
              right: 20.0,
              left: 20.0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,

                  height: 77,
                  // match_parent
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 25,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _toggleSwitch();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: _isSwitched
                          ? Text("Go offline".toUpperCase(),
                          style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                          )
                          : Text(
                              "Go online".toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
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
