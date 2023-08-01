import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  // final String email;
  // final String newEmail;
  // final bool isGuestCheckOut;

  const Otp({
    Key? key,
    //  @required this.email,
    // this.newEmail = "",
    // this.isGuestCheckOut,
  }) : super(key: key);

  @override
  _OtpState createState() => new _OtpState();
}

class _OtpState extends State<Otp> with SingleTickerProviderStateMixin {
  // Constants
  final int time = 30;
  AnimationController? _controller;
  static var otp = "";
  bool _isLoading1 = false;
  bool _isLoading = false;

  // Variables
  Size? _screenSize;
  int? _currentDigit;
  String _firstDigit = '';
  String _secondDigit = '';
  String _thirdDigit = '';
  String _fourthDigit = '';
  String _fifthDigit = '';
  String _sixthDigit = '';

  Timer? timer;
  int? totalTimeInSeconds;
  bool? _hideResendButton;

  String userName = "";
  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;

  // Return "Verification Code" label
  get _getVerificationCodeLabel {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 50.0,
        left: 25,
        right: 25.0,
      ),
      child: const Text(
        'Enter the OTP sent to your registered mobile number',
        style: TextStyle(
            color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Return "Email" label

  // Return "OTP" input field
  get _getInputField {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
        _otpTextField(_fifthDigit),
        _otpTextField(_sixthDigit),
      ],
    );
  }

