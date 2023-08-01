import 'dart:async';

import 'package:fl_geocoder/fl_geocoder.dart' as geo;
import 'package:fl_geocoder/fl_geocoder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart' as pred;
import 'package:location/location.dart' as loc;
import 'package:runnerz/Customer/screens/packagess/add_package_one.dart';
import 'package:runnerz/Customer/widgets/drawer.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:toast/toast.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController pickUpcontroller = TextEditingController();
//pickup
  double? latitudeForPickup;
  double? longitudeForPickup;
  String addressForPickup = 'PickUp Location';
  String? mainAdressPickup;
  final geocoder = FlGeocoder(Constants.api_key);

  LatLng? _center;

  bool currentLocLoader = false;

//drop
  double? latitudeForDrop;
  double? longitudeForDrop;
  String addressForDrop = 'Drop Location';
  var location = loc.Location();
  String? searchAddr;
  GoogleMapController? mapController;
  final Map<String, Marker> _markers = {};
  String totalRoundAmount = '';
  double unitPrice = 0;
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
      latitudeForPickup = currentLocation!.latitude;
      longitudeForPickup = currentLocation!.longitude;
    });
    _center = LatLng(currentLocation!.latitude, currentLocation!.longitude);

    final coordinates = geo.Location(latitudeForPickup!, longitudeForPickup!);
    final addresses = await geocoder.findAddressesFromLocationCoordinates(
      location: coordinates,
      //  useDefaultResultTypeFilter: isFiltered,
      // resultType: 'route', // Optional. For custom filtering.
    );
    // final coordinates = new Coordinates(latitudeForPickup, longitudeForPickup);
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses[0];

    setState(() {
      addressForPickup = first.formattedAddress ?? '';
      mainAdressPickup = first.formattedAddress ?? '';
      currentLocLoader = false;
    });

    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _center!, zoom: 16.0),
      ),
    );
  }

  Future _checkGps() async {
    if (!await location.serviceEnabled()) {
      print('${location.requestService()}' + 'test');
    }
  }

  // void _getLocation() async {
  //   var currentLocation = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

  //   setState(() {

  //   });
  // }

  void _getLatLngforPickup(pred.Prediction prediction) async {
    GoogleMapsPlaces _places = new GoogleMapsPlaces(
        apiKey:
            'AIzaSyCqi_-GdzTVjwKqvjxmTLyry-EgUHegE1Y'); //Same API_KEY as above
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId!);
    setState(() {
      latitudeForPickup = detail.result.geometry!.location.lat;
      longitudeForPickup = detail.result.geometry!.location.lng;
      addressForPickup = prediction.description!;
      mainAdressPickup = prediction.description;
    });
  }

  void _getLatLngforDrop(pred.Prediction prediction) async {
    GoogleMapsPlaces _places = new GoogleMapsPlaces(
        apiKey:
            'AIzaSyCqi_-GdzTVjwKqvjxmTLyry-EgUHegE1Y'); //Same API_KEY as above
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId!);
    setState(() {
      latitudeForDrop = detail.result.geometry!.location.lat;
      longitudeForDrop = detail.result.geometry!.location.lng;
      addressForDrop = prediction.description!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserLocation();
    _checkGps();
    getUserLocation();
    //_getLocation();
  }

  messageAllertExit(String msg, String ttl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(ttl),
            ),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Column(
                  children: <Widget>[
                    Text('yes'),
                  ],
                ),
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ),
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Column(
                  children: <Widget>[
                    Text('No'),
                  ],
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          );
        });
  }

  Future<bool> _onBackPressed() {
    return messageAllertExit(
        'You are going to exit the application!!', 'Are you sure?');
  }

  @override
  Widget build(BuildContext context) {
    // Marker currentLocationMarker = Marker(
    //   markerId: MarkerId('gramercy'),
    //   position: center,
    //   infoWindow: InfoWindow(title: 'Gramercy Tavern'),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(
    //     BitmapDescriptor.hueViolet,
    //   ),
    // );
    return Scaffold(
        drawer: AppDrawer(),
        appBar: BaseAppBar(
          appBar: AppBar(),
        ),
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: onMapCreated,
                compassEnabled: true,
                mapToolbarEnabled: true,
                zoomControlsEnabled: false,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                trafficEnabled: true,
                mapType: MapType.terrain,
                initialCameraPosition: CameraPosition(
                  target: LatLng(40.7128, -74.0060),
                  zoom: 5.0,
                ),
                //markers: _markers.values.toSet(),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      side: BorderSide(width: 5, color: Colors.white)),
                  child: Container(
                    height: 210.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        left: 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 42.0, top: 6),
                            child: Text(
                              'Want to Ship your goods?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                          //  SizedBox(height: 3),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 8.0),
                            child: Row(
                              children: [
                                // Expanded(
                                //   child: InkWell(
                                //     onTap: () async {
                                //       // show input autocomplete with selected mode
                                //       // then get the Prediction selected
                                //       // Prediction prediction = await PlacesAutocomplete.show(
                                //       //     context: context,
                                //       //     apiKey: 'AIzaSyCqi_-GdzTVjwKqvjxmTLyry-EgUHegE1Y',
                                //       //     mode: Mode.overlay, // Mode.overlay
                                //       //     language: "en",
                                //       //     radius: 10000000,
                                //       //     strictbounds: false,
                                //       //     components: [Component(Component.country, "pk")]);

                                //       Prediction prediction =
                                //           await PlacesAutocomplete.show(
                                //         context: context,
                                //         apiKey:
                                //             'AIzaSyCqi_-GdzTVjwKqvjxmTLyry-EgUHegE1Y',
                                //         radius: 10000000,
                                //         types: [],
                                //         strictbounds: false,
                                //         mode: Mode.overlay,
                                //         language: "en",
                                //         decoration: InputDecoration(
                                //           hintText: 'Search',
                                //           focusedBorder: OutlineInputBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(20),
                                //             borderSide: BorderSide(
                                //               color: Colors.white,
                                //             ),
                                //           ),
                                //         ),
                                //         components: [
                                //           //  Component(Component.country, "fr"),
                                //         ],
                                //       );
                                //       //displayPrediction(p);
                                //       _getLatLngforPickup(prediction);
                                //     },
                                //     child: Card(
                                //       elevation: 10,
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.all(
                                //             Radius.circular(20),
                                //           ),
                                //           side: BorderSide(
                                //               width: 5, color: Colors.white)),
                                //       child: Container(
                                //         height: 60.0,
                                //         // width: double.infinity,
                                //         decoration: BoxDecoration(
                                //           borderRadius:
                                //               BorderRadius.circular(10.0),
                                //           color: Colors.white,
                                //         ),
                                //         child: Padding(
                                //           padding:
                                //               const EdgeInsets.only(left: 30.0),
                                //           child: Row(
                                //             children: [
                                //               Icon(Icons.blur_linear_outlined),
                                //               SizedBox(width: 25),
                                //               Flexible(
                                //                 child: Text('$addressForPickup',
                                //                     overflow: TextOverflow.fade,
                                //                     style: TextStyle(
                                //                         color: Colors.black54)),
                                //               )
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                pickupLocation(),
                                currentLocLoader
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator()),
                                        ),
                                      )
                                    : IconButton(
                                        icon: Icon(Icons.my_location),
                                        onPressed: () {
                                          setState(() {
                                            currentLocLoader = true;
                                          });
                                          _checkGps();
                                          getUserLocation();
                                        }),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 2.0),
                            child: Row(
                              children: [
                                placesAutoCompleteTextField(),
                                // Expanded(
                                //   child: InkWell(
                                //     onTap: () async {
                                //       // show input autocomplete with selected mode
                                //       // then get the Prediction selected
                                //       // Prediction prediction = await PlacesAutocomplete.show(
                                //       //     context: context,
                                //       //     apiKey: 'AIzaSyCqi_-GdzTVjwKqvjxmTLyry-EgUHegE1Y',
                                //       //     mode: Mode.overlay, // Mode.overlay
                                //       //     language: "en",
                                //       //     radius: 10000000,
                                //       //     strictbounds: false,
                                //       //     components: [Component(Component.country, "pk")]);

                                //       Prediction prediction =
                                //           await PlacesAutocomplete.show(
                                //         context: context,
                                //         apiKey:
                                //             'AIzaSyCqi_-GdzTVjwKqvjxmTLyry-EgUHegE1Y',
                                //         radius: 10000000,
                                //         types: [],
                                //         strictbounds: false,
                                //         mode: Mode.overlay,
                                //         language: "en",
                                //         decoration: InputDecoration(
                                //           hintText: 'Search',
                                //           focusedBorder: OutlineInputBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(20),
                                //             borderSide: BorderSide(
                                //               color: Colors.white,
                                //             ),
                                //           ),
                                //         ),
                                //         components: [
                                //           //  Component(Component.country, "fr"),
                                //         ],
                                //       );
                                //       //displayPrediction(p);
                                //       _getLatLngforDrop(prediction);
                                //     },
                                //     child: Card(
                                //       elevation: 10,
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.all(
                                //             Radius.circular(20),
                                //           ),
                                //           side: BorderSide(
                                //               width: 5, color: Colors.white)),
                                //       child: Container(
                                //         height: 60.0,
                                //         width: double.infinity,
                                //         decoration: BoxDecoration(
                                //           borderRadius:
                                //               BorderRadius.circular(10.0),
                                //           color: Colors.white,
                                //         ),
                                //         child: Padding(
                                //           padding:
                                //               const EdgeInsets.only(left: 30.0),
                                //           child: Row(
                                //             children: [
                                //               Icon(Icons.pin_drop),
                                //               SizedBox(width: 25),
                                //               Flexible(
                                //                 child: Text('$addressForDrop',
                                //                     overflow: TextOverflow.fade,
                                //                     style: TextStyle(
                                //                         color: Colors.black54)),
                                //               )
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                IconButton(
                                    splashColor: Colors.blue,
                                    icon: Icon(
                                      Icons.check,
                                      size: 35,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      if (addressForPickup ==
                                          'PickUp Location') {
                                        print('1243');

                                        Toast.show(
                                          'Enter Pickup Location',
                                        );
                                      } else if (addressForDrop ==
                                          'Drop Location') {
                                        print('123');
                                        Toast.show(
                                          'Enter Drop Location',
                                        );
                                      } else {
                                        Constants.mainAdressPickup =
                                            addressForPickup;
                                        Constants.addressForDrop =
                                            mainAdressPickup;
                                        Constants.latitudeForPickup =
                                            latitudeForPickup;
                                        Constants.longitudeForPickup =
                                            longitudeForPickup;
                                        Constants.latitudeForDrop =
                                            latitudeForDrop;
                                        Constants.longitudeForDrop =
                                            longitudeForDrop;

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) {
                                              return AddPackageOne();
                                            },
                                          ),
                                        );
                                      }
                                    }),
                                // RawMaterialButton(
                                //   onPressed: () {},
                                //   elevation: 2.0,
                                //   //  fillColor: Colors.white,

                                //   child: Icon(
                                //     Icons.check,
                                //     size: 15.0,
                                //   ),

                                //   padding: EdgeInsets.all(15.0),
                                //   shape: CircleBorder(),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  pickupLocation() {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: pickUpcontroller,
      googleAPIKey: Constants.api_key,
      inputDecoration: InputDecoration(
        hintText: "Enter Pickup Location",
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      debounceTime: 400,
      //countries: ["in", "fr"],
      isLatLngRequired: false,
      getPlaceDetailWithLatLng: (pred.Prediction prediction) {
        print("placeDetails" + prediction.lat.toString());
      },

      itemClick: (pred.Prediction prediction) {
        controller.text = prediction.description ?? "";
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0));

        _getLatLngforDrop(prediction);
      },
      seperatedBuilder: Divider(),
      // OPTIONAL// If you want to customize list view item builder
      itemBuilder: (context, index, pred.Prediction prediction) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(
                width: 7,
              ),
              Expanded(child: Text("${prediction.description ?? ""}"))
            ],
          ),
        );
      },

      isCrossBtnShown: true,

      // default 600 ms ,
    );

    // Card(
    //   elevation: 3.0,
    //   child: Container(
    //     // width: double.infinity,
    //      height: 50,
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
    //           Center(
    //             child: Padding(
    //               padding: const EdgeInsets.only(left: 8.0),
    //               child: Container(
    //                 padding: EdgeInsets.symmetric(horizontal: 20),
    //                 child: GooglePlaceAutoCompleteTextField(
    //                   textEditingController: pickUpcontroller,
    //                   googleAPIKey: Constants.api_key,
    //                   inputDecoration: InputDecoration(
    //                     hintText: "Enter Pickup Location",
    //                     border: InputBorder.none,
    //                     enabledBorder: InputBorder.none,
    //                   ),
    //                   debounceTime: 400,
    //                   //countries: ["in", "fr"],
    //                   isLatLngRequired: false,
    //                   getPlaceDetailWithLatLng: (pred.Prediction prediction) {
    //                     print("placeDetails" + prediction.lat.toString());
    //                   },

    //                   itemClick: (pred.Prediction prediction) {
    //                     controller.text = prediction.description ?? "";
    //                     controller.selection = TextSelection.fromPosition(
    //                         TextPosition(
    //                             offset: prediction.description?.length ?? 0));

    //                     _getLatLngforDrop(prediction);
    //                   },
    //                   seperatedBuilder: Divider(),
    //                   // OPTIONAL// If you want to customize list view item builder
    //                   itemBuilder:
    //                       (context, index, pred.Prediction prediction) {
    //                     return Container(
    //                       padding: EdgeInsets.all(10),
    //                       child: Row(
    //                         children: [
    //                           Icon(Icons.location_on),
    //                           SizedBox(
    //                             width: 7,
    //                           ),
    //                           Expanded(
    //                               child:
    //                                   Text("${prediction.description ?? ""}"))
    //                         ],
    //                       ),
    //                     );
    //                   },

    //                   isCrossBtnShown: true,

    //                   // default 600 ms ,
    //                 ),
    //               ),

    //               //  Text(
    //               //   '$addressForDrop',
    //               //   overflow: TextOverflow.ellipsis,
    //               //   style: TextStyle(
    //               //       color: Colors.grey,
    //               //       fontWeight: FontWeight.bold),
    //               // ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  placesAutoCompleteTextField() {
    return Card(
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GooglePlaceAutoCompleteTextField(
                      textEditingController: controller,
                      googleAPIKey: Constants.api_key,
                      inputDecoration: InputDecoration(
                        hintText: "Enter Drop Location",
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      debounceTime: 400,
                      //countries: ["in", "fr"],
                      isLatLngRequired: false,
                      getPlaceDetailWithLatLng: (pred.Prediction prediction) {
                        print("placeDetails" + prediction.lat.toString());
                      },

                      itemClick: (pred.Prediction prediction) {
                        controller.text = prediction.description ?? "";
                        controller.selection = TextSelection.fromPosition(
                            TextPosition(
                                offset: prediction.description?.length ?? 0));

                        _getLatLngforDrop(prediction);
                      },
                      seperatedBuilder: Divider(),
                      // OPTIONAL// If you want to customize list view item builder
                      itemBuilder:
                          (context, index, pred.Prediction prediction) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                  child:
                                      Text("${prediction.description ?? ""}"))
                            ],
                          ),
                        );
                      },

                      isCrossBtnShown: true,

                      // default 600 ms ,
                    ),
                  ),

                  //  Text(
                  //   '$addressForDrop',
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(
                  //       color: Colors.grey,
                  //       fontWeight: FontWeight.bold),
                  // ),
                ),
              ),
            ],
          ),
        ),
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
