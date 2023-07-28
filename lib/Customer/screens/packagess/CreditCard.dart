import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:runnerz/Customer/screens/packagess/add_package_one.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/card_utils.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:runnerz/Utils/input_formatters.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:toast/toast.dart';

class CreditCard extends StatefulWidget {
  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  bool _isLoading = false;
  String nameCheck = "kk";
  bool _validate = false;
  String? orderId;
  static String? paypalTranId;

  bool paypalChecker = false;
  bool secondCheck = true;
  String? paypalString;
  String? paypalcheckout;

  TextEditingController addressController = TextEditingController();
  TextEditingController cardNoController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController dateMonthController = TextEditingController();
  TextEditingController dateYearController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
//     khan();
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 89),
        // child: Form(
        // key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              "Payment by Card",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
                child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 3.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(19),
                              CardNumberInputFormatter()
                            ],
                            validator: (value) =>
                                CardUtils.validateCardNum(value!),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "card number 5506 7744 8610 9638",
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                              prefixIcon: Icon(
                                Icons.credit_card,
                                color: Theme.of(context).colorScheme.secondary,
                              ),

                              // labelText: 'Card number',
                              // errorText: _validate ? 'Username Can\'t Be Empty' : _validate,
                            ),
                            maxLines: 1,
                            controller: cardNoController,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 3.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: (value) => CardUtils.validateCVV(value!),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "Secret Code",
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                              prefixIcon: Icon(
                                Icons.security,
                                color: Theme.of(context).colorScheme.secondary,
                              ),

                              // labelText: 'Secret Code',
                              // errorText: _validate ? 'Username Can\'t Be Empty' : _validate,
                            ),
                            maxLines: 1,
                            controller: cvvController,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 3.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            validator: (value) {
                              if (value!.length < 2 ||
                                  int.parse(value) > 12 ||
                                  int.parse(value) < 1)
                                return 'Enter a valid month';
                              else if (value.length == 0)
                                return 'This field is required';
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "Expiry month",
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                              prefixIcon: Icon(
                                Icons.date_range,
                                color: Theme.of(context).colorScheme.secondary,
                              ),

                              // labelText: 'Expiry date',
                              // errorText: _validate ? 'Username Can\'t Be Empty' : _validate,
                            ),
                            maxLines: 1,
                            controller: dateMonthController,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 3.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: (value) {
                              if (value!.length < 4 ||
                                  int.parse(value) < DateTime.now().year)
                                return 'Enter a valid year';
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              hintText: "Expiry year",
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey,
                              ),
                              prefixIcon: Icon(
                                Icons.date_range,
                                color: Theme.of(context).colorScheme.secondary,
                              ),

                              // labelText: 'Expiry date',
                              // errorText: _validate ? 'Username Can\'t Be Empty' : _validate,
                            ),
                            maxLines: 1,
                            controller: dateYearController,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 62, // match_parent
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 23.0, right: 23.0, top: 10, bottom: 5),
                          child: ElevatedButton(
         
                                      style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              "Add".toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => PackageSelector()),
                              // );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ],
        ),
        //  ),
      ),
    );
  }
}
