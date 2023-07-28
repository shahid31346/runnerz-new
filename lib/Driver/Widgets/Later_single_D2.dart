import 'package:flutter/material.dart';

class LaterSingleD2 extends StatefulWidget {
  final String profilePic;
  final String customerName;
  final String email;
  final String pickUpLocation;
  final String dropLocation;
  final String date;
  final String totalAmount;

  LaterSingleD2({
    Key? key,
   required this.profilePic,
   required this.customerName,
   required this.email,
   required this.pickUpLocation,
   required this.dropLocation,
   required this.date,
   required this.totalAmount,
  }) : super(key: key);

  @override
  _LaterSingleD2State createState() => _LaterSingleD2State();
}

class _LaterSingleD2State extends State<LaterSingleD2> {
  String? _selection;
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
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
                              "Hamid Ali".toUpperCase(),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "\$${widget.totalAmount}",
                              style: TextStyle(
                                color: Color(0xff1fa2f2),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              "${widget.email}",
                              style: TextStyle(
                                color: Color(0xff1fa2f2),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5.0),
                          ],
                        ),
                      ),
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
                        child: Icon(
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
                              new Text('${widget.pickUpLocation}',
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
                              new Text('${widget.dropLocation}',
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
              Divider(),
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('  ${widget.date}'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }
}
