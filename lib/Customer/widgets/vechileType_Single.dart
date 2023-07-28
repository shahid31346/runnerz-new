import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VechileTypeSingle extends StatefulWidget {
  final String id;
  final String vechiletype;

  VechileTypeSingle({
    Key? key,
    required this.id,
    required this.vechiletype,
  }) : super(key: key);

  @override
  _VechileTypeSingleState createState() => _VechileTypeSingleState();
}

class _VechileTypeSingleState extends State<VechileTypeSingle> {
  String? _selection;

  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width * 0.4;
    return InkWell(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            widget.id,
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(widget.vechiletype),
        //  subtitle: Text(widget.vechiletype),
        onTap: () async {
          SharedPreferences prefv = await SharedPreferences.getInstance();
          prefv.setString("vechile_id", widget.id);
          prefv.setBool("next_checker", true);

          Navigator.pop(context);
        },
      ),

      // onTap: () {
      //   Navigator.of(context).push(
      //     MaterialPageRoute(
      //       builder: (BuildContext context) {
      //         return ProductDetails(
      //           id: id,
      //         );
      //       },
      //     ),
      //   );
      // },
    );
  }
}
