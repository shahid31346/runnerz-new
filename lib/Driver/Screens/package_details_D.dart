import 'package:flutter/material.dart';
import 'package:runnerz/Common/listCons/singlePackageConsD.dart';
import 'package:runnerz/Customer/widgets/Package_detailSingle.dart';
import 'package:runnerz/Driver/Widgets/PackageDetailsSingleD.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PackageDetailsD extends StatefulWidget {
  final String id;
  final bool cancelChecker;

  PackageDetailsD({required this.id, required this.cancelChecker});

  @override
  _PackageDetailsDState createState() => _PackageDetailsDState();
}

class _PackageDetailsDState extends State<PackageDetailsD> {
  Future<Map> _getJson() async {
    String _value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    _value = pref1.getString("user_id")!;
    Uri apiUrl = Uri.parse(
        '${Constants.baseUrl}summary/single_ride?package_id=' +
            widget.id);
    print(apiUrl);
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

  Future<List<SinglePackageConsD>> getDetails() async {
    Map _data = await _getJson();

    SinglePackageResponseD prodResponse =
        SinglePackageResponseD.fromJson(_data);
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
              child: FutureBuilder<List<SinglePackageConsD>>(
                future: getDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      List<SinglePackageConsD> cateee = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        //physics: NeverScrollableScrollPhysics(),
                        itemCount: cateee == null ? 0 : cateee.length,
                        itemBuilder: (BuildContext context, int index) {
                          SinglePackageConsD cat = cateee[index];

                          return PackageDetailSingleD(
                            customerName: cat.customerName!,
                            customerPhone: cat.customerPhone!,
                            customerEmail: cat.customerEmail!,
                            packageCategory: cat.packageCategory!,
                            packageType: cat.packageType!,
                            packageWeight: cat.packageWeight!,
                            packageSize: cat.packageSize!,
                            handleWithCare: cat.handleWithCare!,
                            description: cat.description!,
                            comments: cat.comments!,
                            pickupLocation: cat.pickupLocation!,
                            dropLocation: cat.dropLocation!,
                            pickdate: cat.pickdate!,
                            pickTime: cat.pickTime!,
                            amount: cat.amount!,
                            photo1: cat.packagePhoto1!,
                            photo2: cat.packagePhoto2!,
                            photo3: cat.packagePhoto3!,
                            photo4: cat.packagePhoto4!,
                            perKmPrice: cat.perKmPrice!,
                            cancelChecker: widget.cancelChecker,
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

class SinglePackageResponseD {
  final List<SinglePackageConsD>? data;
  final String status;

  SinglePackageResponseD({required this.data, required this.status});

  factory SinglePackageResponseD.fromJson(Map<dynamic, dynamic> json) {
    return SinglePackageResponseD(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((i) => SinglePackageConsD.fromJson(i))
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
