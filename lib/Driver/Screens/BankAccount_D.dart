import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:runnerz/Utils/base_appbar.dart';

class BankAccount extends StatefulWidget {
  @override
  _BankAccountState createState() => _BankAccountState();
}

class _BankAccountState extends State<BankAccount> {
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
                  'Bank Account',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              'BalaKrishna'.toUpperCase(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Center(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/profile.jpeg',
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              //  CircleAvatar(
              //       radius: 20,
              //       backgroundImage: AssetImage(
              //         'assets/splash_screen.jpg',
              //       ),
              //     ),

              // Positioned(
              //   right: -10.0,
              //   bottom: 3.0,
              //   child: RawMaterialButton(
              //     onPressed: null,
              //     fillColor: Colors.white,
              //     shape: CircleBorder(),
              //     elevation: 4.0,
              //     child: Padding(
              //       padding: EdgeInsets.all(5),
              //       child: Icon(Icons.favorite),
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              'BalaKrishna@gmail.com',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(height: 5),
          Divider(),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 25.0, right: 20),
            child: Text(
              'Account holder name'.toUpperCase(),
              style: TextStyle(
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
                    hintText: "Enter Account holder name ",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  controller: null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Account holder address'.toUpperCase(),
              style: TextStyle(
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
                    hintText: "Enter Account holder address",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 3,
                  controller: null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Account Number'.toUpperCase(),
              style: TextStyle(
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
                    hintText: "Enter account number",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  obscureText: true,
                  controller: null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Bank Name'.toUpperCase(),
              style: TextStyle(
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
                    hintText: "Enter bank name",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  obscureText: true,
                  controller: null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Branch Name'.toUpperCase(),
              style: TextStyle(
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
                    hintText: "Enter branch name",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  obscureText: true,
                  controller: null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Branch Address'.toUpperCase(),
              style: TextStyle(
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
                    hintText: "Enter branch address",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 3,
                  controller: null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Swift/Ifdc code'.toUpperCase(),
              style: TextStyle(
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
                    hintText: "Enter SWIFT/IFDC code",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  obscureText: true,
                  controller: null,
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
              child: ElevatedButton(
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(10.0),
                // ),
               
                                 style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1fa2f2),
                 
                ),
                child: Text(
                  "Edit".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
