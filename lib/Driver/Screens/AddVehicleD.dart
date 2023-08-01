import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Addvehicle extends StatefulWidget {
  @override
  _AddvehicleState createState() => _AddvehicleState();
}

class _AddvehicleState extends State<Addvehicle> {
  final _formKey = GlobalKey<FormState>();

  DateTime registrationDate = DateTime.now();
  DateTime registrationExpiryDate = DateTime.now();
  DateTime licenseIssuanceDate = DateTime.now();
  DateTime licenseExpiryDate = DateTime.now();
  DateTime passportIssuance = DateTime.now();
  DateTime passportExpiry = DateTime.now();
  DateTime visaIssuance = DateTime.now();
  DateTime visaExpiry = DateTime.now();

  bool apiCalled = false;
  bool loading = false;
  bool checkboxValueA = true;
  bool checkboxValueB = false;
  bool? checkboxValueC;
  int radioValue = 0;
  bool switchValue = false;
  String result = '';
  bool _isLoading = false;
  bool _isLoading1 = false;

  File? _image;
  TextEditingController _registraionNo = TextEditingController();
  TextEditingController _licenseNo = TextEditingController();
  TextEditingController _phoneNo1 = TextEditingController();
  TextEditingController _phoneNo2 = TextEditingController();
  TextEditingController _phoneNo3 = TextEditingController();
  TextEditingController _phoneNo4 = TextEditingController();
  TextEditingController _phoneNo5 = TextEditingController();
  TextEditingController _phoneNo6 = TextEditingController();

  List<File> _imgs = [];
  List<File> _imgsLicense = [];
  List<File> _imgsVisa = [];
  List<File> _imgsPassport = [];
  //
  List<String> imagesName = [];
  List<String> imagesNameLicense = [];
  List<String> imagesNameVisa = [];
  List<String> imagesNamePassport = [];

  bool isVideo = false;
  List<Asset> images = [];
  List<Asset> imagesLicense = [];
  List<Asset> imagesVisa = [];
  List<Asset> imagesPassport = [];
  String _error = 'No Error Dectected';

  bool _isLoadingsave = false;

  var frontBaseName = "";

  var backBaseName = "";

  var profileBaseName = "";

  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkAndRequestCameraPermissions();
  }

  Future<bool> checkAndRequestCameraPermissions() async {
    var permission = await Permission.storage.status;

    if (permission.isGranted) {
      // Either the permission was already granted before or the user just granted it.
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
        Permission.storage,
      ].request();
      print(statuses[Permission.location]);
      return permission == PermissionStatus.granted;
    } else {
      return true;
    }
  }

  Future<Null> _registrationDatef(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: registrationDate,
        firstDate: DateTime(2000, 8),
        lastDate: DateTime(2024));
    if (picked != null && picked != registrationDate)
      setState(() {
        registrationDate = picked;
      });
  }

  Future<Null> _registrationExpiryDatef(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: registrationExpiryDate,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2050));
    if (picked != null && picked != registrationExpiryDate)
      setState(() {
        registrationExpiryDate = picked;
      });
  }

  Future<Null> _licenseIssuanceDatef(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: licenseIssuanceDate,
        firstDate: DateTime(2000, 8),
        lastDate: DateTime(2021));
    if (picked != null && picked != licenseIssuanceDate)
      setState(() {
        licenseIssuanceDate = picked;
      });
  }

  Future<Null> licenseExpiryDatef(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: licenseExpiryDate,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2050));
    if (picked != null && picked != licenseExpiryDate)
      setState(() {
        licenseExpiryDate = picked;
      });
  }

  Future<Null> _passportIssuancef(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: passportIssuance,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2050));
    if (picked != null && picked != passportIssuance)
      setState(() {
        passportIssuance = picked;
      });
  }

  Future<Null> _passportExpiryf(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: passportExpiry,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2050));
    if (picked != null && picked != passportExpiry)
      setState(() {
        passportExpiry = picked;
      });
  }

  Future<Null> _visaIssuancef(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: visaIssuance,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2050));
    if (picked != null && picked != visaIssuance)
      setState(() {
        visaIssuance = picked;
      });
  }

  Future<Null> _visaExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: visaExpiry,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2050));
    if (picked != null && picked != visaExpiry)
      setState(() {
        visaExpiry = picked;
      });
  }

  Future<Map> sendApiRequest() async {
    String _userId = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();

    _userId = pref1.getString("user_id")!;

    // string to uri
    var uri = Uri.parse(
        '${Constants.baseUrl}vehicle/add_vehicle_process_one?user_id=14');

    var request = new http.MultipartRequest("POST", uri);

    //vechile registration
    List<MultipartFile> newList = [];
    for (int i = 0; i < _imgs.length; i++) {
      var stream =
           http.ByteStream(DelegatingStream.typed(_imgs[i].openRead()));
      print(imagesName[i].toString() + _imgs[i].path);
      var length = await _imgs[i].length();
      var multipartFile =  http.MultipartFile("reg_images[]", stream, length,
          filename: imagesName[i]);
      newList.add(multipartFile);
    }

//License

    List<MultipartFile> newLicense = [];
    for (int i = 0; i < _imgsLicense.length; i++) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imgsLicense[i].openRead()));
      print(imagesNameLicense[i].toString() + _imgsLicense[i].path);
      var length = await _imgsLicense[i].length();
      var multipartFileLicense = new http.MultipartFile(
          "licence_images[]", stream, length,
          filename: imagesNameLicense[i]);
      newList.add(multipartFileLicense);
    }

