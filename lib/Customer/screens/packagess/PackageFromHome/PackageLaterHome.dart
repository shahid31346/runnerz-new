import 'dart:convert';
import 'dart:math';

import 'package:fl_geocoder/fl_geocoder.dart';
import 'package:fl_geocoder/fl_geocoder.dart' as geo;
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart' as pred;
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../add_package_one.dart';

class PackageLaterHome extends StatefulWidget {
  @override
  _PackageLaterHomeState createState() => _PackageLaterHomeState();
}

class _PackageLaterHomeState extends State<PackageLaterHome>
    with AutomaticKeepAliveClientMixin<PackageLaterHome> {
  DateTime selectedDate = DateTime.now();
  TextEditingController controller = TextEditingController();
  TextEditingController pickUpcontroller = TextEditingController();
  bool datevisibler = false;
  // String _date = "Not set";
  String _time = "Not set";
  bool fareChecker = false;
  bool _isLoading = false;
  bool apiCalled = false;
  bool loading = false;
  String? _selectedPackageCategory;
  String? _selectedPackageType;

  List categories = [];
  List vehicleTypes = [];

  bool loader = true;
  double unitPrice = 0;
  bool loadingForTypes = false;
  bool vehicleTypeChecker = false;

  double? latitudeForPickup;
  double? longitudeForPickup;
  String addressForPickup = 'Enter PickUp Location';

  bool vehicleReleaser = false;

  double? latitudeForDrop;
  double? longitudeForDrop;
  String addressForDrop = 'Enter Drop Location';
  String totalRoundAmount = '';
  Position? currentLocation;
  var location = loc.Location();
  LatLng? center;
  bool pickupChecker = true;
  bool pickupCheckerCurrentLocation = true;
  bool oR = true;
  String? mainAdressPickup;
  String currentLocationForPickup = 'Use Current Location';
  String? vehicleTypeId;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        datevisibler = true;
      });
  }

  Future<Map> getJson() async {
    String _value = '';
    String vechiletype = '';
    String _identifier = '';

    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;
    _identifier = pref1.getString("identifier")!;

    Uri apiUrl = Uri.parse(Constants.baseUrl +
        'packages/add_package_process_threeFromFront?user_id=$_value');

//make it identifier
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };
    final msg = jsonEncode({
      "status": '6',
      "pick_date": "${selectedDate.toLocal()}".split(' ')[0],
      "pick_time": _time,
      "pickup_lat": latitudeForPickup,
      "pickup_lon": longitudeForPickup,
      "drop_lat": latitudeForDrop,
      "drop_lon": longitudeForDrop,
      "vehicle_type_id": vehicleTypeId,
      "fare_price": double.parse(totalRoundAmount),
      "pickup_address": mainAdressPickup,
      "drop_address": addressForDrop,
    });

    http.Response response = await http.post(
      apiUrl,
      headers: headers,
      body: msg,
    );

    return json.decode(response.body); // returns a List type
  }

  void _check() async {
    String _body = "";

    Map _data = await getJson();

    //print(_data);

    _body = (_data['status']);

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
              content: Text(_data['data']['msg']),
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
      SharedPreferences pref1 = await SharedPreferences.getInstance();
      pref1.setString("fare_id", _data['fare_id']);

      print("success");
      setState(() {
        _isLoading = false;
      });
      print('dooonee');

      // Toast.show('Succcessful', context);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return AddPackageOne(
              identifier: _data['identifier'],
              home: true,
              farePrice: totalRoundAmount,
              pickUpLocation: mainAdressPickup,
              dropLocation: addressForDrop,
              dropLat: latitudeForDrop,
              dropLng: longitudeForDrop,
              amount: totalRoundAmount,
              pickLat: latitudeForPickup,
              pickLng: longitudeForPickup,
            );
          },
        ),
      );
    }

    // print("khan $_data");
  }

  Future<Map> _getVehicle() async {
    Uri apiUrl = Uri.parse(Constants.baseUrl + 'packages/get_all_vehicle_type');
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

  void dropDownList() async {
    setState(() {
      apiCalled = true;
      loading = true;
    });
//    getJson();

    String _body = "";
    String values = "";

    try {
      // _isLoading = false;

      Map _data = await _getVehicle();

      categories = _data["vehicles"];

      print(_data);

      Map<String, dynamic> dataMap = _data["data"];
      dataMap.keys.forEach((k) {
        values = (dataMap[k].toString());
        print(dataMap[k]);
      });

      _body = (_data['status']);

      // print(_data);

      if (_body == 'ERROR') {
        setState(() {
          _isLoading = false;
          loading = false;
        });
        // print("$_data");
        showDialog(
            context: context,
            builder: (c) {
              return AlertDialog(
                title: Text("oops"),
                content: Text(values),
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
          print('dropdown Success');
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        loading = false;
      });
//       var title = e.toString();
//       if (e is SocketException) title = 'No internet';
//       showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//                 title: Text(title),
// //        content: Text(values),
//                 actions: <Widget>[
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text("Close"),
//                   )
//                 ],
//               ));
    }
  }

  Future<Map> _getVehicleTypes() async {
    Uri apiUrl =
        Uri.parse(Constants.baseUrl + 'packages/get_sub_vehciles_type');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };

    final msg = jsonEncode({
      "vehicle_id": _selectedPackageCategory,
    });

    print(msg);

    http.Response response = await http.post(
      apiUrl,
      body: msg,
      headers: headers,
    );

    return json.decode(response.body); // returns a List type
  }

  void vehicleTypesDropDown() async {
    setState(() {
      apiCalled = true;
    });
//    getJson();

    String _body = "";
    String values = "";

    try {
      // _isLoading = false;

      Map _data = await _getVehicleTypes();

      vehicleTypes = _data["vehicles"];

      print(_data);

      Map<String, dynamic> dataMap = _data["data"];
      dataMap.keys.forEach((k) {
        values = (dataMap[k].toString());
        print(dataMap[k]);
      });

      _body = (_data['status']);

      // print(_data);

      if (_body == 'ERROR') {
        setState(() {
          vehicleTypeChecker = false;

          loadingForTypes = false;
        });
        // print("$_data");
        showDialog(
            context: context,
            builder: (c) {
              return AlertDialog(
                title: Text("oops"),
                content: Text(values),
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
          print('dropdown Success');
          loadingForTypes = false;
        });
      }
    } catch (e) {
      setState(() {
        loadingForTypes = false;
      });
    }
  }

  callme() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      loader = false;
    });
  }

  @override
  void initState() {
    super.initState();
    callme();
  }

  // void _getLatLngforPickup(pred.Prediction prediction) async {
  //   GoogleMapsPlaces _places = new GoogleMapsPlaces(
  //       apiKey:
  //           'AIzaSyCqi_-GdzTVjwKqvjxmTLyry-EgUHegE1Y'); //Same API_KEY as above
  //   PlacesDetailsResponse detail =
  //       await _places.getDetailsByPlaceId(prediction.placeId!);
  //   setState(() {
  //     pickupCheckerCurrentLocation = false;
  //     oR = false;

  //     latitudeForPickup = detail.result.geometry!.location.lat;
  //     longitudeForPickup = detail.result.geometry!.location.lng;
  //     addressForPickup = prediction.description!;
  //     mainAdressPickup = prediction.description;
  //   });

  //   print(latitudeForPickup);
  //   print(longitudeForPickup);
  //   print(addressForPickup);
  //   locationChecker();

  //   if (_selectedPackageCategory!.isNotEmpty) {
  //     {
  //       calculateDistance(latitudeForPickup, longitudeForPickup,
  //           latitudeForDrop, longitudeForDrop);
  //     }
  //   }
  // }

  // void _getLatLngforDrop(pred.Prediction prediction) async {
  //   GoogleMapsPlaces _places = new GoogleMapsPlaces(
  //       apiKey:
  //           'AIzaSyCqi_-GdzTVjwKqvjxmTLyry-EgUHegE1Y'); //Same API_KEY as above
  //   PlacesDetailsResponse detail =
  //       await _places.getDetailsByPlaceId(prediction.placeId!);
  //   setState(() {
  //     latitudeForDrop = detail.result.geometry!.location.lat;
  //     longitudeForDrop = detail.result.geometry!.location.lng;
  //     addressForDrop = prediction.description!;
  //   });

  //   print(latitudeForDrop);
  //   print(longitudeForDrop);
  //   print(addressForDrop);
  //   locationChecker();
  //   locationCheckerForCurrentLocation();

  //   if (_selectedPackageCategory!.isNotEmpty) {
  //     {
  //       calculateDistance(latitudeForPickup, longitudeForPickup,
  //           latitudeForDrop, longitudeForDrop);
  //     }
  //   }
  // }

  locationChecker() {
    if (addressForPickup != 'Enter PickUp Location' &&
        addressForDrop != 'Enter Drop Location') {
      setState(() {
        vehicleReleaser = true;
      });
    }
  }

  locationCheckerForCurrentLocation() {
    if (addressForDrop != 'Enter Drop Location' && pickupChecker == false) {
      setState(() {
        vehicleReleaser = true;
      });
    }
  }

  String calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double distanceInKm = 12742 * asin(sqrt(a));
    //print(distanceInKm);

