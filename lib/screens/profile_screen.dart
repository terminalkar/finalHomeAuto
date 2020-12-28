import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_automation_app/responsive/Screensize.dart';
import 'package:flutter/widgets.dart';

class profile extends StatefulWidget {
  @override
  profileState createState() => profileState();
}

class profileState extends State<profile> {
  FocusNode focusNode = new FocusNode();

  final dbref = FirebaseDatabase.instance.reference();
  final FocusNode myFocusNode = FocusNode();
  final TextEditingController _idcontroller = new TextEditingController();
  final TextEditingController _mailcontroller = new TextEditingController();
  bool _status = true;
  User user = FirebaseAuth.instance.currentUser;

  void initState() {
    // TODO: implement initState
    _mailcontroller.text = user.email;
    _idcontroller.text = user.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          new Container(
            height: 35 * SizeConfig.heightMultiplier,
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: new AssetImage("  "),
              //   fit: BoxFit.cover,
              // ),
              borderRadius: new BorderRadius.circular(10.00),
            ),
            child: new Column(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(top: 5.5 * SizeConfig.heightMultiplier),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CircleAvatar(
                          radius: 5.5 * SizeConfig.heightMultiplier,
                          backgroundColor: Colors.black87,
                          child: CircleAvatar(
                            backgroundColor: Colors.black87,
                            radius: 5 * SizeConfig.heightMultiplier,
                            child: new Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 10 * SizeConfig.heightMultiplier,
                            ),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: new Container(
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black,
                      width: 5.0,
                    ),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffffffff), Colors.blue[300]])),
              child: Padding(
                padding:
                    EdgeInsets.only(bottom: 3.5 * SizeConfig.heightMultiplier),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            left: 8 * SizeConfig.widthMultiplier,
                            right: 8 * SizeConfig.widthMultiplier,
                            top: 2.5 * SizeConfig.heightMultiplier),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Personal Information',
                                  style: TextStyle(
                                      fontSize:
                                          2.5 * SizeConfig.heightMultiplier,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 7 * SizeConfig.widthMultiplier,
                            right: 7 * SizeConfig.widthMultiplier,
                            top: 3.5 * SizeConfig.heightMultiplier),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'Email ID',
                                  style: TextStyle(
                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 7 * SizeConfig.widthMultiplier,
                            right: 7 * SizeConfig.widthMultiplier,
                            top: 0.25 * SizeConfig.heightMultiplier),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                decoration: const InputDecoration(
                                    hintText: "Enter Email ID"),
                                controller: _mailcontroller,
                                enabled: false,
                                onChanged: (val) {},
                              ),
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 7 * SizeConfig.widthMultiplier,
                            right: 7 * SizeConfig.widthMultiplier,
                            top: 3.5 * SizeConfig.heightMultiplier),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Text(
                                  'UID',
                                  style: TextStyle(
                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 7 * SizeConfig.widthMultiplier,
                            right: 7 * SizeConfig.widthMultiplier,
                            top: 0.28 * SizeConfig.heightMultiplier),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Flexible(
                              child: new TextField(
                                decoration: const InputDecoration(
                                  hintText: "UID",
                                ),
                                controller: _idcontroller,
                                enabled: !_status,
                                autofocus: !_status,
                                onChanged: (text) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
