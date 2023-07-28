import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_controller/google_maps_controller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loc;
import 'package:runnerz/Customer/screens/coupon_on_map.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackageNowFromHome extends StatefulWidget {
  @override
  _PackageNowState createState() => _PackageNowState();
}

class _PackageNowState extends State<PackageNowFromHome>
    with AutomaticKeepAliveClientMixin<PackageNowFromHome> {
  DateTime selectedDate = DateTime.now();

  bool datevisibler = false;
  // String _date = "Not set";
  String _time = "Not set";
  bool fareChecker = false;
  bool _isLoading = false;
  bool apiCalled = false;
  bool loading = false;
  String? _selectedPackageCategory;
  String? _selectedPackageType;

  double unitPrice = 0;
  List categories = [];
  List vehicleTypes = [];

  bool loader = true;
  String? mainAdressPickup;
  bool loadingForTypes = false;
  bool vehicleTypeChecker = false;

  String totalRoundAmount = '';
  Position? currentLocation;
  var location = loc.Location();
  LatLng? center;
  bool pickupChecker = true;
  bool pickupCheckerCurrentLocation = true;
  bool oR = true;
  String? vehicleTypeId;

  String? formattedDate;

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
      "status": '11',
      "pick_date": "${selectedDate.toLocal()}".split(' ')[0],
      "pick_time": formattedDate,
      "pickup_lat": Constants.latitudeForPickup,
      "pickup_lon": Constants.longitudeForPickup,
      "drop_lat": Constants.latitudeForDrop,
      "drop_lon": Constants.longitudeForDrop,
      "vehicle_type_id": vehicleTypeId,
      "fare_price": double.parse(totalRoundAmount),
      "pickup_address": Constants.mainAdressPickup,
      "drop_address": Constants.addressForDrop,
    });

    print(msg);

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

      // Toast.show('Succcessful', context);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return CouponMap(
              farePrice: double.parse(totalRoundAmount).toString(),
              pickUpLocation: Constants.mainAdressPickup!,
              dropLocation: Constants.addressForDrop!,
              dropLat: Constants.latitudeForDrop!,
              dropLng: Constants.longitudeForDrop!,
              amount: double.parse(totalRoundAmount).toString(),
              pickLat: Constants.latitudeForPickup!,
              pickLng: Constants.longitudeForPickup!,
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

  Future _checkGps() async {
    if (!await location.serviceEnabled()) {
      print('${location.requestService()}' + 'khannnnn');
    }
  }

  @override
  Widget build(BuildContext context) {
    formattedDate = DateFormat('kk:mm:ss').format(selectedDate);
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 4.0),
                        onPressed: () {
                          // _selectDate(context);
                          // print("${selectedDate.toLocal()}".split(' ')[0]);
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              
                            ),
                            elevation: 4.0),
                        onPressed: () {
                          // DatePicker.showTimePicker(context,
                          //     theme: DatePickerTheme(
                          //       containerHeight: 210.0,
                          //     ),
                          //     showTitleActions: true, onConfirm: (time) {
                          //   print('confirm $time');
                          //   _time =
                          //       '${time.hour} : ${time.minute} : ${time.second}';
                          //   setState(() {});
                          // },
                          //     currentTime: DateTime.now(),
                          //     locale: LocaleType.en);
                          // setState(() {});
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
                                            " $formattedDate",
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
                                          onChanged: (newValue) {
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
                                          },

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
                                                      Constants
                                                          .latitudeForPickup,
                                                      Constants
                                                          .longitudeForPickup,
                                                      Constants.latitudeForDrop,
                                                      Constants
                                                          .longitudeForDrop);
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
            'Next'.toUpperCase(),
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            _check();
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
