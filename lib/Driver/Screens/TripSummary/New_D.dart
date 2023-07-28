import 'package:flutter/material.dart';
import 'package:runnerz/Common/dummylist/undelivereddummy.dart';
import 'package:runnerz/Common/listCons/New_DCons.dart';
import 'package:runnerz/Driver/Widgets/New_single_D.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class NewTripD extends StatefulWidget {
  @override
  NewTripDState createState() => NewTripDState();
}

class NewTripDState extends State<NewTripD> {
  Future<Map> _getJson() async {
    String _value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;
    Uri apiUrl =
        Uri.parse(Constants.baseUrl + 'summary/new_trip?driver_id=' + _value);

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

  Future<List<NewForDriverCons>> _getDelivered() async {
    Map _data = await _getJson();

    NewForDriverResponse prodResponse = NewForDriverResponse.fromJson(_data);
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
              child: FutureBuilder<List<NewForDriverCons>>(
                future: _getDelivered(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      List<NewForDriverCons> cateee = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: cateee == null ? 0 : cateee.length,
                        itemBuilder: (BuildContext context, int index) {
                          NewForDriverCons cat = cateee[index];

                          return NewSingleD(
                            profilePic: cat.profielPic,
                            customerName: cat.customerName,
                            pickUpLocation: cat.pickUpLocation,
                            dropLocation: cat.dropLocation,
                            date: cat.pickDate,
                            totalAmount: cat.amount,
                            id: cat.rideId,
                            packageId: cat.packageId,
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No New Packages yet',
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

class NewForDriverResponse {
  final List<NewForDriverCons>? data;
  final String status;

  NewForDriverResponse({required this.data, required this.status});

  factory NewForDriverResponse.fromJson(Map<dynamic, dynamic> json) {
    return NewForDriverResponse(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((i) => NewForDriverCons.fromJson(i))
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
