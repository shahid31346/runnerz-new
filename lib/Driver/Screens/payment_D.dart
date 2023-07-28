import 'package:flutter/material.dart';
import 'package:runnerz/Common/dummylist/notification_list.dart';
import 'package:runnerz/Driver/Widgets/Ride_Earning_single_D.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';

class PaymentScreenD extends StatefulWidget {
  @override
  _PaymentScreenDState createState() => _PaymentScreenDState();
}

class _PaymentScreenDState extends State<PaymentScreenD> {
  DateTime selectedDate = DateTime.now();
  bool datevisibler = false;
  // String _date = "Not set";
  String _time = "Not set";
  bool fareChecker = false;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        datevisibler = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: ListView(
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
                padding: const EdgeInsets.only(top: 12.0, left: 15.0),
                child: Text(
                  'Payment',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(05.0)),
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, bottom: 12, top: 12, right: 12),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Ride Earnings',
                        style: TextStyle(
                            color: Constants.primary,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            '\$ 12,19,340.34 ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.date_range,
                                size: 28.0,
                                color: Constants.primary,
                              ),
                              //color: Colors.black,
                              onPressed: () {
                                _selectDate(context);
                                print(
                                    "${selectedDate.toLocal()}".split(' ')[0]);
                              },
                              tooltip: "My Orders",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: notification_list == null
                        ? 0
                        : notification_list.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map cat = notification_list[index];
                      return RideEarningSingleD(
                        title: cat['title'],
                        subtitle: cat['subtitle'],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 13)
        ],
      ),
    );
  }
}
