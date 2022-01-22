import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:home_automation_app/responsive/Screensize.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation_app/screens/main_data.dart';
import 'package:home_automation_app/screens/switches.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'main_data.dart';

class Circuit extends StatefulWidget {
  @override
  _CircuittState createState() => _CircuittState();
}

class _CircuittState extends State<Circuit> {
  @override
  void dispose() {
    super.dispose();
  }

  final dbref = FirebaseDatabase.instance.reference().child('Users');
  User user = FirebaseAuth.instance.currentUser;
  bool isboardfetch = true;
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool pressed = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _boardData();
  }

  _boardData() async {
    setState(() {
      isboardfetch = true;
    });
    try {
      fulldataofrooms d = new fulldataofrooms();
      await d.fetchboards();
      fulldataofrooms.boardidarray.sort();
    } catch (Ex) {
      print("exception honme roomdata");
    }
    setState(() {
      isboardfetch = false;
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.blue,
          title: Text(
            'Board',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: isboardfetch
            ? Center(child: CircularProgressIndicator())
            : Container(
                //height:0.75*SizeConfig.screenHeight,
                color: Colors.white,
                child: (fulldataofrooms.boardidarray.length != 0)
                    ? AnimationLimiter(
                        child: ListView.builder(
                          padding: kMaterialListPadding,
                          itemCount: fulldataofrooms.boardidarray.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                    child: Dismissible(
                                  direction: DismissDirection.startToEnd,
                                  resizeDuration: Duration(milliseconds: 200),
                                  key: ObjectKey(
                                      fulldataofrooms.boardidarray[index]),
                                  confirmDismiss: (direction) async {
                                    return await Alert(
                                      context: context,
                                      type: AlertType.warning,
                                      style: AlertStyle(
                                          animationType: AnimationType.fromTop,
                                          isCloseButton: false,
                                          isOverlayTapDismiss: false,
                                          descStyle: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          animationDuration:
                                              Duration(milliseconds: 400),
                                          titleStyle: TextStyle(
                                              color: Color(0xff00004d)),
                                          alertBorder: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            side: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          )),
                                      title: "Confirm Delete",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "Confirm",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 2.5 *
                                                    SizeConfig.textMultiplier),
                                          ),
                                          // ignore: missing_return
                                          onPressed: pressed
                                              ? null
                                              : () async {
                                                  setState(() {
                                                    pressed = true;
                                                    fulldataofrooms.changed = true;
                                                  });
                                                  await dbref
                                                      .child(user.uid)
                                                      .child("rooms")
                                                      .child(fulldataofrooms
                                                              .roomidarray[
                                                          fulldataofrooms
                                                              .index])
                                                      .child("circuit")
                                                      .child(fulldataofrooms
                                                          .boardidarray[index])
                                                      .remove();
                                                  var indexdeletelist = [];
                                                  Map map = fulldataofrooms
                                                          .boardid[
                                                      fulldataofrooms
                                                          .boardidarray[index]];
                                                  for (final i in map.keys) {
                                                    try {
                                                      indexdeletelist
                                                          .add(map[i]['name']);
                                                    } catch (e) {}
                                                  }

                                                  for (int i = 0;
                                                      i <
                                                          indexdeletelist
                                                              .length;
                                                      i++) {
                                                    try {
                                                      dbref
                                                          .child(user.uid)
                                                          .child('index')
                                                          .child(
                                                              indexdeletelist[
                                                                  i])
                                                          .remove();
                                                    } catch (e) {}
                                                    for (int j = 1;
                                                        j <
                                                            fulldataofrooms
                                                                .favroomsarray
                                                                .length;
                                                        j++) {
                                                      try {
                                                        await dbref
                                                            .child(user.uid)
                                                            .child('favourites')
                                                            .child((fulldataofrooms
                                                                    .favroomsarray[
                                                                j]))
                                                            .child(fulldataofrooms
                                                                        .roomidarray[
                                                                    fulldataofrooms
                                                                        .index] +
                                                                fulldataofrooms
                                                                        .boardidarray[
                                                                    index] +
                                                                "a" +
                                                                (i + 1)
                                                                    .toString())
                                                            .remove();
                                                      } catch (e) {}
                                                    }
                                                  }

                                                  setState(() {
                                                    fulldataofrooms.boardidarray
                                                        .remove(fulldataofrooms
                                                                .boardidarray[
                                                            index]);
                                                    pressed = false;
                                                  });
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                          color:
                                              Color.fromRGBO(0, 179, 134, 1.0),
                                        ),
                                        DialogButton(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 2.4 *
                                                    SizeConfig.textMultiplier),
                                          ),
                                          onPressed: pressed
                                              ? null
                                              : () {
                                                  setState(() {
                                                    pressed = true;
                                                  });
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    pressed = false;
                                                  });
                                                },
                                          gradient: LinearGradient(colors: [
                                            Color(0xffe63900),
                                            Color(0xffe63900)
                                          ]),
                                        )
                                      ],
                                    ).show();
                                  },
                                  background: Container(
                                    height: 8 * SizeConfig.heightMultiplier,
                                    width: 80 * SizeConfig.widthMultiplier,
                                    alignment: AlignmentDirectional.centerStart,
                                    color: Colors.red,
                                    child: Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Card(
                                    child: Container(
                                      height: 8 * SizeConfig.heightMultiplier,
                                      width: 100 * SizeConfig.widthMultiplier,
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0.00, 5.00),
                                            color: Color(0xff0792ef)
                                                .withOpacity(0.60),
                                            blurRadius: 18,
                                          ),
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Center(
                                        child: ListTile(
                                          onTap: pressed
                                              ? null
                                              : () async {
                                                  setState(() {
                                                    pressed = true;
                                                  });
                                                  fulldataofrooms.boardindex =
                                                      index;
                                                  await fulldataofrooms
                                                      .fetchswitchstate();
                                                  fulldataofrooms.switches =
                                                      fulldataofrooms.boardid[
                                                          fulldataofrooms
                                                                  .boardidarray[
                                                              index]];

                                                  setState(() {
                                                    pressed = false;
                                                  });
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            switches(),
                                                      ));
                                                },
                                          isThreeLine: false,
                                          leading: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: IconButton(
                                                icon: Icon(Icons
                                                    .bookmark_border_outlined),
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text("ID = " +
                                                        fulldataofrooms.boardid[
                                                            fulldataofrooms
                                                                    .boardidarray[
                                                                index]]["bid"]),
                                                    action: SnackBarAction(
                                                        label: 'hide',
                                                        onPressed: ScaffoldMessenger
                                                                .of(context)
                                                            .hideCurrentSnackBar),
                                                  ));
                                                }),
                                          ),
                                          title: Text(
                                            fulldataofrooms.boardidarray[index],
                                            style: TextStyle(
                                              fontSize:
                                                  2 * SizeConfig.textMultiplier,
                                              color: Color(0xff997a00),
                                            ),
                                          ),
                                          trailing: Icon(
                                              Icons.navigate_next_outlined),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: new Text("Add Boards ",
                            style: TextStyle(
                                fontSize: 3 * SizeConfig.textMultiplier,
                                color: Color(0xff898989)))),
              ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.blue,
            onPressed: pressed
                ? null
                : () async {
                    try {
                      setState(() {
                        pressed = true;
                      });
                      await _addboard(context);
                      setState(() {
                        pressed = false;
                      });
                    } catch (Exc) {
                      print(Exc);
                    }
                  },
            tooltip: 'Increment',
            label: Text("Add Boards"),
            icon: Icon(Icons.add)));
  }

  _addboard(BuildContext context) async {
    bool pressed = false;
    final dbref = FirebaseDatabase.instance.reference().child('Users');
    final form = new GlobalKey<FormState>();
    FocusNode focusNode = new FocusNode();
    TextEditingController id = TextEditingController();
    return showGeneralDialog(
        transitionBuilder: (context, a1, a2, widget) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  title: Center(
                    child: Text(
                      'Details of board',
                      style: TextStyle(
                        fontFamily: "Amelia-Basic-Light",
                        fontSize: 3 * SizeConfig.textMultiplier,
                        color: Color(0xff79848b),
                      ),
                    ),
                  ),
                  content: Container(
                    height: 10 * SizeConfig.heightMultiplier,
                    width: 80 * SizeConfig.widthMultiplier,
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: form,
                          child: new TextFormField(
                            controller: id,
                            onChanged: (val) {},
                            cursorColor: Colors.black87,
                            focusNode: focusNode,
                            style: TextStyle(
                              fontFamily: "Amelia-Basic-Light",
                              fontSize: 2.4 * SizeConfig.textMultiplier,
                              color: Color(0xff79848b),
                            ),
                            decoration: new InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 55),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xff444422),
                                  ),
                                  borderRadius: BorderRadius.circular(10.00)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              labelText: "Board Id",
                              labelStyle: TextStyle(
                                fontFamily: "Amelia-Basic-Light",
                                fontSize: 16,
                                color: Color(0xff79848b),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Container(
                      height: 6 * SizeConfig.heightMultiplier,
                      width: 25 * SizeConfig.widthMultiplier,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0.00, 3.00),
                            color: Color(0xff0792ef).withOpacity(0.32),
                            blurRadius: 6,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(13.00),
                      ),
                      child: Center(
                        child: new FlatButton(
                            child: new Text(
                              'Submit',
                              style: TextStyle(
                                fontFamily: "Amelia-Basic-Light",
                                fontSize: 2.4 * SizeConfig.textMultiplier,
                                color: Color(0xff79848b),
                              ),
                            ),
                            onPressed: pressed
                                ? null
                                : () async {
                                    setState(() {
                                      pressed = true;
                                    });

                                    if (id.text != "") {
                                       fulldataofrooms.changed = true;
                                      String noofboards;
                                      int max = 0;
                                      for (int i = 0;
                                          i <
                                              fulldataofrooms
                                                  .boardidarray.length;
                                          i++) {
                                        String s =
                                            fulldataofrooms.boardidarray[i];

                                        int n = int.parse(s.substring(5));
                                        if (n > max) max = n;
                                      }
                                      max++;
                                      print(max);
                                      if (max < 10)
                                        noofboards = "0" + max.toString();
                                      else
                                        noofboards = max.toString();
                                      //
                                      String room = fulldataofrooms
                                          .roomidarray[fulldataofrooms.index];
                                      String board =
                                          "board" + noofboards.toString();

                                      for (int i = 1; i <= 5; i++) {
                                        dbref
                                            .child(FirebaseAuth
                                                .instance.currentUser.uid)
                                            .child("index")
                                            .child(room +
                                                board +
                                                "a" +
                                                i.toString())
                                            .set(room +
                                                " " +
                                                board +
                                                " " +
                                                "a" +
                                                i.toString());
                                      }

                                      //

                                      dbref
                                          .child(FirebaseAuth
                                              .instance.currentUser.uid)
                                          .child("rooms")
                                          .child(fulldataofrooms.roomidarray[
                                              fulldataofrooms.index])
                                          .child("circuit")
                                          .child(
                                              "board" + noofboards.toString())
                                          .set({
                                        "a1": {
                                          "name": room + board + "a1",
                                          "val": 0,
                                          "icon": "null"
                                        },
                                        "a2": {
                                          "name": room + board + "a2",
                                          "val": 0,
                                          "icon": "null"
                                        },
                                        "a3": {
                                          "name": room + board + "a3",
                                          "val": 0,
                                          "icon": "null"
                                        },
                                        "a4": {
                                          "name": room + board + "a4",
                                          "val": 0,
                                          "icon": "null"
                                        },
                                        "a5": {
                                          "name": room + board + "a5",
                                          "val": 0,
                                          "icon": "null"
                                        },
                                        "bid": id.text
                                      });

                                      fulldataofrooms f1 =
                                          new fulldataofrooms();
                                      f1.fetchindex();

                                      setState(() async {
                                        Navigator.pop(context);
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Circuit()));
                                      });
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Please Enter valid Id");
                                    }
                                    setState(() {
                                      pressed = false;
                                    });
                                  }),
                      ),
                    ),
                    SizedBox(width: SizeConfig.widthMultiplier * 2.5),
                    Container(
                      height: 6 * SizeConfig.heightMultiplier,
                      width: 25 * SizeConfig.widthMultiplier,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0.00, 3.00),
                            color: Color(0xff0792ef).withOpacity(0.32),
                            blurRadius: 6,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(13.00),
                      ),
                      child: Center(
                        child: new FlatButton(
                            child: new Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: "Amelia-Basic-Light",
                                fontSize: 16,
                                color: Color(0xff79848b),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            }),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}