//passport

    List<MultipartFile> newPassport = [];
    for (int i = 0; i < _imgsPassport.length; i++) {
      var stream = new http.ByteStream(
          DelegatingStream.typed(_imgsPassport[i].openRead()));
      print(imagesNamePassport[i].toString() + _imgsPassport[i].path);
      var length = await _imgsPassport[i].length();
      var multipartFilePassport = new http.MultipartFile(
          "passport_images[]", stream, length,
          filename: imagesNamePassport[i]);
      newList.add(multipartFilePassport);
    }

// visa

    List<MultipartFile> newVisa = [];
    for (int i = 0; i < _imgsVisa.length; i++) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(_imgsVisa[i].openRead()));
      print(imagesNameVisa[i].toString() + _imgsVisa[i].path);
      var length = await _imgsVisa[i].length();
      var multipartFileVisa = new http.MultipartFile(
          "visa_images[]", stream, length,
          filename: imagesNameVisa[i]);
      newList.add(multipartFileVisa);
    }

    request.fields['reg_no'] = _registraionNo.text;
    request.fields['reg_date'] = "${registrationDate.toLocal()}".split(' ')[0];
    request.fields['exp_date'] =
        "${registrationExpiryDate.toLocal()}".split(' ')[0];
    request.fields['licence_no'] = _licenseNo.text;
    request.fields['licence_issue_date'] =
        "${licenseIssuanceDate.toLocal()}".split(' ')[0];
    request.fields['licence_exp_date'] =
        "${licenseExpiryDate.toLocal()}".split(' ')[0];
    request.fields['passport_issue_date'] =
        "${passportIssuance.toLocal()}".split(' ')[0];
    request.fields['passport_exp_date'] =
        "${passportExpiry.toLocal()}".split(' ')[0];
    request.fields['visa_issue_date'] =
        "${visaIssuance.toLocal()}".split(' ')[0];
    request.fields['visa_exp_date'] = "${visaExpiry.toLocal()}".split(' ')[0];
    request.fields['phone_number_1'] = _phoneNo1.text;
    request.fields['phone_number_2'] = _phoneNo2.text;
    request.fields['phone_number_3'] = _phoneNo3.text;
    request.fields['phone_number_4'] = _phoneNo4.text;
    request.fields['phone_number_5'] = _phoneNo5.text;
    request.fields['phone_number_6'] = _phoneNo6.text;
    request.files.addAll(newList);
    request.files.addAll(newLicense);
    request.files.addAll(newPassport);
    request.files.addAll(newVisa);

    // get file length

    String token = Constants.authToken;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "" + token
    }; // ignore this headers if there is no authentication
    //request.fields['first_name'] = firstnameController.text;
    request.headers.addAll(headers);

    // send
    var response = await request.send();

    if (response.statusCode == 200) print('Done!');

    final respStr = await response.stream.bytesToString();

    return json.decode(respStr);
  }

