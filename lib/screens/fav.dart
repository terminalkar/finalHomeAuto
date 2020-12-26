import 'package:flutter/material.dart';
import 'package:home_automation_app/responsive/Screensize.dart';
import 'package:home_automation_app/screens/main_data.dart';

class favourite extends StatefulWidget {
  @override
  _favouriteState createState() => _favouriteState();
}

class _favouriteState extends State<favourite> {
  var _tapPosition;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        shrinkWrap: true,
        children: List.generate(
          fulldataofrooms.favroomsarray.length - 1,
          (index) {
            Center(
                child: Container(
              width: 14 * SizeConfig.heightMultiplier,
              child: TextField(
                focusNode: new FocusNode(),
                controller: TextEditingController()..text = "text",
                expands: false,
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  fontFamily: "Amelia-Basic-Light",
                  fontSize: 16,
                  color: Color(0xff79848b),
                ),
                onSubmitted: (name) {
                  setState(() {});
                },
              ),
            ));
          },
        ),
      ),
    );
  }
}
