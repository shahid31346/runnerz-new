import 'package:flutter/material.dart';
import 'package:runnerz/Driver/Screens/package_details_D.dart';

class CancelledSingleD extends StatefulWidget {
  final String pickUpLocation;
  final String dropLocation;
  final String date;
  final String packageId;

  final String totalAmount;

  CancelledSingleD({
    Key? key,
    required this.pickUpLocation,
    required this.dropLocation,
    required this.date,
    required this.totalAmount,
    required this.packageId,
  }) : super(key: key);

  @override
  _CancelledSingleDState createState() => _CancelledSingleDState();
}

class _CancelledSingleDState extends State<CancelledSingleD> {
  String? _selection;

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.4;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PackageDetailsD(
                cancelChecker: true,
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 15.0, 13.0, 0.0),
          child: Column(
            children: <Widget>[
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
                                  fontSize: 20,
                                  color: Color(0xff1fa2f2),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              ' PICKUP LOCATION',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff1fa2f2),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          width: c_width,
                          child: Column(
                            children: <Widget>[
                              Text(widget.pickUpLocation,
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
                                  fontSize: 20,
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              ' DROP LOCATION',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.pinkAccent,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 16),
                          width: c_width,
                          child:  Column(
                            children: <Widget>[
                               Text(widget.dropLocation,
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
                    ),
                    Row(
                      children: <Widget>[
                        PopupMenuButton<String>(
                          onSelected: (String value) {
                            setState(() {
                              _selection = value;
                            });
                          },
                          child: const Icon(
                            Icons.more_vert,
                            size: 35,
                            color: Colors.black54,
                          ),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Value1',
                              child: Text('Choose value 1'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Value2',
                              child: Text('Choose value 2'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Value3',
                              child: Text('Choose value 3'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Reason :',
                            style: TextStyle(color: Colors.black54)),
                        Text(
                          'I am not interested',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(),
              const SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(Icons.motorcycle),
                        Text('  ${widget.date}'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          ' \$${widget.totalAmount}',
                          style: const TextStyle(
                              color: Color(0xff1fa2f2),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