//change unit price
    double totalAmount = unitPrice * distanceInKm;

    print(totalAmount.toStringAsFixed(2));
    setState(() {
      totalRoundAmount = totalAmount.toStringAsFixed(2);
    });
    return totalRoundAmount;
  }

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
      pickupChecker = false;
      oR = false;

      latitudeForPickup = currentLocation!.latitude;
      longitudeForPickup = currentLocation!.longitude;
    });

    ///new code
    final geocoder = FlGeocoder(Constants.api_key);

    final coordinates = geo.Location(latitudeForPickup!, longitudeForPickup!);
    final results = await geocoder.findAddressesFromLocationCoordinates(
      location: coordinates,
      useDefaultResultTypeFilter: false,
      // resultType: 'route', // Optional. For custom filtering.
    );

    // final coordinates = Coordinates(latitudeForPickup, longitudeForPickup);
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = results[0];
    print(first.formattedAddress);
    // print("${first.featureName} : ${first.addressLine}");
    setState(() {
      currentLocationForPickup = first.formattedAddress ?? '';
      mainAdressPickup = first.formattedAddress ?? '';
    });

    locationCheckerForCurrentLocation();
    if (_selectedPackageCategory!.isNotEmpty) {
      {
        calculateDistance(latitudeForPickup, longitudeForPickup,
            latitudeForDrop, longitudeForDrop);
      }
    }
  }

  Future _checkGps() async {
    if (!await location.serviceEnabled()) {
      print('${location.requestService()}' + 'khannnnn');
    }
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.8;
    if (!apiCalled) {
      Future.delayed(Duration(milliseconds: 2), () {
        dropDownList();
      });
    }
    return Scaffold(
      body: loader
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 13.0, right: 15.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          _selectDate(context);
                          print(selectedDate);

                          print("${selectedDate.toLocal()}".split(' ')[0]);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          size: 18.0,
                                          color: Colors.teal,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            "${selectedDate.toLocal()}"
                                                .split(' ')[0],
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                "Pickup Date",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                              // theme: DatePickerTheme(
                              //   containerHeight: 210.0,
                              // ),
                              showTitleActions: true, onConfirm: (time) {
                            setState(() {
                              print('confirm $time');
                              _time =
                                  '${time.hour} : ${time.minute} : ${time.second}';
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.access_time,
                                          size: 18.0,
                                          color: Colors.teal,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            " $_time",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                "Pickup Time",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, left: 20.0),
                      child: Text(
                        'Pickup Location'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    //pickupLocation(),
                    // pickupChecker
                    //     ? Padding(
                    //         padding: const EdgeInsets.only(
                    //             left: 12.0, right: 12.0, top: 2.0),
                    //         child: InkWell(
                    //           onTap: () async {
                    //             // show input autocomplete with selected mode
                    //             // then get the Prediction selected
                    //             pred.Prediction prediction =
                    //                 await PlacesAutocomplete.show(
                    //               context: context,
                    //               apiKey:
                    //                   'AIzaSyCqi_-GdzTVjwKqvjxmTLyry-EgUHegE1Y',
                    //               mode: Mode.overlay, // Mode.overlay
                    //               language: "en",
                    //               // components: [Component(Component.country, "ae")]
                    //             );

                    //             //ae for emirates and sa for saudi
                    //             //displayPrediction(p);
                    //             _getLatLngforPickup(prediction);
                    //           },
                    //           child: Card(
                    //             elevation: 3.0,
                    //             child: Container(
                    //               width: double.infinity,
                    //               height: 50,
                    //               decoration: BoxDecoration(
                    //                 color: Colors.white,
                    //                 borderRadius: BorderRadius.all(
                    //                   Radius.circular(5.0),
                    //                 ),
                    //               ),
                    //               child: Center(
                    //                 child: Column(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     Center(
                    //                       child: Padding(
                    //                         padding: const EdgeInsets.only(
                    //                             left: 8.0),
                    //                         child: Text(
                    //                           '$addressForPickup',
                    //                           overflow: TextOverflow.ellipsis,
                    //                           style: TextStyle(
                    //                               color: Colors.grey,
                    //                               fontWeight: FontWeight.bold),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : Container(),
                    oR
                        ? Center(
                            child: Text('OR'),
                          )
                        : Container(),
                    pickupCheckerCurrentLocation
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 2.0),
                            child: InkWell(
                              onTap: () async {
                                _checkGps();
                                getUserLocation();
                              },
                              child: Card(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              '$currentLocationForPickup',
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
                            ),
                          )
                        : Container(),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, left: 20.0),
                      child: Text(
                        'Destination'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  //  placesAutoCompleteTextField(),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: 12.0, right: 12.0, top: 2.0),
                    //   child: InkWell(
                    //     onTap: () async {
                    //       // show input autocomplete with selected mode
                    //       // then get the Prediction selected
                    //       Prediction prediction = await PlacesAutocomplete.show(
                    //           context: context,
                    //           apiKey: 'AIzaSyCqi_-GdzTVjwKqvjxmTLyry-EgUHegE1Y',
                    //           mode: Mode.overlay, // Mode.overlay
                    //           language: "en",
                    //           components: [Component(Component.country, "pk")]);
                    //       //displayPrediction(p);
                    //       _getLatLngforDrop(prediction);
                    //     },
                    //     child: Card(
                    //       elevation: 3.0,
                    //       child: Container(
                    //         width: double.infinity,
                    //         height: 50,
                    //         decoration: BoxDecoration(
                    //           color: Colors.white,
                    //           borderRadius: BorderRadius.all(
                    //             Radius.circular(5.0),
                    //           ),
                    //         ),
                    //         child: Center(
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Center(
                    //                 child: Padding(
                    //                   padding: const EdgeInsets.only(left: 8.0),
                    //                   child: Text(
                    //                     '$addressForDrop',
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: Colors.grey,
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 0.3,
                    ),
                    Divider(),
                    SizedBox(
                      height: 0.3,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                      ),
                    ),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 3.0, left: 20.0),
                                child: Text(
                                  'Vehicle category'.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0,
                                    right: 20.0,
                                    top: 2.0,
                                    bottom: 2),
                                child: Card(
                                  elevation: 3.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20, bottom: 8),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          isExpanded: true,
                                          hint: Text('Select vehicle category'),
                                          style: TextStyle(
                                              color: Colors
                                                  .blue), // Not necessary for Option 1
                                          value: _selectedPackageCategory,
                                          onChanged: vehicleReleaser
                                              ? (String? newValue) {
                                                  setState(() {
                                                    // vehicleTypeChecker = true;
                                                    // loadingForTypes = true;
                                                    totalRoundAmount = '0.00';
                                                    _selectedPackageType = null;
                                                    vehicleTypeChecker = true;
                                                    loadingForTypes = true;
                                                    vehicleTypes = [];
                                                    _selectedPackageCategory =
                                                        newValue;
                                                    vehicleTypesDropDown();

//
                                                  });
                                                }
                                              : null,

                                          items: categories.map((location) {
                                            return new DropdownMenuItem(
                                              // child: new Text(location['vehicle_type']),

                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.blue,
                                                  child: Text(
                                                    location['id'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                title: Text(
                                                    location['vehicle_type']),
                                              ),
                                              value: location['id'].toString(),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    vehicleTypeChecker
                        ? loadingForTypes
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3.0, left: 20.0),
                                    child: Text(
                                      'Vehicle type'.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        top: 2.0,
                                        bottom: 2),
                                    child: Card(
                                      elevation: 3.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20, bottom: 8),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              hint: Text('Select vehicle type'),
                                              style: TextStyle(
                                                  color: Colors
                                                      .blue), // Not necessary for Option 1
                                              value: _selectedPackageType,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  fareChecker = true;

                                                  _selectedPackageType =
                                                      newValue;

                                                  calculateDistance(
                                                      latitudeForPickup,
                                                      longitudeForPickup,
                                                      latitudeForDrop,
                                                      longitudeForDrop);
                                                  // if (
                                                  //     addressForDrop !=
                                                  //         'Enter Drop Location') {
                                                  // }

                                                  print(_selectedPackageType);
                                                });
                                              },
                                              items:
                                                  vehicleTypes.map((location) {
                                                return new DropdownMenuItem(
                                                  // child: new Text(location['vehicle_type']),
                                                  onTap: () {
                                                    unitPrice = double.parse(
                                                        location['price']);

                                                    vehicleTypeId =
                                                        location['vehicle_id']
                                                            .toString();

                                                    _selectedPackageType =
                                                        location['id']
                                                            .toString();
                                                  },
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.blue,
                                                      child: Text(
                                                        location['id']
                                                            .toString(),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                    title: Text(location[
                                                        'vehicle_name']),
                                                  ),

                                                  //id should be in sequence
                                                  value:
                                                      location['id'].toString(),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                        : Container(),
                    SizedBox(
                      height: 0.5,
                    ),
                    Divider(
                      thickness: 0.5,
                      color: Colors.black54,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, top: 0.0),
                      child: Card(
                        elevation: 3.0,
                        child: Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'Fare Estimate'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black87),
                                      ),
                                      fareChecker
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0),
                                              child: Text(
                                                '${Constants.currency} $totalRoundAmount',
                                                style: TextStyle(
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff1fa2f2),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30.0),
                                              child: Text(
                                                'Enter Pickup and Destination Above',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black54),
                                              ),
                                            ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Estimate to be provided prior to pickup',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Text(
                        'Please Note '.toUpperCase(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 18.0, right: 18.0, top: 5.0),
                        child: Text(
                          'Fare may vary due to traffic, weather & other factors, Omar does not guarantee a driver will accept your ride request.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ],
            ),
      bottomNavigationBar: Container(
        height: 50.0,
        child: ElevatedButton(
          child: Text(
            'schedule ${Constants.appname}'.toUpperCase(),
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            if (_time == "Not set") {
              Toast.show(
                'please select time',
              );
            } else if (addressForPickup == 'Enter PickUp Location' &&
                currentLocationForPickup == 'Use Current Location') {
              Toast.show(
                'please Enter PickUp Location',
              );
            } else if (addressForDrop == 'Enter Drop Location') {
              Toast.show(
                'please Enter Drop Location',
              );
            } else

            //  if (_selectedPackageType == null) {
            //   Toast.show('please Select a vehicle', context);
            // } else

            {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20.0)), //this right here
                      child: Container(
                        height: 320,
                        width: c_width,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Fare estimate :  ${Constants.currency} $totalRoundAmount',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              // TextButton(
                              //   onPressed: () {},
                              //   child: Text(
                              //     'Apply coupon',
                              //     style: TextStyle(
                              //         color: Constants.primary, fontSize: 16),
                              //   ),
                              // ),
                              Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'Runnerz for  ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "${selectedDate.toLocal()}".split(' ')[0],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 11.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '$_time',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4.0, top: 5),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 3.0),
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
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            '$mainAdressPickup',
                                            maxLines: 2,
                                            textAlign: TextAlign.justify,
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
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 4.0, top: 10),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 3.0),
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
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            '$addressForDrop',
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.justify,
                                            maxLines: 2,
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
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Surge may apply'),
                                  ],
                                ),
                              ),
                              _isLoading
                                  ? Center(child: CircularProgressIndicator())
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'.toUpperCase()),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            _check();
                                          },
                                          child: Text(
                                            'Add package Details'.toUpperCase(),
                                            style: TextStyle(
                                                color: Constants.primary),
                                          ),
                                        ),
                                      ],
                                    )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }

  // pickupLocation() {
  //   return Card(
  //     elevation: 3.0,
  //     child: Container(
  //       width: double.infinity,
  //       height: 50,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(5.0),
  //         ),
  //       ),
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Center(
  //               child: Padding(
  //                 padding: const EdgeInsets.only(left: 8.0),
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(horizontal: 20),
  //                   child: GooglePlaceAutoCompleteTextField(
  //                     textEditingController: pickUpcontroller,
  //                     googleAPIKey: Constants.api_key,
  //                     inputDecoration: InputDecoration(
  //                       hintText: "Enter Pickup Location",
  //                       border: InputBorder.none,
  //                       enabledBorder: InputBorder.none,
  //                     ),
  //                     debounceTime: 400,
  //                     //countries: ["in", "fr"],
  //                     isLatLngRequired: false,
  //                     getPlaceDetailWithLatLng: (pred.Prediction prediction) {
  //                       print("placeDetails" + prediction.lat.toString());
  //                     },

  //                     itemClick: (pred.Prediction prediction) {
  //                       controller.text = prediction.description ?? "";
  //                       controller.selection = TextSelection.fromPosition(
  //                           TextPosition(
  //                               offset: prediction.description?.length ?? 0));

  //                       _getLatLngforDrop(prediction);
  //                     },
  //                     seperatedBuilder: Divider(),
  //                     // OPTIONAL// If you want to customize list view item builder
  //                     itemBuilder:
  //                         (context, index, pred.Prediction prediction) {
  //                       return Container(
  //                         padding: EdgeInsets.all(10),
  //                         child: Row(
  //                           children: [
  //                             Icon(Icons.location_on),
  //                             SizedBox(
  //                               width: 7,
  //                             ),
  //                             Expanded(
  //                                 child:
  //                                     Text("${prediction.description ?? ""}"))
  //                           ],
  //                         ),
  //                       );
  //                     },

  //                     isCrossBtnShown: true,

  //                     // default 600 ms ,
  //                   ),
  //                 ),

  //                 //  Text(
  //                 //   '$addressForDrop',
  //                 //   overflow: TextOverflow.ellipsis,
  //                 //   style: TextStyle(
  //                 //       color: Colors.grey,
  //                 //       fontWeight: FontWeight.bold),
  //                 // ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // placesAutoCompleteTextField() {
  //   return Card(
  //     elevation: 3.0,
  //     child: Container(
  //       width: double.infinity,
  //       height: 50,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(5.0),
  //         ),
  //       ),
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Center(
  //               child: Padding(
  //                 padding: const EdgeInsets.only(left: 8.0),
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(horizontal: 20),
  //                   child: GooglePlaceAutoCompleteTextField(
  //                     textEditingController: controller,
  //                     googleAPIKey: Constants.api_key,
  //                     inputDecoration: InputDecoration(
  //                       hintText: "Enter Drop Location",
  //                       border: InputBorder.none,
  //                       enabledBorder: InputBorder.none,
  //                     ),
  //                     debounceTime: 400,
  //                     //countries: ["in", "fr"],
  //                     isLatLngRequired: false,
  //                     getPlaceDetailWithLatLng: (pred.Prediction prediction) {
  //                       print("placeDetails" + prediction.lat.toString());
  //                     },

  //                     itemClick: (pred.Prediction prediction) {
  //                       controller.text = prediction.description ?? "";
  //                       controller.selection = TextSelection.fromPosition(
  //                           TextPosition(
  //                               offset: prediction.description?.length ?? 0));

  //                       _getLatLngforDrop(prediction);
  //                     },
  //                     seperatedBuilder: Divider(),
  //                     // OPTIONAL// If you want to customize list view item builder
  //                     itemBuilder:
  //                         (context, index, pred.Prediction prediction) {
  //                       return Container(
  //                         padding: EdgeInsets.all(10),
  //                         child: Row(
  //                           children: [
  //                             Icon(Icons.location_on),
  //                             SizedBox(
  //                               width: 7,
  //                             ),
  //                             Expanded(
  //                                 child:
  //                                     Text("${prediction.description ?? ""}"))
  //                           ],
  //                         ),
  //                       );
  //                     },

  //                     isCrossBtnShown: true,

  //                     // default 600 ms ,
  //                   ),
  //                 ),

  //                 //  Text(
  //                 //   '$addressForDrop',
  //                 //   overflow: TextOverflow.ellipsis,
  //                 //   style: TextStyle(
  //                 //       color: Colors.grey,
  //                 //       fontWeight: FontWeight.bold),
  //                 // ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  bool get wantKeepAlive => true;
}
