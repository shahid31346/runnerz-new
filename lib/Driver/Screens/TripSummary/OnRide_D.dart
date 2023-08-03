import 'package:flutter/material.dart';
import 'package:runnerz/Common/dummylist/undelivereddummy.dart';
import 'package:runnerz/Common/listCons/Onride_DCons.dart';
import 'package:runnerz/Driver/Widgets/OnRide_single_D.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnRideTripD extends StatefulWidget {
  @override
  OnRideTripDState createState() => OnRideTripDState();
}

class OnRideTripDState extends State<OnRideTripD> {
  Future<Map> _getJson() async {
    String _value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;
    Uri apiUrl = Uri.parse(Constants.baseUrl +
        'summary/driver_trips?driver_id=' +
        _value +
        '&status=9');

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

  Future<List<OnRideForDriverCons>> _getDelivered() async {
    Map _data = await _getJson();

    OnRideForDriverResponse prodResponse =
        OnRideForDriverResponse.fromJson(_data);
    if (prodResponse.status == 'SUCCESS') return prodResponse.data!;
    print(_data);
    return [];
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
                          'Trip Summary',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<OnRideForDriverCons>>(
                future: _getDelivered(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      List<OnRideForDriverCons> cateee = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: cateee == null ? 0 : cateee.length,
                        itemBuilder: (BuildContext context, int index) {
                          OnRideForDriverCons cat = cateee[index];

                          return OnRideSingleD(
                            profilePic: cat.profielPic,
                            customerName: cat.customerName,
                            email: cat.email,
                            pickUpLocation: cat.pickUpLocation?? '',
                            dropLocation: cat.dropLocation ?? '',
                            date: cat.pickDate,
                            totalAmount: cat.amount ?? '0.00',
                            rideId: cat.rideId,
                            packageId: cat.packageId,
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No on going packages yet',
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

class OnRideForDriverResponse {
  final List<OnRideForDriverCons>? data;
  final String status;

  OnRideForDriverResponse({required this.data, required this.status});

  factory OnRideForDriverResponse.fromJson(Map<dynamic, dynamic> json) {
    return OnRideForDriverResponse(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((i) => OnRideForDriverCons.fromJson(i))
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
