import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:runnerz/Customer/screens/packagess/PackageFromHome/packageSelectorHome.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../coupon_on_map.dart';
import 'CreditCard.dart';

class AddPackageOne extends StatefulWidget {
  final String? identifier;
  final bool? home;
  final String? farePrice;
  final String? amount;
  final String? pickUpLocation;
  final String? dropLocation;
  final double? dropLat;
  final double? dropLng;
  final double? pickLat;
  final double? pickLng;

  AddPackageOne({
    this.identifier,
    this.home,
    this.farePrice,
    this.amount,
    this.pickUpLocation,
    this.dropLocation,
    this.dropLat,
    this.dropLng,
    this.pickLat,
    this.pickLng,
  });
  @override
  _AddPackageOneState createState() => _AddPackageOneState();
}

class _AddPackageOneState extends State<AddPackageOne> {
  //data members
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
  bool _isLoadingsave = false;
  TextEditingController _name = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _weight = TextEditingController();
  TextEditingController _length = TextEditingController();
  TextEditingController _height = TextEditingController();
  TextEditingController _width = TextEditingController();
  TextEditingController _measurmentType = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _comment = TextEditingController();
  String? paymentSelector;

  String identifier = '';
  String responseDynamic = "";

  List<String> sizeAttributes = [
    'CM',
    'Meter',
    'Inches',
  ]; // Option 2
  String _selectedMeasurment = 'CM';
  List<String> payment = [
    'Credit card',
    'Cash on delivery',
  ];

  File? _image;

  List<File> _imgs = [];
  List<String> imagesName = [];

  bool isVideo = false;
  List<Asset> images = [];
  String _error = 'No Error Dectected';

  var frontBaseName = "";

  var backBaseName = "";

  var profileBaseName = "";

  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  //Functions

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

  //api for geting the identifier from home and send

  Future<Map> sendIdentifierFromHome() async {
    String _userId = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();

    _userId = pref1.getString("user_id")!;

    // string to uri
    var uri = Uri.parse(Constants.baseUrl +
        'packages/add_package_order_FromFront?user_id=' +
        _userId);

    var request = http.MultipartRequest("POST", uri);

    request.fields['name'] = _name.text;

    request.fields['mobile'] = _mobile.text;
    request.fields['payment_type'] = paymentSelector!;
    request.fields['identifier'] = widget.identifier!;

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

  void apiResponsefromhome() async {
//    getJson();
    String _body = "";

    try {
      Map _data = await getJson();
      // print(_data);

      Map<String, dynamic> dataMap = _data["data"];
      dataMap.keys.forEach((k) {
        responseDynamic = (dataMap[k].toString());
        //  print(dataMap[k]);
      });

      _body = (_data['status']);

      if (_body == 'ERROR') {
        setState(() {
          _isLoading = false;
        });
        print("error");

        messageAllert('$responseDynamic', 'Oops');
      } else {
        print('success');
        identifier = _data['identifier'];

        SharedPreferences pref1 = await SharedPreferences.getInstance();
        pref1.setString("identifier", _data['identifier']);
        responseGetter();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingsave = false;
      });
      var error = e.toString();
      if (e is SocketException) error = 'No internet';

      messageAllert('$error', 'Oops');
    }
  }

//api for geting the identifier

  Future<Map> getJson() async {
    String _userId = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();

    _userId = pref1.getString("user_id")!;

    // string to uri
    var uri = Uri.parse(
        Constants.baseUrl + 'packages/add_package_order?user_id=' + _userId);

    var request = http.MultipartRequest("POST", uri);

    request.fields['name'] = _name.text;
    request.fields['mobile'] = _mobile.text;
    request.fields['payment_type'] = paymentSelector!;

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

  void apiForIdentifier() async {
//    getJson();
    String _body = "";

    try {
      Map _data = await getJson();
      // print(_data);

      Map<String, dynamic> dataMap = _data["data"];
      dataMap.keys.forEach((k) {
        responseDynamic = (dataMap[k].toString());
        print(dataMap[k]);
      });

      _body = (_data['status']);

      if (_body == 'ERROR') {
        setState(() {
          _isLoading = false;
        });
        print("error");

        messageAllert('$responseDynamic', 'Oops');
      } else {
        print('success');
        identifier = _data['identifier'];

        SharedPreferences pref1 = await SharedPreferences.getInstance();
        pref1.setString("identifier", _data['identifier']);
        responseGetter();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingsave = false;
      });
      var error = e.toString();
      if (e is SocketException) error = 'No internet';

      messageAllert('$error', 'Oops');
    }
  }