//Response getter
  void responseGetter() async {
    String _body = "";
    String values = "";

    try {
      final Map _data = await sendApiRequest();
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
          _isLoading1 = false;
          _isLoadingsave = false;
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
          _isLoading1 = false;
          _isLoadingsave = false;
        });
        messageAllert('Vechile details added successfully', 'Congratulation');
      }
    } catch (e) {
      setState(() {
        _isLoading1 = false;
        _isLoadingsave = false;
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

  messageAllert(String msg, String ttl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: false,
                child: const Column(
                  children: <Widget>[
                    Text('Okay'),
                  ],
                ),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        });
  }

  String? _selectedPackageCategory;

  String? _selectedPackageType;

  List type = [];
  List categories = [];

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.only(top: 12.0, left: 15.0),
                child: Text(
                  'Add Vehicle',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28.0, left: 25.0, right: 20),
            child: Text(
              'Add vehicle details'.toUpperCase(),
              style: const TextStyle(
                  color: Color(0xff1fa2f2),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 20),
            child: Text(
              'Registration Number'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 2),
            child: Card(
              elevation: 3.0,
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      hintText: "Enter Registration Number",
                      hintStyle: const TextStyle(fontSize: 15.0, color: Colors.grey),
                    ),
                    maxLines: 1,
                    controller: _registraionNo,
                    validator: (value) {
                      if (value!.length > 0) return null;
                      return 'This field is required';
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Registration Date'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 13.0, right: 15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),


              onPressed: () {
                _registrationDatef(context);
                print(registrationDate);

                print("${registrationDate.toLocal()}".split(' ')[0]);
              },



              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.date_range,
                                size: 18.0,
                                color: Colors.teal,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "${registrationDate.toLocal()}".split(' ')[0],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Text(
                      "Registration Date",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Registration Expiry Date'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 13.0, right: 15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),



              onPressed: () {
                _registrationExpiryDatef(context);
                print(registrationDate);

                print("${registrationExpiryDate.toLocal()}".split(' ')[0]);
              },



              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.date_range,
                                size: 18.0,
                                color: Colors.teal,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "${registrationExpiryDate.toLocal()}"
                                      .split(' ')[0],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Text(
                      "Expiry Date",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Vehicle Registration images'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: Text(
              '(Images must be from two sides)',
              style: TextStyle(
                  color: Constants.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Container(
                height: _imgs.length > 0 ? 200 : 0,
                width: double.infinity,
                child: buildGridView()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 15, top: 7),
            child: new Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Upload',
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ElevatedButton(
                        //minSize: 5,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text(
                          'Choose',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          vechileRegistrationloadAssets();
                        }),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Driver License Details'.toUpperCase(),
              style: const TextStyle(
                  color: Color(0xff1fa2f2),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Driver license number'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
            child: Card(
              elevation: 3.0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter Driver license number",
                    hintStyle: const TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  // obscureText: true,
                  controller: _licenseNo,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'License issuance date'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 13.0, right: 15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4),




                  
              onPressed: () {
                _registrationDatef(context);
                print(registrationDate);

                print("${licenseIssuanceDate.toLocal()}".split(' ')[0]);
              },





              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.date_range,
                                size: 18.0,
                                color: Colors.teal,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "${licenseIssuanceDate.toLocal()}"
                                      .split(' ')[0],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Text(
                      "Issuance Date",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'License Expiry date'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 13.0, right: 15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),




              onPressed: () {
                _registrationExpiryDatef(context);
                print(registrationDate);

                print("${licenseExpiryDate.toLocal()}".split(' ')[0]);
              },


              
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.date_range,
                                size: 18.0,
                                color: Colors.teal,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "${licenseExpiryDate.toLocal()}"
                                      .split(' ')[0],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Text(
                      "Expiry Date",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Driving License Images'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: Text(
              '(Images must be from two sides)',
              style: TextStyle(
                  color: Constants.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Container(
                height: _imgsLicense.length > 0 ? 200 : 0,
                width: double.infinity,
                child: buildGridViewLicense()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 15, top: 7),
            child: new Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Upload',
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ElevatedButton(
                        //minSize: 5,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primary,
                        ),
                        child: const Text(
                          'Choose',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          vechilelicenseloadAssets();
                        }),
                  )
                ],
              ),
            ),
          ),

//passport copyyy

          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Passport Details'.toUpperCase(),
              style: const TextStyle(
                  color: Color(0xff1fa2f2),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Passport issuance date'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 13.0, right: 15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4.0,
              ),
              onPressed: () {
                _passportIssuancef(context);
                print(registrationDate);

                print("${passportIssuance.toLocal()}".split(' ')[0]);
              },
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.date_range,
                                size: 18.0,
                                color: Colors.teal,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "${passportIssuance.toLocal()}".split(' ')[0],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Text(
                      "Issuance Date",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Passport expiry date'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 13.0, right: 15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 4.0),
              onPressed: () {
                _passportExpiryf(context);
                print(registrationDate);

                print("${passportExpiry.toLocal()}".split(' ')[0]);
              },
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.date_range,
                                size: 18.0,
                                color: Colors.teal,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "${passportExpiry.toLocal()}".split(' ')[0],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Text(
                      "Expiry Date",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Passport Images'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: Text(
              '(Images must be from two sides)',
              style: TextStyle(
                  color: Constants.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Container(
                height: _imgsPassport.length > 0 ? 200 : 0,
                width: double.infinity,
                child: buildGridViewPassport()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 15, top: 7),
            child: new Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Upload',
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ElevatedButton(
                        //minSize: 5,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primary,
                        ),
                        child: const Text(
                          'Choose',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          passportLoadAssets();
                        }),
                  )
                ],
              ),
            ),
          ),

          // vissa copy
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Driver Visa Details'.toUpperCase(),
              style: const TextStyle(
                  color: Color(0xff1fa2f2),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Visa issuance date'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 13.0, right: 15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                _visaIssuancef(context);
                print(registrationDate);

                print("${visaIssuance.toLocal()}".split(' ')[0]);
              },
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.date_range,
                                size: 18.0,
                                color: Colors.teal,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "${visaIssuance.toLocal()}".split(' ')[0],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Text(
                      "Issuance Date",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Visa Expiry date'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 13.0, right: 15.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4.0),
              onPressed: () {
                _visaExpiryDate(context);
                print(registrationDate);

                print("${visaExpiry.toLocal()}".split(' ')[0]);
              },
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.date_range,
                                size: 18.0,
                                color: Colors.teal,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text(
                                  "${visaExpiry.toLocal()}".split(' ')[0],
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Text(
                      "Expiry Date",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Visa  Images'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: Text(
              '(Images must be from two sides)',
              style: TextStyle(
                  color: Constants.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: Container(
                height: _imgsVisa.length > 0 ? 200 : 0,
                width: double.infinity,
                child: buildGridViewVisa()),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 15, top: 7),
            child: new Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(3.5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Upload',
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: ElevatedButton(
                        //minSize: 5,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Constants.primary,
                        ),
                        child: const Text(
                          'Choose',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          visaLoadAssets();
                        }),
                  )
                ],
              ),
            ),
          ),

