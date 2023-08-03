import 'package:flutter/material.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';

class Invoice extends StatefulWidget {
  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.6;
    double d_width = MediaQuery.of(context).size.width * 0.4;

    return Scaffold(
        appBar: BaseAppBar(
          appBar: AppBar(),
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 0.0),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: const BoxDecoration(
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
                child: const Padding(
                  padding: EdgeInsets.only(top: 2.0, left: 15.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Invoice',
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
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                top: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Jonathan carter'.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "+920987363333",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 1),
                  const Text(
                    "Jonathan@gmail.com",
                    style: TextStyle(
                      color: Color(0xff1fa2f2),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: <Widget>[
                      Text(
                        'Package Category :  ',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Electronic Good',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: <Widget>[
                      Text(
                        'Package Type :  ',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Mobile',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: <Widget>[
                      Text(
                        'Package Weight :  ',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '2Kg',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: <Widget>[
                      Text(
                        'Package Size :  ',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        '12x12x12 in',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    children: <Widget>[
                      Text(
                        'Handle with Care :  ',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Yes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/profile.jpeg',
                        height: 100,
                        width: 100,
                      ),
                      Image.asset(
                        'assets/profile.jpeg',
                        height: 100,
                        width: 100,
                      ),
                      Image.asset(
                        'assets/profile.jpeg',
                        height: 100,
                        width: 100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                      left: 2,
                      top: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5.0),
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
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              width: d_width,
                              child: new Column(
                                children: <Widget>[
                                  new Text('6, Balaji Mandir Rd, Cheeta chowk',
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
                            const Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 5.0),
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
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              width: d_width,
                              child: new Column(
                                children: <Widget>[
                                  new Text('Chhatrapati Shivaji Terminus',
                                      textAlign: TextAlign.left),
                                ],
                              ),
                            ),

                            // Text(
                            //   '$dropLocation',
                            //   overflow: TextOverflow.ellipsis,
                            //   style: TextStyle(
                            //     color: Colors.black54,
                            //     fontSize: 10,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8.0),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.motorcycle),
                            Text('  28 FEB, 2020 AT  '),
                            Text('21:32'),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '\$ 250.57',
                              style: TextStyle(
                                  color: Color(0xff1fa2f2),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    '${Constants.appname} Address'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Constants.primary,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/logo.png',
                        height: 30,
                        width: 70,
                        color: Constants.primary,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: c_width,
                        child: new Column(
                          children: <Widget>[
                            new Text("6, Balaji Mandir Rd, Cheeta chowk, ",
                                textAlign: TextAlign.left),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "+920987363333",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    "Jonathan@gmail.com",
                    style: TextStyle(
                      color: Constants.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Divider(),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.width / 4.0,
                        width: MediaQuery.of(context).size.width / 4.0,
                        child: ClipOval(
                          child: Image.asset(
                            'assets/profile.jpeg',
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
                              "Balakrishna".toUpperCase(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              "TATA Cargo Truck",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 4),
                              child: Container(
                                height: 25,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[500]!,
                                    ),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(2))),
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      left: 6.0, right: 6),
                                  child: Center(
                                    child: Text(
                                      "ALQ1S16235",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              "+94139065654",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Text(
                              "info@runnerz.com",
                              style: TextStyle(
                                color: Color(0xff1fa2f2),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.only(
                      right: 25.0,
                      left: 10,
                      top: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'TOTAL DISTANCE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '20 KM',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'TOTAL FARE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  '\$250.57',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 05.0, right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'BASE FARE / KM',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$8.00',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 05.0, right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'PEAK TIME COST / MIN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$5.00',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 05.0, right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'NIGHT CHARGES / KM',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$10.00',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 05.0, right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'OVERTIME CHARGES / HOUR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$5.00',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 05.0, right: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'SERVICE TAX',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$5.00',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  const Text(
                    '* Terms & Conditions Apply',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
