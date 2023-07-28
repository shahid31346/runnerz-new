import 'package:flutter/material.dart';
import 'package:runnerz/Common/dummylist/undelivereddummy.dart';
import 'package:runnerz/Common/listCons/LaterCons.dart';
import 'package:runnerz/Customer/screens/packagess/add_package_one.dart';
import 'package:runnerz/Customer/widgets/later_single.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Later extends StatefulWidget {
  @override
  LaterState createState() => LaterState();
}

class LaterState extends State<Later> {
  Future<Map> _getJson() async {
    String _value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;

    Uri apiUrl = Uri.parse(
        Constants.baseUrl + 'packages/later_packages?user_id=' + _value);

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

  Future<List<LaterCons>> getUndelivered() async {
    Map _data = await _getJson();
    print(_data);

    LaterResponse prodResponse = LaterResponse.fromJson(_data);
    if (prodResponse.status == 'SUCCESS') return prodResponse.data!;

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
                          tooltip: "Add Package",
                        ),
                      ]),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<LaterCons>>(
                future: getUndelivered(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      List<LaterCons> cateee = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: cateee == null ? 0 : cateee.length,
                        itemBuilder: (BuildContext context, int index) {
                          LaterCons cat = cateee[index];

                          return LaterSingle(
                            pickUpLocation: cat.pickUpLocation,
                            dropLocation: cat.dropLocation,
                            date: cat.pickDate,
                            time: cat.pickTime,
                            totalAmount: cat.amount,
                            couponapplied: cat.couponCode,
                            packageId: cat.packageId,
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No Packages are selected for later',
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

class LaterResponse {
  final List<LaterCons>? data;
  final String status;

  LaterResponse({this.data,required this.status});

  factory LaterResponse.fromJson(Map<dynamic, dynamic> json) {
    return LaterResponse(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => LaterCons.fromJson(i)).toList()
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
