import 'package:flutter/material.dart';
import 'package:runnerz/Driver/Screens/package_details_D.dart';

class DeclineSingleD extends StatelessWidget {
  final String profilePic;
  final String userName;
   final String? email;
  final String pickUpLocation;
  final String dropLocation;
  final String date;
  final String totalAmount;
  final String packageId;

  DeclineSingleD({
    Key? key,
   required this.profilePic,
   required this.userName,
    this.email,
   required this.pickUpLocation,
   required this.dropLocation,
   required this.date,
   required this.totalAmount,
   required this.packageId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.4;

    return InkWell(
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(05.0)),
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 15.0, 13.0, 0.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.width / 4.0,
                    width: MediaQuery.of(context).size.width / 4.0,
                    child: ClipOval(
                      child: Image.network(
                        "$profilePic",
                        height: 30,
                        width: 15,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "$userName".toUpperCase(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          "\$$totalAmount",
                          style: TextStyle(
                            color: Color(0xff1fa2f2),
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  right: 8.0,
                  left: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                'o',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Color(0xff1fa2f2),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              ' PICKUP LOCATION',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff1fa2f2),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          width: c_width,
                          child: new Column(
                            children: <Widget>[
                              new Text('$pickUpLocation',
                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                        // Text(
                        //   '$pickUpLocation',
                        //   overflow: TextOverflow.ellipsis,
                        //   style: TextStyle(
                        //     color: Colors.black54,
                        //     fontSize: 10,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                'o',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              ' DROP LOCATION',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          width: c_width,
                          child: new Column(
                            children: <Widget>[
                              new Text('$dropLocation',
                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // SizedBox(
              //   height: 5,
              // ),
              // Divider(),
              // SizedBox(
              //   height: 5,
              // ),

              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              //   child: Row(
              //     children: <Widget>[
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: <Widget>[
              //           Text('Reason :',
              //               style: TextStyle(color: Colors.black54)),
              //           Text(
              //             'I am not interested',
              //             style: TextStyle(color: Colors.black),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 5,
              ),

              Divider(),
              SizedBox(
                height: 5,
              ),

              // SizedBox(height: 10.0),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('  $date'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PackageDetailsD(
                cancelChecker: true,
                id: packageId,
              );
            },
          ),
        );
      },
    );
  }
}
