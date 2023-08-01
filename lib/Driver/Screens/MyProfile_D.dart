import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Common/changepassword.dart';
import 'package:runnerz/Common/edit_details.dart';
import 'package:runnerz/Common/listCons/DriverDetails.dart';
import 'package:runnerz/Common/rating.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddVehicleD.dart';

class ProfileScreenD extends StatefulWidget {
  @override
  _ProfileScreenDState createState() => _ProfileScreenDState();
}

class _ProfileScreenDState extends State<ProfileScreenD> {
  bool loading = false;
  bool apiCalled = false;
  DriverDetail? detail;

  Future<Map> _getJson() async {
    String value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value = pref1.getString("user_id")!;

    Uri apiUrl = Uri.parse(
        '${Constants.baseUrl}customers/driver_profile_info?driver_id=' +
            value);
    //Constants.baseUrl + 'customers/driver_profile_info?driver_id=' + value;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };

    http.Response response = await http.get(
      apiUrl,
      headers: headers,
    );
    print(' 123');
    print(apiUrl);
    return json.decode(response.body); // returns a List type
  }

  _getDetail() async {
    setState(() {
      loading = true;
      apiCalled = true;
    });
    // try {
    Map _data1 = await _getJson();
    print(_data1['driver'][0]);

    if (_data1['driver'] is List) {
      DriverDetailsResponse prodDetailResponse =
          DriverDetailsResponse.fromJson(_data1);
      setState(() {
        loading = false;
        detail = prodDetailResponse.data![0];
      });
    } else {
      setState(() {
        detail = DriverDetail();
        loading = false;
      });
    }
    // } catch (e) {
    //   setState(() {
    //     detail = null;
    //     loading = false;
    //   });
    // }
  }

  @override
  void initState() {
    // TODO: implement initState

    //_getDetail();
  }

  @override
  Widget build(BuildContext context) {
    if (!apiCalled) {
      Future.delayed(Duration(milliseconds: 2), () {
        _getDetail();
      });
    }
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: _getDetailWidget(context),
    );
  }

  Widget _getDetailWidget(BuildContext context) {
    if (!loading) {
      return ListView(
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
                padding: const EdgeInsets.only(top: 12.0, left: 15.0),
                child: Text(
                  'My Profile',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(05.0)),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "${detail!.name}".toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Container(
                    width: 150.0,
                    height: 150.0,
                    child: new Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        new ClipOval(
                          child: Image.network(
                            "${detail!.profilePic}",
                            height: 115,
                            width: 115,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // new Align(
                        //   alignment: Alignment.bottomCenter,
                        //   child: new RawMaterialButton(
                        //     onPressed: () {},
                        //     fillColor: Colors.white,
                        //     shape: CircleBorder(),
                        //     elevation: 4.0,
                        //     child: Padding(
                        //       padding: EdgeInsets.all(5),
                        //       child: Icon(
                        //         Icons.camera_alt,
                        //         color: Constants.primary,
                        //         size: 15,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Vechile Number',
                    style: TextStyle(fontSize: 15, color: Constants.primary),
                  ),
                  SizedBox(
                    height: 07,
                  ),
                  Text(
                 detail!.vechileNo == null ? "Not assigned" : "${detail!.vechileNo}".toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primary,
                      ),
                      child: Text(
                        'Add vehicle',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Addvehicle();
                            },
                          ),
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.motorcycle,
                            color: Constants.primary,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              'Vechile Type',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Constants.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                         detail!.vechiletype == null  ? "Not assigned" :  "${detail!.vechiletype}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.motorcycle,
                            color: Constants.primary,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: Text(
                              'Vechile Name',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Constants.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            detail!.vechilename == null
                                ? "Not assigned"
                                : "${detail!.vechilename}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Container(
                    width: double.infinity,
                    height: 270,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Average Star Ratings'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            detail!.driverAverageRating == null
                                ? "No rating"
                                : "${detail!.driverAverageRating}"
                                    .toUpperCase(),
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 60,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            StarRating(
                              size: 30,
                              rating: detail!.driverAverageRating == null
                                  ? 3.0
                                  : double.parse(
                                      '${detail!.driverAverageRating}'),
                              //rating: double.parse(ratingInNumbers),
                              onRatingChanged: (s) {},
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    // width: double.infinity,
                                    height: 47, // match_parent

                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 10.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff1fa2f2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        child: Text(
                                          "Edit Details",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditDetails()),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    // width: double.infinity,
                                    height: 47, // match_parent

                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 15.0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          textStyle:
                                              TextStyle(color: Colors.black),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              side: BorderSide(
                                                  color: Colors.grey,
                                                  width: 2)),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChangePassword()),
                                          );
                                        },
                                        child: Text(
                                          "Change Password".toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11.2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class DriverDetailsResponse {
  final List<DriverDetail>? data;
  final String status;

  DriverDetailsResponse({required this.data, required this.status});

  factory DriverDetailsResponse.fromJson(Map<dynamic, dynamic> json) {
    return DriverDetailsResponse(
      data: json['driver'] != null
          ? (json['driver'] as List)
              .map((i) => DriverDetail.fromJson(i))
              .toList()
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['driver'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
