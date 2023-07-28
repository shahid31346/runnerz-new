import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:runnerz/Common/listCons/user_details.dart';
import 'package:runnerz/Customer/screens/my_profile.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class EditDetails extends StatefulWidget {
  @override
  _EditDetailsState createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool loading = false;
  bool apiCalled = false;
  UserDetail? detail;

  ProgressDialog? pr;

  TextEditingController fullname = TextEditingController();
  TextEditingController phone = TextEditingController();

  File? _image;

  String img =
      "http://35.158.106.116/uploads/profile/customers/1596717180__image_picker1000901002477776929.jpg";

  Future<Map<String, dynamic>> _uploadImage(File image) async {
    String value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value = pref1.getString("user_id")!;
    print(value);
    Uri apiUrl = Uri.parse(
        Constants.baseUrl + 'customers/update_profile_detail?user_id=' + value);

    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])!.split('/');

    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', apiUrl);

    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('photo', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension

//    imageUploadRequest.fields['ext'] = mimeTypeData[1];

    imageUploadRequest.fields['name'] = fullname.text;
    imageUploadRequest.fields['phone'] = phone.text;
    imageUploadRequest.files.add(file);

    imageUploadRequest.headers.addAll({
      'Content-Type': 'application/json',
      'Authorization': Constants.authToken,
    });

    var response = await imageUploadRequest.send();
    if (response.statusCode == 200) print('Done!');

    final respStr = await response.stream.bytesToString();

    return json.decode(respStr);
  }

  messageAllert(String msg, String ttl) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: false,
                child: Column(
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

  void khan() async {
//    getJson();

    String _body = "";
    String values = "";

    try {
      // _isLoading = false;
      if (_image != null) {
        final Map<String, dynamic> _data = await _uploadImage(_image!);
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
                  title: Text("oops"),
                  content: Text(values),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close"),
                    )
                  ],
                );
              });
        } else {
          print("success");
          setState(() {
            _isLoading = false;
          });
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => AlertDialog(
                    title: Text("Congratulations"),
                    content: Text('Profile Updated Successfully'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (c) => JoinApp(),
                          //     settings: RouteSettings(name: 'home')));
                        },
                        child: Text("Ok"),
                      )
                    ],
                  ));
        }
      } else {
        _isLoading = false;
        messageAllert('Please Select new profile photo', 'Profile Photo');
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
                    child: Text("Close"),
                  )
                ],
              ));
    }
  }

  Future<Map> _getJson() async {
    String value = '';
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    value = pref1.getString("user_id")!;
    print(value);
    Uri apiUrl = Uri.parse(
        Constants.baseUrl + 'customers/get_user_detail?user_id=' + value);

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

  _getDetail() async {
    setState(() {
      loading = true;
      apiCalled = true;
    });
    try {
      Map _data1 = await _getJson();
      print(_data1['user'][0]);

      if (_data1['user'] is List) {
        UserDetailsResponse prodDetailResponse =
            UserDetailsResponse.fromJson(_data1);
        setState(() {
          loading = false;
          detail = prodDetailResponse.data![0];
        });
      } else {
        setState(() {
          detail = UserDetail();
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        detail = null;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    if (!apiCalled) {
      Future.delayed(Duration(milliseconds: 2), () {
        _getDetail();
      });
    }

    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
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
                        padding: const EdgeInsets.only(top: 12.0, left: 15.0),
                        child: Text(
                          'Edit Details',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          _image == null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "http://35.158.106.116/uploads/profile/customers/1596717180__image_picker1000901002477776929.jpg"),
                                  radius: 50.0,
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(_image!),
                                  radius: 50.0,
                                ),
                          InkWell(
                            onTap: _onAlertPress,
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.0),
                                    color: Colors.grey.withOpacity(0.5)),
                                margin: EdgeInsets.only(left: 70, top: 70),
                                child: Icon(
                                  Icons.photo_camera,
                                  size: 25,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, left: 5.0),
                              child: Text(
                                'Full Name'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 2),
                          child: Card(
                            elevation: 3.0,
                            child: Container(
                              height: 50,
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
                                  // hintText: "${detail.fullname}",
                                  hintText: 'Hamid Ali',
                                  hintStyle: TextStyle(
                                      fontSize: 15.0, color: Colors.grey),
                                ),
                                maxLines: 1,
                                controller: fullname,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30.0, left: 5.0),
                              child: Text(
                                'Mobile number'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 2.0),
                          child: Card(
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
                                  //  hintText: "${detail.mobileNo}",
                                  hintText: '03427659876',
                                  hintStyle: TextStyle(
                                      fontSize: 15.0, color: Colors.grey),
                                ),
                                maxLines: 1,
                                controller: phone,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 77, // match_parent
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 05.0,
                              right: 05.0,
                              top: 20,
                            ),
                            child: _isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.black54),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff1fa2f2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),),
                                    child: Text(
                                      "Update".toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isLoading = true;
                                        khan();
                                      });
                                    }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAlertPress() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Icon(Icons.photo),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Gallery'),
                  ],
                ),
                onPressed: getGalleryImage,
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Icon(Icons.camera_alt),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Take Photo'),
                  ],
                ),
                onPressed: getCameraImage,
              ),
            ],
          );
        });
  }

  // ================================= Image from camera
  Future getCameraImage() async {
    final picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(image!.path);
      Navigator.pop(context);
    });
  }

  //============================== Image from gallery
  Future getGalleryImage() async {
    final picker = ImagePicker();

    var image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image!.path);
      Navigator.pop(context);
    });
  }
}
