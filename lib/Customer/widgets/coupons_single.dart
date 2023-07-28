import 'package:flutter/material.dart';
import 'package:runnerz/Utils/const.dart';

class CouponsSingle extends StatefulWidget {
  final String id;
  final String coupon;
  final String fromDate;
  final String toDate;
  final String amount;
  final String usedUpto;
  final String couponStatus;

  CouponsSingle({
    Key? key,
   required this.id,
   required this.coupon,
  required  this.fromDate,
  required  this.toDate,
  required  this.amount,
  required  this.usedUpto,
   required this.couponStatus,
  }) : super(key: key);

  @override
  _CouponsSingleState createState() => _CouponsSingleState();
}

class _CouponsSingleState extends State<CouponsSingle> {
  bool colorChecker = false;
  Color? value;

  couponStatusChecker() {
    if (widget.couponStatus == 'Valid') {
      setState(() {
        bool colorChecker = false;
        value = Colors.blue;
      });
    } else {
      setState(() {
        bool colorChecker = true;
        value = Colors.grey;
      });
    }
  }

  callme() async {
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      couponStatusChecker();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    couponStatusChecker();
  }

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.4;
    double d_width = MediaQuery.of(context).size.width * 0.8;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10,
          top: 7,
          bottom: 7,
        ),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(05.0)),
          elevation: 4.0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15.0, 15.0, 13.0, 8.8),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    left: 2,
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                '${widget.coupon}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff1fa2f2),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                height: 28,
                                width: 28,
                                child: ClipOval(
                                  child: Material(
                                    color: value, // button color
                                    child: InkWell(
                                      splashColor: Colors.red, // inkwell color
                                      child: SizedBox(
                                          width: 10,
                                          height: 10,
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )),
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: c_width,
                                child: new Column(
                                  children: <Widget>[
                                    new Text(
                                        'Get ${widget.amount} off, Valid limit per user is ${widget.usedUpto}',
                                        textAlign: TextAlign.left),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Constants.primary.withOpacity(0.1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: <Widget>[
                                    Text('Coupon Code :'),
                                    Text(widget.coupon),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(height: 1.0),

                Container(
                  // padding: const EdgeInsets.all(16.0),
                  width: d_width,
                  child: new Column(
                    children: <Widget>[
                      new Text(
                          "Valid From : ${widget.fromDate}  - TILL :  ${widget.toDate}",
                          textAlign: TextAlign.start),
                    ],
                  ),
                ),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Row(
                //       children: <Widget>[
                //         Text('Valid From :  '),
                //         Text("$validFrom"),
                //         Text('  - TILL :  '),
                //         Text("$validTo"),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