  //Api for sending form data

  Future<Map> sendApiRequest() async {
    String _userId = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();

    _userId = pref1.getString("user_id")!;

    // string to uri
    var uri = Uri.parse(Constants.baseUrl +
        'packages/add_package_process_one?user_id=' +
        _userId);

    var request = http.MultipartRequest("POST", uri);

    List<MultipartFile> newList = [];
    for (int i = 0; i < _imgs.length; i++) {
      var stream =
          // ignore: deprecated_member_use
          http.ByteStream(DelegatingStream.typed(_imgs[i].openRead()));
      print(imagesName[i].toString() + _imgs[i].path);
      var length = await _imgs[i].length();
      var multipartFile = http.MultipartFile("photos[]", stream, length,
          filename: imagesName[i]);
      newList.add(multipartFile);
    }

    // request.fields['name'] = _name.text;
    request.fields['identifier'] = identifier;
    //request.fields['mobile'] = _mobile.text;
    request.fields['category_id'] = _selectedPackageCategory!;
    request.fields['type_id'] = _selectedPackageType!;
    request.fields['weight'] = _weight.text;
    request.fields['length'] = _length.text;
    request.fields['height'] = _height.text;
    request.fields['width'] = _width.text;
    request.fields['measurement_type'] = _selectedMeasurment;
    request.fields['description'] = _description.text;
    request.fields['handle_with_care'] = result;
    request.fields['comment'] = _comment.text;
    request.fields['comment'] = _comment.text;
    request.files.addAll(newList);

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

  void responseGetter() async {
//    getJson();

    String _body = "";
    String values = "";

    try {
      // _isLoading = false;
      // if (_image != null) {
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
        messageAllert('$values', 'Oops');
      } else {
        SharedPreferences pref1 = await SharedPreferences.getInstance();
        pref1.setString("package_id", _data['package_id']);
        setState(() {
          _isLoading1 = false;
          _isLoadingsave = false;
        });

        apiForRideAdding();
      }
    } catch (e) {
      setState(() {
        _isLoading1 = false;
        _isLoadingsave = false;
      });
      var title = e.toString();
      if (e is SocketException) title = 'No internet';
      messageAllert('$title', 'Oops');
    }
  }

  messageAllert(String msg, String ttl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(ttl),
            content: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(msg),
            ),
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

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;

