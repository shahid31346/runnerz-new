import 'package:flutter/material.dart';

class ReviewSingleD extends StatelessWidget {
  final String profiePic;
  final String userName;
  final String rating;
  final String description;

  ReviewSingleD({
    Key? key,
    required this.profiePic,
    required this.userName,
    required this.rating,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(05.0)),
      elevation: 4.0,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.width / 4.0,
                      width: MediaQuery.of(context).size.width / 4.0,
                      child: ClipOval(
                        child: Image.network(
                          "$profiePic",
                          height: 30,
                          width: 15,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "$userName".toUpperCase(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      color: Colors.grey.withOpacity(0.5))),
                              backgroundColor: Color(0xffe3c026),
                            ),

                            onPressed: () {},
                            // splash color
                            // button pressed

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("$rating"),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(Icons.star), // icon
                                // text
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              ExpansionTile(
                title: Text(
                  "View Review",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                children: <Widget>[
                  ListTile(
                    title: Text('$description'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
