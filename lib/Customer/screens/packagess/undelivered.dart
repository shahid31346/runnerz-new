import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Common/listCons/undeliveredCons.dart';
import 'package:runnerz/Common/listCons/undelivered_model.dart';
import 'package:runnerz/Customer/screens/packagess/add_package_one.dart';
import 'package:runnerz/Customer/widgets/undeliveredicon.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Undelivered extends StatefulWidget {
  @override
  UndeliveredState createState() => UndeliveredState();
}

class UndeliveredState extends State<Undelivered> {
  Future<Map> getJson() async {
    String _value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;

    // Constants.baseUrl + 'packages/undelivered_pacakges?user_id=' + _value;
    Uri apiUrl = Uri.parse(
        Constants.baseUrl + 'packages/get_all_orders?user_id=' + _value);
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

  Future<List<UndeliveredData>> getUndelivered() async {
    Map _data = await getJson();
    print(_data);

    UnDeliveredModel dataResponse = UnDeliveredModel.fromJson(_data);
    if (dataResponse.status == 'SUCCESS') return dataResponse.data;

    return [];
  }

  checkerFunction() async {
    bool _checker = false;
    String _body = "";
    Map _data = await getJson();
    _body = (_data['status']);
    if (_body == 'ERROR') {
      _checker = false;
    } else {
      _checker = true;
    }
    return _checker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0, left: 15.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'My Packages',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 50,
                        ),
                        IconButton(
                          icon: Icon(Icons.playlist_add),
                          //color: Colors.black,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return AddPackageOne();
                                },
                              ),
                            );
                          },
                          tooltip: "Add Packages",
                        ),
                      ]),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<UndeliveredData>>(
                future: getUndelivered(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      List<UndeliveredData> items = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: items == null ? 0 : items.length,
                        itemBuilder: (BuildContext context, int index) {
                          UndeliveredData cat = items[index];

                          return UndeliveredSingle(
                            packageId: cat.id,
                            profilePic: cat.driverImage,
                            driverName: cat.driverName,
                            vechilename: cat.vehicleName,
                            mobileNo: cat.phone,
                            email: cat.email,
                            pickUpLocation: cat.pickupAddress,
                            dropLocation: cat.dropAddress,
                            date: cat.pickTime,
                            time: cat.pickDate,
                            totalAmount: cat.farePrice,
                            couponapplied: 'false',
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No UnDelivered Packages found',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UndeliveredResponse {
  final List<UnDeliveredCons>? data;
  final String status;

  UndeliveredResponse({this.data, required this.status});

  factory UndeliveredResponse.fromJson(Map<dynamic, dynamic> json) {
    return UndeliveredResponse(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((i) => UnDeliveredCons.fromJson(i))
              .toList()
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
