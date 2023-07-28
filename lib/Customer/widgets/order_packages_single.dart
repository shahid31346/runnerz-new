import 'package:flutter/material.dart';
import 'package:runnerz/Customer/screens/packagess/order_packages.dart';
import 'package:runnerz/Customer/screens/packagess/package_details.dart';

class OrderPackageSingle extends StatefulWidget {
  final String packageId;
  final String profilePic;
  final String? driverStars;
  final String driverName;
  final String vechilename;
  final String? token;
  final String mobileNo;
  final String email;
  final String pickUpLocation;
  final String dropLocation;
  final String date;
  final String time;
  final String totalAmount;
  final String couponapplied;

  OrderPackageSingle({
    Key? key,
  required  this.packageId,
  required  this.profilePic,
    this.driverStars,
  required  this.driverName,
  required  this.vechilename,
    this.token,
  required  this.mobileNo,
  required  this.email,
  required  this.pickUpLocation,
  required  this.dropLocation,
  required  this.date,
   required this.time,
  required  this.totalAmount,
   required this.couponapplied,
  }) : super(key: key);

  @override
  _OrderPackageSingleState createState() => _OrderPackageSingleState();
}

class _OrderPackageSingleState extends State<OrderPackageSingle> {
  String? _selection;

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.4;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PackageDetails(
                cancelChecker: false,
                id: widget.packageId,
              );
            },
          ),
        );
      },
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(05.0)),
          elevation: 4.0,
          child: Container(height: 100)),
    );
  }
}
