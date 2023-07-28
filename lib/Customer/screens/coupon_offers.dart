import 'package:flutter/material.dart';
import 'package:runnerz/Common/dummylist/coupon_list.dart';
import 'package:runnerz/Common/listCons/CouponCons.dart';
import 'package:runnerz/Customer/widgets/coupons_single.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CouponScreen extends StatefulWidget {
  @override
  _CouponScreenState createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  Future<Map> _getJson() async {
    Uri apiUrl = Uri.parse(
        Constants.baseUrl + 'customers/fetch_all_coupon');
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

  Future<List<CouponCons>> getUndelivered() async {
    Map _data = await _getJson();
    print(_data);

    CouponResponse prodResponse = CouponResponse.fromJson(_data);
    if (prodResponse.status == 'SUCCESS') return prodResponse.data!;

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
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
                          'My Offers / Coupons',
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
              child: FutureBuilder<List<CouponCons>>(
                future: getUndelivered(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      List<CouponCons> cateee = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: cateee == null ? 0 : cateee.length,
                        itemBuilder: (BuildContext context, int index) {
                          CouponCons cat = cateee[index];

                          return CouponsSingle(
                              id: cat.id,
                              coupon: cat.coupon,
                              fromDate: cat.fromDate,
                              toDate: cat.toDate,
                              amount: cat.amount,
                              usedUpto: cat.usedUpto,
                              couponStatus: cat.couponStatus);
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No Packages are cancelled yet',
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

class CouponResponse {
  final List<CouponCons>? data;
  final String status;

  CouponResponse({required
   this.data, required this.status});

  factory CouponResponse.fromJson(Map<dynamic, dynamic> json) {
    return CouponResponse(
      data: json['data'] != null
          ? (json['data'] as List).map((i) => CouponCons.fromJson(i)).toList()
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