  // Returns "OTP" input part
  get _getInputPart {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _getVerificationCodeLabel,
        _getInputField,
        _hideResendButton! ? _getTimerText : _getResendButton,
        SizedBox(
          width: double.infinity,
          height: 77, // match_parent
          child: Padding(
            padding: const EdgeInsets.only(
              left: 23.0,
              right: 23.0,
              top: 20,
            ),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.black54),
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Verify Otp".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      sendOtp();
                      _isLoading = true;
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LoginScreen()),
                      // );
                    },
                  ),
          ),
        ),
        _getOtpKeyboard
      ],
    );
  }

  // Returns "Timer" label
  get _getTimerText {
    return Container(
      height: 32,
      child: new Offstage(
        offstage: !_hideResendButton!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.access_time),
            new SizedBox(
              width: 5.0,
            ),
            OtpTimer(_controller!, 15.0, Colors.black)
          ],
        ),
      ),
    );
  }

  // Returns "Resend" button
  get _getResendButton {
    return new InkWell(
      child: new Container(
        height: 32,
        width: 120,
        // decoration: BoxDecoration(
        //     color: Constants.primary.withOpacity(0.9),
        //     shape: BoxShape.rectangle,
        //     borderRadius: BorderRadius.circular(32)),
        alignment: Alignment.center,
        child: new Text(
          "Resend Code".toUpperCase(),
          style: new TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      onTap: () {
        khanresend();
        // Resend you OTP via API or anything
      },
    );
  }

  // Returns "Otp" keyboard
  get _getOtpKeyboard {
    return new Container(
        height: _screenSize!.width - 80,
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "1",
                      onPressed: () {
                        _setCurrentDigit(1);
                      }),
                  _otpKeyboardInputButton(
                      label: "2",
                      onPressed: () {
                        _setCurrentDigit(2);
                      }),
                  _otpKeyboardInputButton(
                      label: "3",
                      onPressed: () {
                        _setCurrentDigit(3);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "4",
                      onPressed: () {
                        _setCurrentDigit(4);
                      }),
                  _otpKeyboardInputButton(
                      label: "5",
                      onPressed: () {
                        _setCurrentDigit(5);
                      }),
                  _otpKeyboardInputButton(
                      label: "6",
                      onPressed: () {
                        _setCurrentDigit(6);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: "7",
                      onPressed: () {
                        _setCurrentDigit(7);
                      }),
                  _otpKeyboardInputButton(
                      label: "8",
                      onPressed: () {
                        _setCurrentDigit(8);
                      }),
                  _otpKeyboardInputButton(
                      label: "9",
                      onPressed: () {
                        _setCurrentDigit(9);
                      }),
                ],
              ),
            ),
            new Expanded(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new SizedBox(
                    width: 80.0,
                  ),
                  _otpKeyboardInputButton(
                      label: "0",
                      onPressed: () {
                        _setCurrentDigit(0);
                      }),
                  _otpKeyboardActionButton(
                      label: new Icon(
                        Icons.backspace,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_sixthDigit != '') {
                            _sixthDigit = '';
                          } else if (_fifthDigit != '') {
                            _fifthDigit = '';
                          } else if (_fourthDigit != '') {
                            _fourthDigit = '';
                          } else if (_thirdDigit != '') {
                            _thirdDigit = '';
                          } else if (_secondDigit != '') {
                            _secondDigit = '';
                          } else if (_firstDigit != '') {
                            _firstDigit = '';
                          }
                        });
                      }),
                ],
              ),
            ),
          ],
        ));
  }

  getJson() async {
    String value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value = pref1.getString("user_id")!;
    var uri = Uri.parse(
        '${Constants.baseUrl}customers/verification?user_id=' + value);
    print(otp);
    var request = http.MultipartRequest('POST', uri)..fields['code'] = otp;

    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': Constants.authToken,
    });

    var response = await request.send();
    if (response.statusCode == 200) print('Done!');

    final respStr = await response.stream.bytesToString();

    print(json.decode(respStr));

    return json.decode(respStr);
  }

  void sendOtp() async {
//    getJson();

    String _body = "";
    String values = "";

    try {
      // _isLoading = false;

      Map _data = await getJson();

      print(_data);

      Map<String, dynamic> dataMap = _data["data"];
      dataMap.keys.forEach((k) {
        values = (dataMap[k].toString());
        print(dataMap[k]);
      });

      _body = (_data['status']);

      // print(_data);

      if (_body == 'ERROR') {
        setState(() {
          _isLoading = false;
        });
        // print("$_data");
        showDialog(
            context: context,
            builder: (c) {
              return AlertDialog(
                title: const Text("oops"),
                content: Text(values),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"),
                  )
                ],
              );
            });
      } else {
        setState(() {
          _isLoading = false;
        });
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (c) {
              return AlertDialog(
                title: const Text('Verification Successfull'),
                content:
                    const Text("Now you can login with your new credentials"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                ],
              );
            });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      var title = e.toString();
      if (e is SocketException) title = 'No internet';
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(title),
//        content: Text(values),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"),
                  )
                ],
              ));
    }
  }

  Future<Map> _getJsonresend() async {
    String value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value = pref1.getString("user_id")!;
    Uri apiUrl =
        Uri.parse('${Constants.baseUrl}customers/resend_code?user_id=' + value);
    //Constants.restId;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    };

    http.Response response = await http.get(
      apiUrl,
      headers: headers,
    );

    return json.decode(response.body); // returns a List type
  }

  void khanresend() async {
//    getJson();

    String _body = "";
    String values = "";

    try {
      // _isLoading = false;

      Map _data = await _getJsonresend();

      print(_data);

      Map<String, dynamic> dataMap = _data["data"];
      dataMap.keys.forEach((k) {
        values = (dataMap[k].toString());
        print(dataMap[k]);
      });

      _body = (_data['status']);

      // print(_data);

      if (_body == 'ERROR') {
        setState(() {
          _isLoading = false;
        });
        // print("$_data");
        showDialog(
            context: context,
            builder: (c) {
              return AlertDialog(
                title: const Text("oops"),
                content: Text(values),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"),
                  )
                ],
              );
            });
      } else {
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (c) {
              return AlertDialog(
                title: const Text('Code sent Successfully'),
                content: const Text("Please check your email"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                ],
              );
            });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      var title = e.toString();
      if (e is SocketException) title = 'No internet';
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text(title),
//        content: Text(values),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Close"),
                  )
                ],
              ));
    }
  }

  // Overridden methods
  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton!;
              });
            }
          });
    _controller!
        .reverse(from: _controller!.value == 0.0 ? 1.0 : _controller!.value);
    _startCountdown();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
              height: 38,
            ),
            // Container(
            //     padding: const EdgeInsets.all(8.0), child: Text('YourAppTitle'))
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: new Container(
        width: _screenSize!.width,
//        padding: new EdgeInsets.only(bottom: 16.0),
        child: _getInputPart,
      ),
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(String digit) {
    return new Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      child: new Text(
        digit != "" ? digit.toString() : "",
        style: new TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
//            color: Colors.grey.withOpacity(0.4),
          border: Border(
              bottom: BorderSide(
        width: 2.0,
        color: Constants.primary,
      ))),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton(
      {required String label, required VoidCallback onPressed}) {
    return new Material(
      color: Colors.transparent,
      child: new InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(40.0),
        child: new Container(
          height: 80.0,
          width: 80.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: new Center(
            child: new Text(
              label,
              style: new TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton(
      {required Widget label, required VoidCallback onPressed}) {
    return new InkWell(
      onTap: onPressed,
      borderRadius: new BorderRadius.circular(40.0),
      child: new Container(
        height: 80.0,
        width: 80.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: new Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == '') {
        _firstDigit = _currentDigit.toString();
      } else if (_secondDigit == '') {
        _secondDigit = _currentDigit.toString();
      } else if (_thirdDigit == '') {
        _thirdDigit = _currentDigit.toString();
      } else if (_fourthDigit == '') {
        _fourthDigit = _currentDigit.toString();
      } else if (_fifthDigit == '') {
        _fifthDigit = _currentDigit.toString();
      } else if (_sixthDigit == '') {
        _sixthDigit = _currentDigit.toString();

        otp = _firstDigit.toString() +
            _secondDigit.toString() +
            _thirdDigit.toString() +
            _fourthDigit.toString() +
            _fifthDigit.toString() +
            _sixthDigit.toString();

        //   print(otp);

        // Verify your otp by here. API call
      }
    });
  }

  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller!
        .reverse(from: _controller!.value == 0.0 ? 1.0 : _controller!.value);
  }

  void clearOtp() {
    _sixthDigit = '';
    _fifthDigit = '';
    _fourthDigit = '';
    _thirdDigit = '';
    _secondDigit = '';
    _firstDigit = '';
    setState(() {});
  }
}

class OtpTimer extends StatelessWidget {
  final AnimationController controller;
  double fontSize;
  Color timeColor = Constants.primary;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
    Duration duration = controller.duration! * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
    Duration duration = controller.duration!;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget? child) {
          return Text(
            timerString,
            style: new TextStyle(
                fontSize: fontSize,
                color: timeColor,
                fontWeight: FontWeight.w600),
          );
        });
  }
}
