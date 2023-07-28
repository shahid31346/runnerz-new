import 'package:flutter/material.dart';
import 'package:runnerz/Common/listCons/single_packageCons.dart';
import 'package:runnerz/Customer/widgets/Package_detailSingle.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PackageDetails extends StatefulWidget {
  final String id;
  final bool? cancelChecker;

  PackageDetails({required this.id, required this.cancelChecker});

  @override
  _PackageDetailsState createState() => _PackageDetailsState();
}

class _PackageDetailsState extends State<PackageDetails> {
  Future<Map> getJson() async {
    String _value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;

    Uri apiUrl = Uri.parse(Constants.baseUrl +
        'packages/single_package?user_id=' +
        _value +
        '&package_id=' +
        widget.id);

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

  Future<List<SinglePackageCons>> getDetails() async {
    Map _data = await getJson();

    SinglePackageResponse prodResponse = SinglePackageResponse.fromJson(_data);
    if (prodResponse.status == 'SUCCESS') return prodResponse.data!;
    print(_data);
    return [];
  }

  saver() async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    pref1.setString("packaaaage_id", widget.id);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saver();
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
                          'Package details',
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
              child: FutureBuilder<List<SinglePackageCons>>(
                future: getDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      List<SinglePackageCons> cateee = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: cateee == null ? 0 : cateee.length,
                        itemBuilder: (BuildContext context, int index) {
                          SinglePackageCons cat = cateee[index];

                          return PackageDetailSingle(
                            customerName: cat.customerName,
                            customerPhone: cat.customerPhone,
                            customerEmail: cat.customerEmail,
                            packageCategory: cat.packageCategory,
                            packageType: cat.packageType,
                            packageWeight: cat.packageWeight,
                            packageSize: cat.packageSize,
                            handleWithCare: cat.handleWithCare,
                            description: cat.description,
                            comments: cat.comments,
                            pickupLocation: cat.pickupLocation,
                            dropLocation: cat.dropLocation,
                            pickdate: cat.pickdate,
                            pickTime: cat.pickTime,
                            amount: cat.amount,
                            driverPic: cat.driverPic,
                            driverName: cat.driverName,
                            vehicleName: cat.vehicleName,
                            vehicleNumber: cat.vehicleNumber,
                            driverPhone: cat.driverPhone,
                            driverEmail: cat.driverEmail,
                            photo1: cat.packagePhoto1,
                            photo2: cat.packagePhoto2,
                            photo3: cat.packagePhoto3,
                            photo4: cat.packagePhoto4,
                            perKmPrice: cat.perKmPrice,
                            cancelChecker: widget.cancelChecker!,
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No Details for this package found',
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

class SinglePackageResponse {
  final List<SinglePackageCons>? data;
  final String status;

  SinglePackageResponse({this.data,required this.status});

  factory SinglePackageResponse.fromJson(Map<dynamic, dynamic> json) {
    return SinglePackageResponse(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((i) => SinglePackageCons.fromJson(i))
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
