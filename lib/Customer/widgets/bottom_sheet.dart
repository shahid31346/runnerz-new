import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runnerz/Common/listCons/VechileTypeCons.dart';
import 'package:runnerz/Customer/widgets/vechileType_Single.dart';
import 'package:runnerz/Utils/const.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({Key? key}) : super(key: key);

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  Future<Map> getJson() async {
    Uri apiUrl = Uri.parse(Constants.baseUrl + 'packages/get_all_vehicle_type');

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

  Future<List<VechileTypeCons>> getDelivered() async {
    Map _data = await getJson();

    VechileResponse prodResponse = VechileResponse.fromJson(_data);
    if (prodResponse.status == 'SUCCESS') return prodResponse.data!;
    print(_data);
    return [];
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
    //   height: 200,
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     mainAxisSize: MainAxisSize.max,
    //     children: <Widget>[
    return Expanded(
      child: FutureBuilder<List<VechileTypeCons>>(
        future: getDelivered(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length > 0) {
              List<VechileTypeCons> cateee = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                primary: false,
                //physics: NeverScrollableScrollPhysics(),
                itemCount: cateee == null ? 0 : cateee.length,
                itemBuilder: (BuildContext context, int index) {
                  VechileTypeCons cat = cateee[index];

                  return VechileTypeSingle(
                    id: cat.id,
                    vechiletype: cat.vechileType,
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'No Delivered Packages yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // ),
      // child: Column(
      //   children: <Widget>[DecoratedTextField(), SheetButton()],
      // ),
      //  ],
      //),
    );
  }
}

class VechileResponse {
  final List<VechileTypeCons>? data;
  final String status;

  VechileResponse({required this.data, required this.status});

  factory VechileResponse.fromJson(Map<dynamic, dynamic> json) {
    return VechileResponse(
      data: json['vehicles'] != null
          ? (json['vehicles'] as List)
              .map((i) => VechileTypeCons.fromJson(i))
              .toList()
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['vehicles'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class DecoratedTextField extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       alignment: Alignment.center,
//       padding: const EdgeInsets.all(10),
//       margin: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextField(
//         decoration: InputDecoration.collapsed(hintText: 'Test'),
//       ),
//     );
//   }
// }

// class SheetButton extends StatefulWidget {
//   SheetButton({Key key}) : super(key: key);

//   _SheetButtonState createState() => _SheetButtonState();
// }

// class _SheetButtonState extends State<SheetButton> {
//   bool checkingFlight = false;
//   bool success = false;

//   @override
//   Widget build(BuildContext context) {
//     return !checkingFlight
//         ? MaterialButton(
//             color: Colors.grey[800],
//             onPressed: () async {
//               setState(() {
//                 checkingFlight = true;
//               });

//               await Future.delayed(Duration(seconds: 1));

//               setState(() {
//                 success = true;
//               });

//               await Future.delayed(Duration(milliseconds: 500));

//               Navigator.pop(context);
//             },
//             child: Text(
//               'Check driver',
//               style: TextStyle(
//                 color: Colors.white,
//               ),
//             ),
//           )
//         : !success
//             ? CircularProgressIndicator()
//             : Icon(
//                 Icons.check,
//                 color: Colors.green,
//               );
//   }
// }
