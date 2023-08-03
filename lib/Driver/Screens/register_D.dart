import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:runnerz/Common/login.dart';
import 'package:runnerz/Common/otp.dart';
import 'package:runnerz/Utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreenD extends StatefulWidget {
  @override
  _RegisterScreenDState createState() => _RegisterScreenDState();
}

class _RegisterScreenDState extends State<RegisterScreenD> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  TextEditingController _fullName = new TextEditingController();
  TextEditingController _username = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _passwordControl = new TextEditingController();
  TextEditingController _confirmPasswordControl = new TextEditingController();
  TextEditingController _mobileNo = new TextEditingController();

  File? _image;

  String img =
      'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png';

  Uri apiUrl = Uri.parse(Constants.baseUrl + 'customers/postRegister');

  Future<Map<String, dynamic>> _uploadImage(File image) async {
    // setState(() {
    //   pr.hide();
    // });

    String value = '';
    SharedPreferences pref2 = await SharedPreferences.getInstance();
    value = pref2.getString("user_role")!;

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

    imageUploadRequest.fields['name'] = _fullName.text;
    imageUploadRequest.fields['email'] = _email.text;
    imageUploadRequest.fields['username'] = _username.text;
    imageUploadRequest.fields['password'] = _passwordControl.text;
    imageUploadRequest.fields['confirm_password'] =
        _confirmPasswordControl.text;
    imageUploadRequest.fields['user_role'] = value;
    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['mobile'] = _mobileNo.text;

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

  void saveChanges() async {
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
          SharedPreferences pref1 = await SharedPreferences.getInstance();
          pref1.setString("user_id", '${_data['user_id']}');
          setState(() {
            _isLoading = false;
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (c) {
                return AlertDialog(
                  title:  Text('Congratulations'),
                  content: Text(
                      "Check your Email, OTP send successfully.  For now enter this code ${_data['code']}"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  Otp()),
                        );
                      },
                      child: Text(
                        "Enter OTP",
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
      } else {
        _isLoading = false;
        messageAllert('Please Select a profile photo', 'Profile Photo');
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //khan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(255, 31, 162, 242),
            const Color.fromARGB(255, 29, 161, 245),
          ],
        )),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 20),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Expanded(
                              //   child: new Container(
                              //       margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                              //       child: Divider(
                              //         color: Colors.black,
                              //         height: 50,
                              //       )),
                              // ),

                              Text(
                                "_______________   ",
                                style: TextStyle(color: Colors.white38),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),

                              Text(
                                "   _______________",
                                style: TextStyle(color: Colors.white38),
                              ),
                              // Expanded(
                              //   child: new Container(
                              //       margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                              //       child: Divider(
                              //         color: Colors.white,
                              //         height: 50,
                              //       )),
                              // ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(
                height: 12,
              ),
              Center(
                child: Stack(
                  children: <Widget>[
                    _image == null
                        ? const CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png'),
                            radius: 50.0,
                          )
                        : CircleAvatar(
                            backgroundImage: FileImage(_image!),
                            radius: 50.0,
                          ),
                    InkWell(
                      onTap: _onAlertPress,
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              color: Colors.grey.withOpacity(0.5)),
                          margin: const EdgeInsets.only(left: 70, top: 70),
                          child: const Icon(
                            Icons.photo_camera,
                            size: 25,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 5.0),
                      child: Text(
                        'Full Name'.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 0.0, right: 0.0, top: 2),
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
                              hintText: "Enter your full name",
                              hintStyle: const TextStyle(
                                  fontSize: 15.0, color: Colors.grey),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            maxLines: 1,
                            controller: _fullName,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 5.0),
                      child: Text(
                        'User Name'.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 0.0, right: 0.0, top: 2),
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
                              hintText: "Enter Username",
                              hintStyle: const TextStyle(
                                  fontSize: 15.0, color: Colors.grey),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                            maxLines: 1,
                            controller: _username,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9.0, left: 5.0),
                      child: Text(
                        'Email Id'.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 2.0),
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
                              hintText: "Enter Your Email",
                              hintStyle: const TextStyle(
                                  fontSize: 15.0, color: Colors.grey),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter email address';
                              }
                              return null;
                            },
                            maxLines: 1,
                            controller: _email,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9.0, left: 5.0),
                      child: Text(
                        'Password'.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 2.0),
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
                              hintText: "Enter password",
                              hintStyle: const TextStyle(
                                  fontSize: 15.0, color: Colors.grey),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            maxLines: 1,
                            obscureText: true,
                            controller: _passwordControl,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9.0, left: 5.0),
                      child: Text(
                        'Confirm Password'.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 2.0),
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
                              hintText: "Enter password again",
                              hintStyle: const TextStyle(
                                  fontSize: 15.0, color: Colors.grey),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your passwor again';
                              }
                              return null;
                            },
                            maxLines: 1,
                            obscureText: true,
                            controller: _confirmPasswordControl,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9.0, left: 5.0),
                      child: Text(
                        'Mobile Number'.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 0.0, top: 2.0),
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
                              hintText: "Enter your mobile number",
                              hintStyle: const TextStyle(
                                  fontSize: 15.0, color: Colors.grey),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your mobile number';
                              }
                              return null;
                            },
                            maxLines: 1,
                            controller: _mobileNo,
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
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.black54),
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 6, 101, 159),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text(
                                  "Sign up".toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                      saveChanges();
                                    });
                                  }
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin:
                      const EdgeInsets.only(top: 03, left: 15.0, right: 15.0),
                  child: const Divider(
                    color: Colors.white,
                  )),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 20,
                ),
                child: Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Already Registered?',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          child: const Text(
                            'Sign In',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromARGB(255, 6, 101, 159),
                                fontSize: 17,
                                fontWeight: FontWeight.w800),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAlertPress() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Column(
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
                child: const Column(
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
