import 'package:flutter/material.dart';
import 'package:runnerz/Customer/screens/packagess/CreditCard.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool checkboxValueA = true;
  bool checkboxValueB = false;
  bool? checkboxValueC;
  int radioValue = 0;
  bool switchValue = false;
  String result = 'Credit card';

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;

      switch (radioValue) {
        case 0:
          result = 'Credit Card';
          print(result);
          break;
        case 1:
          result = "Debit Card";
          print(result);
          break;

        default:
          print("Nothing selected!");
      }

//      print("Value is ${radioValue.toString()}");
    });
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
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
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
                        'Select Payment',
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),

                new Padding(padding: new EdgeInsets.all(5.0)),
                //three toggle buttons

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Radio<int>(
                              activeColor: Constants.primary,
                              value: 0,
                              groupValue: radioValue,
                                   onChanged: (d) {
                                handleRadioValueChanged(d!);
                              }),
                          Image.asset(
                            'assets/mastercard.png',
                            height: 80,
                            width: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: new Text(
                              "Credit Card",
                              style: new TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      //radiobuttons go here
                      Row(
                        children: <Widget>[
                          new Radio<int>(
                              activeColor: Constants.primary,
                              value: 1,
                              groupValue: radioValue,
                              onChanged: (d) {
                                handleRadioValueChanged(d!);
                              }),
                          Image.asset(
                            'assets/visa.png',
                            height: 80,
                            width: 80,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: new Text(
                              "Debit Card",
                              style: new TextStyle(
                                  color: Colors.black54,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      Divider(),

                      SizedBox(
                        width: double.infinity,
                        height: 77, // match_parent
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 05.0,
                            right: 05.0,
                            top: 20,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff1fa2f2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              "make payment".toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return CreditCard();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
