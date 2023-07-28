import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Common/listCons/rateReviewCons.dart';
import 'package:runnerz/Common/listCons/rating&reviews.dart';
import 'package:runnerz/Common/rating.dart';
import 'package:runnerz/Driver/Widgets/rate_review_single_D.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RateReviewsScreenD extends StatefulWidget {
  @override
  _RateReviewsScreenDState createState() => _RateReviewsScreenDState();
}

class _RateReviewsScreenDState extends State<RateReviewsScreenD> {
  String stars = "";
  String total = "";
  bool loading = false;
  bool apiCalled = false;
  RatingCons? detail;
  Future<Map> getJson() async {
    String _value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;
    Uri apiUrl =
        Uri.parse(Constants.baseUrl + 'customers/driver_rating?driver_id=5');
    //  + _value;

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

  _getDetail() async {
    setState(() {
      loading = true;
      apiCalled = true;
    });
    try {
      Map _data1 = await getJson();
      print(_data1['data'][0]);

      if (_data1['data'] is List) {
        RatingDetailsResponse prodDetailResponse =
            RatingDetailsResponse.fromJson(_data1);
        setState(() {
          loading = false;
          detail = prodDetailResponse.data![0];
        });
      } else {
        setState(() {
          detail = RatingCons();
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        detail = null;
        loading = false;
      });
    }
  }

  Future<List<RateReviewCons>> getDelivered() async {
    Map _data = await getJson();

    RateReviewResponse prodResponse = RateReviewResponse.fromJson(_data);
    if (prodResponse.status == 'SUCCESS') return prodResponse.data!;
    print(_data);
    return [];
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
      body: !loading
          ? Container(
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
                                'Rating & reviews',
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
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(05.0)),
                    elevation: 4.0,
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
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
                              '${detail!.stars}'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 60,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              StarRating(
                                size: 30,
                                rating: double.parse('${detail!.stars}'),
                                //rating: double.parse(ratingInNumbers),
                                onRatingChanged: (stars){},
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.supervised_user_circle,
                                size: 18.5,
                              ),
                              Text(' ${detail!.total} total'),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<RateReviewCons>>(
                      future: getDelivered(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.length > 0) {
                            List<RateReviewCons> cateee = snapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              //physics: NeverScrollableScrollPhysics(),
                              itemCount: cateee == null ? 0 : cateee.length,
                              itemBuilder: (BuildContext context, int index) {
                                RateReviewCons cat = cateee[index];

                                return ReviewSingleD(
                                  profiePic: cat.profielPic,
                                  userName: cat.name,
                                  rating: cat.stars,
                                  description: cat.reviewDescription,
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Text(
                                'No Reviews yet',
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class RateReviewResponse {
  final List<RateReviewCons>? data;
  final String status;

  RateReviewResponse({ required  this.data, required this.status});

  factory RateReviewResponse.fromJson(Map<dynamic, dynamic> json) {
    return RateReviewResponse(
      data: json['reviews'] != null
          ? (json['reviews'] as List)
              .map((i) => RateReviewCons.fromJson(i))
              .toList()
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['reviews'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingDetailsResponse {
  final List<RatingCons>? data;
  final String status;

  RatingDetailsResponse({required this.data, required this.status});

  factory RatingDetailsResponse.fromJson(Map<dynamic, dynamic> json) {
    return RatingDetailsResponse(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => RatingCons.fromJson(i)).toList()
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
