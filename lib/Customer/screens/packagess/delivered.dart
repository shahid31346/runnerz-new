import 'package:flutter/material.dart';
import 'package:runnerz/Common/listCons/deliveredCons.dart';
import 'package:runnerz/Customer/screens/packagess/add_package_one.dart';
import 'package:runnerz/Customer/widgets/delivered_single.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Delivered extends StatefulWidget {
  @override
  DeliveredState createState() => DeliveredState();
}

class DeliveredState extends State<Delivered> {
  Future<Map> getJson() async {
    String _value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;
    Uri apiUrl = Uri.parse(
        Constants.baseUrl + 'packages/delivered_pacakges?user_id=' + _value);

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

  Future<List<DeliveredCons>> getDelivered() async {
    Map _data = await getJson();

    DeliveredResponse prodResponse = DeliveredResponse.fromJson(_data);
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
                          tooltip: "My Orders",
                        ),
                      ]),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<DeliveredCons>>(
                future: getDelivered(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      List<DeliveredCons> cateee = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: cateee == null ? 0 : cateee.length,
                        itemBuilder: (BuildContext context, int index) {
                          DeliveredCons cat = cateee[index];

                          return DeliveredSingle(
                            packageId: cat.packageId,
                            profilePic: cat.profielPic,
                            driverName: cat.driverName,
                            vechilename: cat.vechileName,
                            mobileNo: cat.phone,
                            email: cat.email,
                            pickUpLocation: cat.pickUpLocation,
                            dropLocation: cat.dropLocation,
                            date: cat.pickDate,
                            time: cat.pickTime,
                            totalAmount: cat.amount,
                            couponapplied: cat.couponCode,
                            driverId: cat.driverId,
                            rideId: cat.rideId,
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No Delivered Packages yet',
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

class DeliveredResponse {
  final List<DeliveredCons>? data;
  final String status;

  DeliveredResponse({this.data,required this.status});

  factory DeliveredResponse.fromJson(Map<dynamic, dynamic> json) {
    return DeliveredResponse(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((i) => DeliveredCons.fromJson(i))
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
