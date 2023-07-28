import 'package:flutter/material.dart';
import 'package:runnerz/Utils/base_appbar.dart';

class BankAccountView extends StatefulWidget {
  @override
  _BankAccountViewState createState() => _BankAccountViewState();
}

class _BankAccountViewState extends State<BankAccountView> {
  TextEditingController account_holder_name  =TextEditingController();
  TextEditingController account_address =TextEditingController();
  TextEditingController account_number =TextEditingController();
  TextEditingController bankname =TextEditingController();
  TextEditingController branch_address =TextEditingController();
  TextEditingController swift_ifdc_code =TextEditingController();
  TextEditingController routing_no =TextEditingController();

  @override
  void initState() {
    super.initState();

    account_holder_name = TextEditingController(text: "Nks");
    account_address = TextEditingController(
        text:
            "33 & 33A, Rama Road, Industrial Area, Near Kirti Nagar Metro Station, New Delhi- 110015(India)");
    account_number = TextEditingController(text: "10021102153322");
    bankname = TextEditingController(text: "Axis Bank");
    branch_address = TextEditingController(
        text:
            "33 & 33A, Rama Road, Industrial Area, Near Kirti Nagar Metro Station, New Delhi- 110015(India)");

    swift_ifdc_code = TextEditingController(text: "ax5446654");
    routing_no = TextEditingController(text: "1234342");
  }

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
                  controller: account_holder_name,
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
                  controller: account_address,
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
                  // obscureText: true,
                  controller: account_number,
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

                  /// obscureText: true,
                  controller: bankname,
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
                  controller: branch_address,
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
                  // obscureText: true,
                  controller: swift_ifdc_code,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 17.0, left: 25.0, right: 20),
            child: Text(
              'Routing No'.toUpperCase(),
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
                    hintText: "Enter Routing no",
                    hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                  ),
                  maxLines: 1,
                  // obscureText: true,
                  controller: routing_no,
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
                  "Add".toUpperCase(),
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
