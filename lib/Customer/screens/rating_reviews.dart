import 'package:flutter/material.dart';
import 'package:runnerz/Common/dummylist/notification_list.dart';
import 'package:runnerz/Common/rating.dart';
import 'package:runnerz/Customer/widgets/rate_review_single.dart';
import 'package:runnerz/Utils/base_appbar.dart';

class RateReviewsScreen extends StatefulWidget {
  @override
  _RateReviewsScreenState createState() => _RateReviewsScreenState();
}

class _RateReviewsScreenState extends State<RateReviewsScreen> {
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
                          'Rating & reviews',
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
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(05.0)),
              elevation: 4.0,
              child: Container(
                width: double.infinity,
                height: 210,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        'Average Star Ratings'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        '4.5'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 60,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        StarRating(
                          size: 30,
                          rating: 4.5,
                          //rating: double.parse(ratingInNumbers),
                          onRatingChanged: (s){},
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.supervised_user_circle,
                          size: 18.5,
                        ),
                        Text('18,350 total'),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    notification_list == null ? 0 : notification_list.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = notification_list[index];
                  return ReviewSingle(
                    userName: cat['title'],
                    rating: cat['subtitle'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
