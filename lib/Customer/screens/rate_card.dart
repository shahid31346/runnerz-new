import 'package:flutter/material.dart';
import 'package:runnerz/Customer/screens/home.dart';
import 'package:runnerz/Utils/base_appbar.dart';
import 'package:runnerz/Utils/const.dart';

class RateCardScreen extends StatefulWidget {
  @override
  _RateCardScreenState createState() => _RateCardScreenState();
}

class _RateCardScreenState extends State<RateCardScreen> {
  List<String> country = [
    'vechile 1',
    'vechile 2',
    'vechile 3',
    'vechile 4'
  ]; // Option 2
  String? _selectedCountry;

  List<String> state = [
    'country 1',
    'country 2',
    'country 3',
    'country 4'
  ]; // Option 2
  String? _selectedstate;

  List<String> city = ['city 1', 'city 2', 'city 3', 'city 4']; // Option 2
  String? _selectedcity;

  List<String> location = [
    'state 1',
    'state 2',
    'state 3',
    'state 4',
  ]; // Option 2
  String? _selectedlocation;

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
                  'Rate Card',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
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
                      hint: const Text('Select Vehicle Type'),
                      style: const TextStyle(
                          color: Colors.blue), // Not necessary for Option 1
                      value: _selectedCountry,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCountry = newValue!;
                          print(_selectedCountry);
                        });
                      },
                      items: country.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location),
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
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
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
                      hint: const Text('Select Country'),
                      style: const TextStyle(
                          color: Colors.blue), // Not necessary for Option 1
                      value: _selectedstate,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedstate = newValue!;
                          print(_selectedstate);
                        });
                      },
                      items: state.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location),
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
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
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
                      hint: const Text('Select State'),
                      style: const TextStyle(
                          color: Colors.blue), // Not necessary for Option 1
                      value: _selectedlocation,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedlocation = newValue!;
                          print(_selectedlocation);
                        });
                      },
                      items: location.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location),
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
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
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
                      hint: const Text('Select City'),
                      style: const TextStyle(
                          color: Colors.blue), // Not necessary for Option 1
                      value: _selectedcity,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedcity = newValue;
                          print(_selectedcity);
                        });
                      },
                      items: city.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location),
                          value: location,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              right: 25.0,
              left: 25,
              top: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'PER KM FARE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '\$50',
                          style: TextStyle(
                            color: Color(0xff1fa2f2),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' /KM',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'PER HOUR FARE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '\$5',
                          style: TextStyle(
                            color: Color(0xff1fa2f2),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' /h',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 77, // match_parent
            child: Padding(
              padding: const EdgeInsets.only(
                left: 23.0,
                right: 23.0,
                top: 20,
              ),
              child: ElevatedButton(
            
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "Submit".toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 15.0),
          const Divider(
            color: Color(0xff1fa2f2),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: ExpansionTile(
                    title: Text(
                      "Pick Time Surcharge".toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: Row(
                          children: <Widget>[
                            Text('Pick Sur-Charge time'.toUpperCase())
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('3:32-3:47 PM'),
                            Row(
                              children: <Widget>[
                                Text(
                                  '\$5',
                                  style: TextStyle(color: Constants.primary),
                                ),
                                const Text('/minute'),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: ExpansionTile(
                    title: Text(
                      "Surcharge".toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: Row(
                          children: <Widget>[
                            Text('Pick Sur-Charge time'.toUpperCase())
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('3:32-3:47 PM'),
                            Row(
                              children: <Widget>[
                                Text(
                                  '\$5',
                                  style: TextStyle(color: Constants.primary),
                                ),
                                const Text('/minute'),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: ExpansionTile(
                    title: Text(
                      "Night charges".toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: Row(
                          children: <Widget>[
                            Text('Pick Sur-Charge time'.toUpperCase()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('3:32-3:47 PM'),
                            Row(
                              children: <Widget>[
                                Text(
                                  '\$5',
                                  style: TextStyle(color: Constants.primary),
                                ),
                                const Text('/minute'),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: ExpansionTile(
                    title: Text(
                      "Overtime charges".toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: Row(
                          children: <Widget>[
                            Text('Pick Sur-Charge time'.toUpperCase())
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('3:32-3:47 PM'),
                            Row(
                              children: <Widget>[
                                Text(
                                  '\$5',
                                  style: TextStyle(color: Constants.primary),
                                ),
                                const Text('/minute'),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: ExpansionTile(
                    title: Text(
                      "cancellation charges".toUpperCase(),
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: Row(
                          children: <Widget>[
                            Text('Pick Sur-Charge time'.toUpperCase())
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text('3:32-3:47 PM'),
                            Row(
                              children: <Widget>[
                                Text(
                                  '\$5',
                                  style: TextStyle(color: Constants.primary),
                                ),
                                const Text('/minute'),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
