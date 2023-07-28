import 'package:flutter/material.dart';
import 'package:runnerz/Common/listCons/undeliveredCons.dart';
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Common/notifications.dart';
import 'package:runnerz/Customer/screens/packagess/add_package_one.dart';
import 'package:runnerz/Customer/widgets/order_packages_single.dart';
import 'package:runnerz/Customer/widgets/undeliveredicon.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPackages extends StatefulWidget {
  final String identifier;

  OrderPackages({required this.identifier});
  @override
  OrderPackagesState createState() => OrderPackagesState();
}

class OrderPackagesState extends State<OrderPackages> {
  Future<Map> getJson() async {
    String _value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;


    Uri apiUrl = Uri.parse(
        Constants.baseUrl + 'packages/get_all_orders?user_id=7');
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

  Future<List<UnDeliveredCons>> getUndelivered() async {
    Map _data = await getJson();
    print(_data);

    UndeliveredResponse prodResponse = UndeliveredResponse.fromJson(_data);
    if (prodResponse.status == 'SUCCESS') return prodResponse.data!;

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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 38,
            ),
            // Container(
            //     padding: const EdgeInsets.all(8.0), child: Text('YourAppTitle'))
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            //color: Colors.black,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return NotificationScreen();
                  },
                ),
              );
            },
            tooltip: "Notifications",
          ),
          IconButton(
            icon: Icon(Icons.power_settings_new),
            //color: Colors.black,
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();

              SharedPreferences pref1 = await SharedPreferences.getInstance();
              pref1.setString("user_id", '');

              preferences.setInt("value", 12);
              preferences.setString("email", '');
              preferences.setString("id", '');
              preferences.setString("created_at", '');
              preferences.setString("name", '');
              preferences.setString("username", '');

              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (BuildContext context) {
                  return LoginScreen();
                },
              ), (route) => false);
            },
            tooltip: "Logout",
          ),
        ],
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
              child: FutureBuilder<List<UnDeliveredCons>>(
                future: getUndelivered(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      List<UnDeliveredCons> cateee = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: cateee == null ? 0 : cateee.length,
                        itemBuilder: (BuildContext context, int index) {
                          UnDeliveredCons cat = cateee[index];

                          return OrderPackageSingle(
                            packageId: cat.packageId,
                            profilePic: cat.profielPic,
                            driverName: cat.driverName,
                            vechilename: cat.vechileName,
                            mobileNo: cat.phone,
                            email: cat.email,
                            pickUpLocation: cat.pickUpLocation,
                            dropLocation: cat.dropLocation,
                            date: cat.pickTime,
                            time: cat.pickDate,
                            totalAmount: cat.amount,
                            couponapplied: cat.couponCode,
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

  UndeliveredResponse({this.data,required this.status});

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
