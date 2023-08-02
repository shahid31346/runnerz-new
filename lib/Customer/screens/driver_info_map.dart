import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_google_map_polyline_point/flutter_polyline_point.dart';
import 'package:flutter_google_map_polyline_point/point_lat_lng.dart';
import 'package:flutter_google_map_polyline_point/utils/polyline_result.dart';
import 'package:flutter_google_map_polyline_point/utils/request_enums.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Common/listCons/driverinfoCons.dart';
import 'package:runnerz/Customer/widgets/DriverinfoSingle.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverInfoMap extends StatefulWidget {
  final double dropLat;
  final double dropLng;
  final double pickLat;
  final double pickLng;

  DriverInfoMap({
    required this.dropLat,
    required this.dropLng,
    required this.pickLat,
    required this.pickLng,
  });
  @override
  _DriverInfoMapState createState() => _DriverInfoMapState();
}

class _DriverInfoMapState extends State<DriverInfoMap> {
  String? searchAddr;
  GoogleMapController? mapController;
  int _index = 0;

  Future<Map> _getJson() async {
    // String vechiletype = '';

    // SharedPreferences prefv = await SharedPreferences.getInstance();
    // vechiletype = prefv.getString("vechile_id")!;

    Uri apiUrl = Uri.parse(Constants.baseUrl +
        'customers/fetch_driver_by_vehicle_type?vehicle_type_id=1'); // +
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

  Future<List<DriverinfoCons>> getDelivered() async {
    Map _data = await _getJson();

    DriverInfoResponse prodResponse = DriverInfoResponse.fromJson(_data);
    if (prodResponse.status == 'SUCCESS') return prodResponse.data!;

    return [];
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

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  @override
  void initState() {
    super.initState();
    getDelivered();

    /// origin marker
    _addMarker(LatLng(widget.pickLat, widget.pickLng), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(widget.dropLat, widget.dropLng), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
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

          Stack(children: <Widget>[
            Positioned(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 270,
                  width: double.infinity,
                  child: FutureBuilder<List<DriverinfoCons>>(
                    future: getDelivered(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.length > 0) {
                          List<DriverinfoCons> cateee = snapshot.data!;
                          return ListView.builder(
                            //scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            primary: false,
                            //physics: NeverScrollableScrollPhysics(),
                            itemCount: cateee == null ? 0 : cateee.length,
                            itemBuilder: (BuildContext context, int index) {
                              DriverinfoCons cat = cateee[index];

                              return DriverInfoSingle(
                                name: cat.name,
                                vehicleName: cat.vehicleName ?? '',
                                vehicleNumber: cat.vehicleNumber ?? '',
                                phone: cat.phone ?? '',
                                email: cat.email,
                                profielPic: cat.profielPic ?? '',
                                rating: cat.rating ?? '',
                                id: cat.id,
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              'Sorry, No Drivers Available at the moment',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          );
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: FractionalTranslation(
            //     translation: Offset(0, -1.5),
            //     child: ClipOval(
            //       child: Image.asset(
            //         'assets/profile.jpeg',
            //         height: 100,
            //         width: 100,
            //         fit: BoxFit.cover,
            //       ),
            //     ),
            //   ),
            // ),
          ]),

          // Stack(children: <Widget>[
          //   Positioned(
          //     child: Align(
          //       alignment: Alignment.bottomCenter,
          //       child: Container(
          //         width: double.infinity,
          //         height: 205,
          //         color: Colors.white.withOpacity(0.9),
          //         child: Padding(
          //           padding: const EdgeInsets.all(16.0),
          //           child: Column(
          //             children: <Widget>[
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: <Widget>[
          //                   Column(
          //                     children: <Widget>[
          //                       Text(
          //                         'EST.TIME',
          //                         style: TextStyle(fontSize: 12),
          //                       ),
          //                       Text(
          //                         '8 Minutes',
          //                         style: TextStyle(
          //                             fontSize: 12,
          //                             fontWeight: FontWeight.w600,
          //                             color: Colors.black),
          //                       ),
          //                     ],
          //                   ),
          //                   Column(
          //                     children: <Widget>[
          //                       Text(
          //                         'Cargo Truck',
          //                         style: TextStyle(
          //                             fontSize: 12,
          //                             fontWeight: FontWeight.w600,
          //                             color: Colors.black),
          //                       ),
          //                       Padding(
          //                         padding: const EdgeInsets.only(
          //                             top: 1.5, bottom: 1.5),
          //                         child: Text(
          //                           'TATA',
          //                           style: TextStyle(fontSize: 12),
          //                         ),
          //                       ),
          //                       Container(
          //                         height: 25,
          //                         decoration: BoxDecoration(
          //                             border: Border.all(
          //                               color: Colors.grey[500],
          //                             ),
          //                             borderRadius:
          //                                 BorderRadius.all(Radius.circular(2))),
          //                         child: Padding(
          //                           padding: const EdgeInsets.only(
          //                               left: 3.0, right: 3),
          //                           child: Center(
          //                             child: Text(
          //                               "ALQ1S16235",
          //                               style: TextStyle(
          //                                 fontSize: 12,
          //                                 fontWeight: FontWeight.w500,
          //                               ),
          //                             ),
          //                           ),
          //                         ),
          //                       ),
          //                     ],
          //                   )
          //                 ],
          //               ),
          //               Divider(
          //                 thickness: 1.3,
          //               ),
          //               SizedBox(
          //                 height: 9,
          //               ),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: <Widget>[
          //                   Text(
          //                     'Balakrishna Gupta',
          //                     style: TextStyle(
          //                         fontWeight: FontWeight.bold, fontSize: 15),
          //                   ),
          //                   Column(
          //                     children: <Widget>[
          //                       Text(
          //                         '+94139065654',
          //                         style: TextStyle(fontSize: 14),
          //                       ),
          //                       Text(
          //                         'info@runnerz.com',
          //                         style: TextStyle(
          //                             color: Constants.primary, fontSize: 14),
          //                       ),
          //                     ],
          //                   )
          //                 ],
          //               ),
          //               SizedBox(
          //                 height: 10,
          //               ),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: <Widget>[
          //                   Expanded(
          //                     child: new OutlineButton(
          //                       child: new Text(
          //                         "contact".toUpperCase(),
          //                         style: TextStyle(
          //                             fontSize: 16, color: Constants.primary),
          //                       ),
          //                       onPressed: () {},
          //                       shape: new RoundedRectangleBorder(
          //                         borderRadius: new BorderRadius.circular(1.0),
          //                       ),
          //                     ),
          //                   ),
          //                   Expanded(
          //                     child: new OutlineButton(
          //                       child: new Text(
          //                         "Cancel",
          //                         style: TextStyle(
          //                           fontSize: 16,
          //                         ),
          //                       ),
          //                       onPressed: () {},
          //                       highlightedBorderColor: Constants.primary,
          //                       shape: new RoundedRectangleBorder(
          //                         borderRadius: new BorderRadius.circular(1.0),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          //   Align(
          //     alignment: Alignment.bottomCenter,
          //     child: FractionalTranslation(
          //       translation: Offset(0, -1.5),
          //       child: ClipOval(
          //         child: Image.asset(
          //           'assets/profile.jpeg',
          //           height: 100,
          //           width: 100,
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ),
          //   ),
          // ]),
        ],
      ),
    );
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

class DriverInfoResponse {
  final List<DriverinfoCons>? data;
  final String status;

  DriverInfoResponse({ this.data,required this.status});

  factory DriverInfoResponse.fromJson(Map<dynamic, dynamic> json) {
    return DriverInfoResponse(
      data: json['drivers'] != null
          ? (json['drivers'] as List)
              .map((i) => DriverinfoCons.fromJson(i))
              .toList()
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['drivers'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
