// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as loc;
// import 'package:runnerz/Driver/Widgets/drawer_D.dart';
// import 'package:runnerz/Utils/base_appbar.dart';
// import 'package:runnerz/Utils/const.dart';

// class Dummy extends StatefulWidget {
//   @override
//   _DummyState createState() => _DummyState();
// }

// class _DummyState extends State<Dummy> {
//   var location = loc.Location();
//   String? searchAddr;
//   //GoogleMapController mapController;
//   Completer<GoogleMapController> _controller = Completer();
//   final Map<String, Marker> _markers = {};

//   LatLng? _center;
//   // Position currentLocation;
//   // Future<Position> locateUser() async {
//   //   // return Geolocator()
//   //   //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//   //   Position position;
//   //   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//   //       .then((value) => {position = value});

//   //   setState(
//   //     () {},
//   //   );
//   //   return position;
//   // }

//   // getUserLocation() async {
//   //   currentLocation = await locateUser();
//   //   setState(() {
//   //     _center = LatLng(currentLocation.latitude, currentLocation.longitude);
//   //     _markers.clear();
//   //     final marker = Marker(
//   //       markerId: MarkerId("curr_loc"),
//   //       position: LatLng(currentLocation.latitude, currentLocation.longitude),
//   //       infoWindow: InfoWindow(title: 'Your Location'),
//   //     );
//   //     _markers["Current Location"] = marker;
//   //   });

//   //   mapController.animateCamera(CameraUpdate.newCameraPosition(
//   //       CameraPosition(target: _center, zoom: 16.0)));

//   //   print('center $_center');
//   // }

//   // Future _checkGps() async {
//   //   if (!await location.serviceEnabled()) {
//   //     print('${location.requestService()}' + 'khannnnn');
//   //   }
//   // }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // getUserLocation();
//     // _checkGps();
//     // getUserLocation();
//   }

//   Future<void> animateCamera(LatLng _center1) async {
//     final GoogleMapController mapController = await _controller.future;
//     mapController.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: _center1, zoom: 11.0)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         drawer: AppDrawerD(),
//         appBar: BaseAppBar(
//           appBar: AppBar(),
//         ),
//         body: new StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('locations')
//                 .doc('70')
//                 .snapshots(),
//             builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//               if (!snapshot.hasData) {
//                 return Text(
//                   'No Data...',
//                 );
//               } else {
//                 var userDocument = snapshot.data;
//                 _center = LatLng(userDocument["lat"], userDocument['long']);

//                 _markers.clear();
//                 final marker = Marker(
//                   markerId: MarkerId("curr_loc"),
//                   position: _center,
//                   infoWindow: InfoWindow(title: 'Your Location'),
//                 );
//                 _markers["Current Location"] = marker;
//                 animateCamera(_center);
//                 print(userDocument["lat"]);
//                 print(userDocument["long"]);

//                 return
//                     // Text(userDocument["lat"].toString());

//                     GoogleMap(
//                   onMapCreated: (GoogleMapController controller) {
//                     _controller.complete(controller);
//                   },
//                   zoomControlsEnabled: false,
//                   mapType: MapType.normal,
//                   initialCameraPosition: CameraPosition(
//                     target: _center,
//                     zoom: 11.0,
//                   ),
//                   markers: _markers.values.toSet(),
//                 );
//               }
//             }));
//   }
// }