//phone numbers

          Padding(
            padding: const EdgeInsets.only(top: 28.0, left: 25.0, right: 20),
            child: Text(
              'Driver Phone Numbers'.toUpperCase(),
              style: const TextStyle(
                  color: Color(0xff1fa2f2),
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 26.0),
            child: Text(
              '(Enter phone numbers upto 6) ',
              style: TextStyle(
                  color: Constants.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 20),
            child: Text(
              'Phone Number 1'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 2),
            child: Card(
              elevation: 3.0,
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter Phone Number",
                    hintStyle: const TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  controller: _phoneNo1,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 20),
            child: Text(
              'Phone Number 2'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 2),
            child: Card(
              elevation: 3.0,
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter Phone Number",
                    hintStyle: const TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  controller: _phoneNo2,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 20),
            child: Text(
              'Phone Number 3'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 2),
            child: Card(
              elevation: 3.0,
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter Phone Number",
                    hintStyle: const TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  controller: _phoneNo3,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 20),
            child: Text(
              'Phone Number 4'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 2),
            child: Card(
              elevation: 3.0,
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter Phone Number",
                    hintStyle: const TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  controller: _phoneNo4,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 20),
            child: Text(
              'Phone Number 5'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 2),
            child: Card(
              elevation: 3.0,
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter Phone Number",
                    hintStyle: const TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  controller: _phoneNo5,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 20),
            child: Text(
              'Phone Number 6'.toUpperCase(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 2),
            child: Card(
              elevation: 3.0,
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "Enter Phone Number",
                    hintStyle: const TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  controller: _phoneNo6,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 77, // match_parent
            child: Padding(
              padding: const EdgeInsets.only(
                // left: 05.0,
                // right: 05.0,
                top: 20,
              ),
              child: _isLoadingsave
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(10.0),
                      // ),

                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1fa2f2)),

                      child: Text(
                        "next".toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isLoadingsave = true;
                          responseGetter();
                        });
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      physics: new NeverScrollableScrollPhysics(),
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Stack(
          children: <Widget>[
            AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            ),
            Positioned(
                right: 5,
                top: 5,
                child: InkWell(
                    child: const Icon(
                      Icons.remove_circle_outline,
                      size: 30,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        imagesName.removeAt(index);
                        _imgs.removeAt(index);
                        //   print(_imgs.length.toString());
                        images.removeAt(index);
                      });
                    }))
          ],
        );
      }),
    );
  }

  Future<void> vechileRegistrationloadAssets() async {
    List<Asset> resultList = [];
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        selectedAssets: images,
        //cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: const Color(0xffabcdef),
          actionBarTitle: Constants.appname,
          maxImages: 4,
          enableCamera: true,
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: const Color(0xff000000),
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;

      _error = error;
    });

    //here convert assests to file  which help to upload images
    for (var result in resultList) {
      String? path = await LecleFlutterAbsolutePath.getAbsolutePath(
          uri: result.identifier);
      File file = File(path!);
      String fileName = file.path.split('/').last;
      imagesName.add(fileName);
      _imgs.add(File(path));
    }
  }

  Future<void> vechilelicenseloadAssets() async {
    List<Asset> resultList1 = [];
    String error = 'No Error Dectected';

    try {
      resultList1 = await MultiImagePicker.pickImages(
        selectedAssets: images,
        //cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: const Color(0xffabcdef),
          actionBarTitle: Constants.appname,
          maxImages: 4,
          enableCamera: true,
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: const Color(0xff000000),
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      imagesLicense = resultList1;

      _error = error;
    });

    //here convert assests to file  which help to upload images
    for (var result in resultList1) {
      String? path = await LecleFlutterAbsolutePath.getAbsolutePath(
          uri: result.identifier);
      File file = File(path!);
      String fileName = file.path.split('/').last;
      imagesNameLicense.add(fileName);
      _imgsLicense.add(File(path));
    }
  }

  Widget buildGridViewLicense() {
    return GridView.count(
      crossAxisCount: 3,
      physics: new NeverScrollableScrollPhysics(),
      children: List.generate(imagesLicense.length, (index) {
        Asset asset = imagesLicense[index];
        return Stack(
          children: <Widget>[
            AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            ),
            Positioned(
                right: 5,
                top: 5,
                child: InkWell(
                    child: const Icon(
                      Icons.remove_circle_outline,
                      size: 30,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        imagesNameLicense.removeAt(index);
                        _imgsLicense.removeAt(index);
                        //   print(_imgs.length.toString());
                        imagesLicense.removeAt(index);
                      });
                    }))
          ],
        );
      }),
    );
  }

  //visa

  Future<void> visaLoadAssets() async {
    List<Asset> resultList1 = [];
    String error = 'No Error Dectected';

    try {
      resultList1 = await MultiImagePicker.pickImages(
        selectedAssets: images,
        //cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: const Color(0xffabcdef),
          actionBarTitle: Constants.appname,
          maxImages: 4,
          enableCamera: true,
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: const Color(0xff000000),
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      imagesVisa = resultList1;

      _error = error;
    });

    //here convert assests to file  which help to upload images
    for (var result in resultList1) {
      String? path = await LecleFlutterAbsolutePath.getAbsolutePath(
          uri: result.identifier);

      File file = File(path!);
      String fileName = file.path.split('/').last;
      imagesNameVisa.add(fileName);
      _imgsVisa.add(File(path));
    }
  }

  Widget buildGridViewVisa() {
    return GridView.count(
      crossAxisCount: 3,
      physics: new NeverScrollableScrollPhysics(),
      children: List.generate(imagesVisa.length, (index) {
        Asset asset = imagesVisa[index];
        return Stack(
          children: <Widget>[
            AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            ),
            Positioned(
                right: 5,
                top: 5,
                child: InkWell(
                    child: const Icon(
                      Icons.remove_circle_outline,
                      size: 30,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        imagesNameVisa.removeAt(index);
                        _imgsVisa.removeAt(index);
                        //   print(_imgs.length.toString());
                        imagesVisa.removeAt(index);
                      });
                    }))
          ],
        );
      }),
    );
  }

  //passport

  Future<void> passportLoadAssets() async {
    List<Asset> resultList1 = [];
    String error = 'No Error Dectected';

    try {
      resultList1 = await MultiImagePicker.pickImages(
        selectedAssets: images,
        //cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: const Color(0xffabcdef),
          actionBarTitle: Constants.appname,
          maxImages: 4,
          enableCamera: true,
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: const Color(0xff000000),
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      imagesPassport = resultList1;

      _error = error;
    });

    //here convert assests to file  which help to upload images
    for (var result in resultList1) {
      String? path = await LecleFlutterAbsolutePath.getAbsolutePath(
          uri: result.identifier);
      File file = File(path!);
      String fileName = file.path.split('/').last;
      imagesNamePassport.add(fileName);
      _imgsPassport.add(File(path));
    }
  }

  Widget buildGridViewPassport() {
    return GridView.count(
      crossAxisCount: 3,
      physics: new NeverScrollableScrollPhysics(),
      children: List.generate(imagesPassport.length, (index) {
        Asset asset = imagesPassport[index];
        return Stack(
          children: <Widget>[
            AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            ),
            Positioned(
                right: 5,
                top: 5,
                child: InkWell(
                    child: const Icon(
                      Icons.remove_circle_outline,
                      size: 30,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        imagesNamePassport.removeAt(index);
                        _imgsPassport.removeAt(index);
                        //   print(_imgs.length.toString());
                        imagesPassport.removeAt(index);
                      });
                    }))
          ],
        );
      }),
    );
  }
}
