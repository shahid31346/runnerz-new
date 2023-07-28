// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as loc;
// import 'package:runnerz/Driver/Widgets/drawer_D.dart';
// import 'package:runnerz/Utils/base_appbar.dart';
// import 'package:runnerz/Utils/const.dart';

// class DummyMap extends StatefulWidget {
//   @override
//   _DummyMapState createState() => _DummyMapState();
// }

// class _DummyMapState extends State<DummyMap> {
//   var location = loc.Location();
//   String searchAddr;
//   GoogleMapController mapController;
//   final Map<String, Marker> _markers = {};

//   LatLng _center;
//   Position currentLocation;

//   Future<Position> locateUser() async {
//     return Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   }

//   getUserLocation() async {
//     currentLocation = await locateUser();
//     setState(() {
//       _center = LatLng(currentLocation.latitude, currentLocation.longitude);
//       _markers.clear();
//       final marker = Marker(
//         markerId: MarkerId("curr_loc"),
//         position: LatLng(currentLocation.latitude, currentLocation.longitude),
//         infoWindow: InfoWindow(title: 'Your Location'),
//       );
//       _markers["Current Location"] = marker;
//     });

//     mapController.animateCamera(CameraUpdate.newCameraPosition(
//         CameraPosition(target: _center, zoom: 16.0)));

//     print('center $_center');
//   }

//   Future _checkGps() async {
//     if (!await location.serviceEnabled()) {
//       print('${location.requestService()}' + 'khannnnn');
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // getUserLocation();
//     _checkGps();
//     getUserLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         drawer: AppDrawerD(),
//         appBar: BaseAppBar(
//           appBar: AppBar(),
//         ),
//         body: Stack(
//           children: <Widget>[
//             GoogleMap(
//               onMapCreated: onMapCreated,
//               zoomControlsEnabled: false,
//               mapType: MapType.normal,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(40.7128, -74.0060),
//                 zoom: 11.0,
//               ),
//               markers: _markers.values.toSet(),
//             ),
//             // Positioned(
//             //   top: 15.0,
//             //   right: 15.0,
//             //   left: 15.0,
//             //   child: Container(
//             //     height: 50.0,
//             //     width: double.infinity,
//             //     decoration: BoxDecoration(
//             //       borderRadius: BorderRadius.circular(10.0),
//             //       color: Colors.white70,
//             //     ),
//             //     child: TextField(
//             //       decoration: InputDecoration(
//             //           hintText: 'Enter Address',
//             //           border: InputBorder.none,
//             //           contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
//             //           suffixIcon: IconButton(
//             //               icon: Icon(Icons.search),
//             //               onPressed: searchandNavigate,
//             //               iconSize: 30.0)),
//             //       onChanged: (val) {
//             //         setState(() {
//             //           searchAddr = val;
//             //         });
//             //       },
//             //     ),
//             //   ),
//             // ),
//             Positioned.fill(
//               bottom: 18.0,
//               right: 20.0,
//               left: 20.0,
//               child: Align(
//                 alignment: Alignment.bottomCenter,
//                 child: SizedBox(
//                   width: double.infinity,

//                   height: 77,
//                   // match_parent
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       top: 25,
//                     ),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         //getUserLocation();
//                       },
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       color: Constants.primary,
//                       child: Text(
//                         "Go online".toUpperCase(),
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 18,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }

//   searchandNavigate() {
//     Geolocator().placemarkFromAddress(searchAddr).then((result) {
//       mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//           target:
//               LatLng(result[0].position.latitude, result[0].position.longitude),
//           zoom: 10.0)));
//     });
//   }

//   void onMapCreated(controller) {
//     setState(() {
//       mapController = controller;
//     });
//   }
// }