      switch (radioValue) {
        case 0:
          result = '1';
          print(result);
          break;
        case 1:
          result = '0';
          print(result);
          break;

        default:
          print("Nothing selected!");
      }
    });
  }

  String? _selectedPackageCategory;

  String? _selectedPackageType;

  List type = [];
  List categories = [];

  Future<Map> _getJsonForDropDowns() async {
    Uri apiUrl = Uri.parse(Constants.baseUrl + 'packages/package_type_and_cat');

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

  void dropDownList() async {
    setState(() {
      apiCalled = true;
      loading = true;
    });
//    getJson();

    String _body = "";
    String values = "";

    try {
      // _isLoading = false;

      Map _data = await _getJsonForDropDowns();

      type = _data["ptype"];
      categories = _data["pcat"];

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
          loading = false;
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
          print('dropdown Success');
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        loading = false;
      });
    }
  }

  //api for adding to ride

  Future<Map> getRideJson() async {
    String _userId = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();

    _userId = pref1.getString("user_id")!;

    // string to uri
    var uri = Uri.parse(
        Constants.baseUrl + 'packages/add_to_ride?user_id=' + _userId);

    var request = http.MultipartRequest("POST", uri);

    request.fields['identifier'] = identifier;

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

  void apiForRideAdding() async {
//    getJson();
    String _body = "";

    try {
      Map _data = await getRideJson();
      print(_data);

      Map<String, dynamic> dataMap = _data["data"];
      dataMap.keys.forEach((k) {
        responseDynamic = (dataMap[k].toString());
        print(dataMap[k]);
      });

      _body = (_data['status']);

      if (_body == 'ERROR') {
        setState(() {
          _isLoading = false;
        });
        print("error");

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0)), //this right here
                child: Container(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 15),
                        Container(
                          height: 50,
                          width: 50,
                          child: ClipOval(
                            child: Material(
                              color: Colors.red, // button color
                              child: InkWell(
                                splashColor: Colors.blue, // inkwell color
                                child: const SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 40,
                                    )),
                                onTap: () {},
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'oops'.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(responseDynamic),
                        const SizedBox(height: 20),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Constants.primary,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "Close",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      } else {
        setState(() {
          _isLoading1 = false;
          _isLoadingsave = false;
        });
        if (paymentSelector == 'Cash on delivery') {
          // if (widget.home == true) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (BuildContext context) {
          //         return CouponMap(
          //           farePrice: widget.farePrice,
          //           pickUpLocation: widget.pickUpLocation,
          //           dropLocation: widget.dropLocation,
          //           dropLat: widget.dropLat,
          //           dropLng: widget.dropLng,
          //           amount: widget.amount,
          //           pickLat: widget.pickLat,
          //           pickLng: widget.pickLng,
          //         );
          //       },
          //     ),
          //   );
          // } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PackageSelectorHome()),
          );
          //  }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreditCard()),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingsave = false;
      });
      var error = e.toString();
      if (e is SocketException) error = 'No internet';

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 230,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 15),
                      Container(
                        height: 50,
                        width: 50,
                        child: ClipOval(
                          child: Material(
                            color: Colors.red, // button color
                            child: InkWell(
                              splashColor: Colors.red, // inkwell color
                              child: const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 40,
                                  )),
                              onTap: () {},
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'oopss'.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        error,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Constants.primary,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Ok",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!apiCalled) {
      Future.delayed(const Duration(milliseconds: 2), () {
        dropDownList();
      });
    }
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          //shrinkWrap: true,
          children: <Widget>[
            Container(
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
                  'Add A Package Delivery Request',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 28.0, left: 25.0, right: 20),
                    child: Text(
                      'Contact person'.toUpperCase(),
                      style: const TextStyle(
                          color: Color(0xff1fa2f2),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 25.0, right: 20),
                    child: Text(
                      'Name'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20.0, top: 2),
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
                          validator: (value) {
                            if (value!.length > 0) return null;
                            return 'This field is required';
                          },
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
                            hintText: "Enter Name",
                            hintStyle: const TextStyle(
                                fontSize: 15.0, color: Colors.grey),
                          ),
                          maxLines: 1,
                          controller: _name,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
                    child: Text(
                      'Mobile Number'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
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
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.length > 0) return null;
                            return 'This field is required';
                          },
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
                            hintText: "Mobile Number.",
                            hintStyle: const TextStyle(
                                fontSize: 15.0, color: Colors.grey),
                          ),
                          maxLines: 1,
                          // obscureText: true,
                          controller: _mobile,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
                    child: Text(
                      'Package Details'.toUpperCase(),
                      style: const TextStyle(
                          color: Color(0xff1fa2f2),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 17.0, left: 25.0, right: 20),
                    child: Text(
                      'Package Category'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
            
                  loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 2.0),
                          child: Card(
                            elevation: 3.0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: const Text('Select Category'),
                                    style: const TextStyle(
                                        color: Colors
                                            .blue), // Not necessary for Option 1
                                    value: _selectedPackageCategory,
                                    onChanged: (newValue) {
                                      setState(() {
                                        FocusScope.of(context).unfocus();
            
                                        _selectedPackageCategory = newValue;
                                        print(_selectedPackageCategory);
                                      });
                                    },
                                    items: categories.map((location) {
                                      return DropdownMenuItem(
                                        child: Text(location['name']),
                                        value: location['id'].toString(),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 17.0, right: 20, left: 25.0),
                    child: Text(
                      'Package Type'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  loading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 2.0),
                          child: Card(
                            elevation: 3.0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: const Text('Select Type'),
                                    style: const TextStyle(
                                        color: Colors
                                            .blue), // Not necessary for Option 1
                                    value: _selectedPackageType,
                                    onChanged: (newValue) {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        _selectedPackageType = newValue;
                                        print(_selectedPackageType);
                                      });
                                    },
                                    items: type.map((location) {
                                      return DropdownMenuItem(
                                        child: Text(location['type_name']),
                                        value: location['id'].toString(),
                                      );
                                    }).toList(),
                                    // items: packageType.map((location) {
                                    //   return DropdownMenuItem(
                                    //     child: new Text(location),
                                    //     value: location,
                                    //   );
                                    // }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 17.0, left: 25.0, right: 20),
                    child: Text(
                      'Package Weight'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 2.0),
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
            
                          validator: (value) {
                            if (value!.length > 0) return null;
                            return 'This field is required';
                          },
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
                            hintText: "Weight in KG",
                            hintStyle: const TextStyle(
                                fontSize: 15.0, color: Colors.grey),
                          ),
                          maxLines: 1,
                          // obscureText: true,
                          keyboardType: TextInputType.number,
            
                          controller: _weight,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 17.0, left: 25.0, right: 20),
                    child: Text(
                      'Package Size'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
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
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.length > 0) return null;
                                      return 'This field is required';
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.all(10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      hintText: "Enter length",
                                      hintStyle: const TextStyle(
                                          fontSize: 15.0, color: Colors.grey),
                                    ),
                                    maxLines: 1,
                                    // obscureText: true,
                                    controller: _length,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
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
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.length > 0) return null;
                                      return 'This field is required';
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.all(10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      hintText: "Enter Height",
                                      hintStyle: const TextStyle(
                                          fontSize: 15.0, color: Colors.grey),
                                    ),
                                    maxLines: 1,
                                    // obscureText: true,
                                    controller: _height,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
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
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.length > 0) return null;
                                      return 'This field is required';
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.all(10.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      hintText: "Enter width",
                                      hintStyle: const TextStyle(
                                          fontSize: 15.0, color: Colors.grey),
                                    ),
                                    maxLines: 1,
                                    // obscureText: true,
                                    controller: _width,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 50),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    hint: const Text('CM'),
                                    style: const TextStyle(
                                        color: Colors
                                            .blue), // Not necessary for Option 1
                                    value: _selectedMeasurment,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedMeasurment = newValue!;
                                        print(_selectedMeasurment);
                                      });
                                    },
                                    items: sizeAttributes.map((location) {
                                      return DropdownMenuItem(
                                        child: Text(location),
                                        value: location,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 17.0, left: 25.0, right: 20),
                    child: Text(
                      'Package Description'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
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
                          validator: (value) {
                            if (value!.length > 0) return null;
                            return 'This field is required';
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          maxLength: 500,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 2.0),
                            ),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //     color: Colors.grey,
                            //     width: 2.0,
                            //   ),
                            // ),
                            hintText: 'Description',
                            contentPadding: const EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          controller: _description,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 17.0, left: 25.0, right: 20),
                    child: Text(
                      'Upload images'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 15, top: 7),
                    child: Container(
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
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 18),
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
                                  loadAssets();
            
                                  //_onAlertPress();
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 26.0),
                    child: Text(
                      'Maximum four images-size(60x60px) -20kb',
                      style: TextStyle(
                          color: Constants.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
            
                    _imgs.isEmpty ? Container():  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, right: 8.0, left: 8.0),
                    child: Container(
                        height: _imgs.length > 0 ? 200 : 0,
                        width: double.infinity,
                        child: buildGridView()),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 26.0, top: 8),
                  //   child: Row(
                  //     children: <Widget>[
                  //       Text(
                  //         'Add Image',
                  //         style: TextStyle(
                  //             color: Constants.primary,
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.w400),
                  //       ),
                  //       IconButton(
                  //         icon: Icon(
                  //           Icons.add_circle_outline,
                  //           color: Constants.primary,
                  //         ),
                  //         //color: Colors.black,
                  //         onPressed: () {},
                  //         tooltip: "Notification",
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, left: 25.0, right: 20),
                    child: Text(
                      'Handle with care'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(
                          children: <Widget>[
                            Radio<int>(
                                activeColor: Constants.primary,
                                value: 0,
                                groupValue: radioValue,
                                onChanged: (r) {
                                  handleRadioValueChanged(r!);
                                }),
                            const Padding(
                              padding: EdgeInsets.only(left: 0.0),
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      //radiobuttons go here
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          children: <Widget>[
                            Radio<int>(
                                activeColor: Constants.primary,
                                value: 1,
                                groupValue: radioValue,
                                onChanged: (r) {
                                  handleRadioValueChanged(r!);
                                }),
                            const Padding(
                              padding: EdgeInsets.only(left: 0.0),
                              child: Text(
                                "No",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 17.0, left: 25.0, right: 20),
                    child: Text(
                      'Comments'.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
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
                          validator: (value) {
                            if (value!.length > 0) return null;
                            return 'This field is required';
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          maxLength: 500,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 2.0),
                            ),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //     color: Colors.grey,
                            //     width: 2.0,
                            //   ),
                            // ),
                            hintText: 'Comment',
                            contentPadding: const EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          controller: _comment,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 28.0, left: 25.0, right: 20),
                    child: Text(
                      'Payment Options'.toUpperCase(),
                      style: const TextStyle(
                          color: Color(0xff1fa2f2),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const Divider(),
                ],
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        isExpanded: true,
                        hint: const Text('Select payment'),
                        style: const TextStyle(
                            color: Colors.blue), // Not necessary for Option 1
                        value: paymentSelector,
                        onChanged: (newValue) {
                          setState(() {
                            paymentSelector = newValue;
                            print(paymentSelector);
                          });
                        },
                        items: payment.map((location) {
                          return DropdownMenuItem(
                            child: Text(location),
                            value: location,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12.0, top: 20, bottom: 10),
              child: _isLoadingsave
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Container(
                          child: CupertinoButton(
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(10.0),
                            // ),
                            color: const Color(0xff1fa2f2),
                            child: Text(
                              "save".toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _formKey.currentState!.validate();
                                if (_formKey.currentState!.validate()) {
                                  _isLoadingsave = true;
                                  apiResponsefromhome();
                                  // if (widget.home == true) {
            
                                  // } else {
                                  //   apiForIdentifier();
                                  // }
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

// ElevatedButton(
//                           // shape: RoundedRectangleBorder(
//                           //   borderRadius: BorderRadius.circular(10.0),
//                           // ),
//                           color: Color(0xff1fa2f2),
//                           child: Text(
//                             "save".toUpperCase(),
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isLoading1 = true;
//                             });
//                             khan();
//                           },
//                         ),

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      physics: const NeverScrollableScrollPhysics(),
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

  Future<void> loadAssets() async {
    List<Asset> resultList = [];
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        selectedAssets: images,
        //cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: Color(0xffabcdef),
          actionBarTitle: Constants.appname,
          maxImages: 4,
          enableCamera: true,
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: Color(0xff000000),
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    //

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
 
    setState(() {});
    if (!mounted) return;

  }
}
