import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation_app/responsive/Screensize.dart';
import 'package:home_automation_app/screens/main_data.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class switches extends StatefulWidget {
  @override
  _switchesState createState() => _switchesState();
}

class _switchesState extends State<switches> {
  //

  var _tapPosition, focusnode = List.filled(5, false);
  final dbref = FirebaseDatabase.instance.reference().child("Users");
  User user = FirebaseAuth.instance.currentUser;
  var edit = List.filled(5, false);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Switches',
            style: TextStyle(color: Colors.white),
          ),
        ),

        ////////////////////////////////////////////////////////////////////////////////////
        body: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                shrinkWrap: true,
                children: List.generate(
                  4,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTapDown: (TapDownDetails details) {
                          _tapPosition = details.globalPosition;
                        },
                        //Rename
                        onLongPress: () {
                          final RenderBox overlay =
                              Overlay.of(context).context.findRenderObject();
                          showMenu(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            items: <PopupMenuEntry>[
                              PopupMenuItem(
                                value: index,
                                child: InkWell(
                                  onTap: () {
                                    print("rename");
                                    setState(() {
                                      edit = List.filled(5, false);
                                      edit[index] = true;
                                      focusnode[index] = true;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.edit),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Text(
                                        "Rename",
                                        style: TextStyle(
                                            fontFamily: "Amelia-Basic-Light",
                                            fontSize: 16,
                                            color: Color(0xff79848b)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value: index,
                                child: InkWell(
                                  onTap: () {
                                    print("favourites");
                                    //logic///////////////////////
                                    Navigator.pop(context);
                                    favouritesdialogbox(context, index);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.edit),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Text(
                                        "Add to Favourites",
                                        style: TextStyle(
                                            fontFamily: "Amelia-Basic-Light",
                                            fontSize: 16,
                                            color: Color(0xff79848b)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                            context: context,
                            position: RelativeRect.fromRect(
                                _tapPosition & const Size(40, 40),
                                Offset.zero & overlay.size),
                          );
                          //
                        },
                        //switches//////////////////////////////////////////////////////////////////////////////////
                        onTap: () {},
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Container(
                                    height: 5 * SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    child: IconButton(
                                      icon: new Icon(
                                        Icons.lightbulb_outline,
                                        size: 15 * SizeConfig.widthMultiplier,
                                        color: fulldataofrooms.switches["a" +
                                                        (index + 1).toString()]
                                                    ["val"] ==
                                                1
                                            ? Colors.green
                                            : Color(0xff79848b),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          int flag = 0;
                                          if (fulldataofrooms.switches["a" +
                                                      (index + 1).toString()]
                                                  ["val"] ==
                                              0) {
                                            flag = 1;
                                          }
                                          fulldataofrooms.switches[
                                                  "a" + (index + 1).toString()]
                                              ["val"] = flag;
                                          dbref
                                              .child(user.uid)
                                              .child("rooms")
                                              .child(
                                                  fulldataofrooms.roomidarray[
                                                      fulldataofrooms.index])
                                              .child("circuit")
                                              .child(fulldataofrooms
                                                      .boardidarray[
                                                  fulldataofrooms.boardindex])
                                              .child(
                                                  "a" + (index + 1).toString())
                                              .child("val")
                                              .set(flag);
                                        });
                                      },
                                    )),
                              ),

                              // Center(
                              //   child: Container(
                              //     height: 5 * SizeConfig.heightMultiplier,
                              //     width: 30 * SizeConfig.widthMultiplier,
                              //     margin: EdgeInsets.all(10),
                              //     child: LiteRollingSwitch(
                              //       value: fulldataofrooms.switches["a" +
                              //                   (index + 1).toString()]["val"] ==
                              //               1
                              //           ? true
                              //           : false,
                              //       textOn: 'Active',
                              //       textOff: 'Inactive',
                              //       colorOn: Colors.greenAccent,
                              //       colorOff: Color(0xff79848b),
                              //       iconOn: Icons.lightbulb_outline,
                              //       iconOff: Icons.power_settings_new,
                              //       textSize: 14,
                              //       onChanged: (bool state) {
                              //         print('turned ${(state) ? 'on' : 'off'}');
                              //         int flag = 0;
                              //         if (state) {
                              //           flag = 1;
                              //         }
                              //         fulldataofrooms
                              //                 .switches["a" + (index + 1).toString()]
                              //             ["val"] = flag;
                              //         dbref
                              //             .child(user.uid)
                              //             .child("rooms")
                              //             .child(fulldataofrooms
                              //                 .roomidarray[fulldataofrooms.index])
                              //             .child("circuit")
                              //             .child(fulldataofrooms.boardidarray[
                              //                 fulldataofrooms.boardindex])
                              //             .child("a" + (index + 1).toString())
                              //             .child("val")
                              //             .set(flag);
                              //       },
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: 40,
                              ),
                              Center(
                                child: Container(
                                  width: 14 * SizeConfig.heightMultiplier,
                                  child: TextField(
                                    autofocus: focusnode[index],
                                    focusNode: new FocusNode(),
                                    controller: TextEditingController()
                                      ..text = fulldataofrooms.switches[
                                          "a" + (index + 1).toString()]["name"],
                                    expands: false,
                                    enabled: edit[index],
                                    textInputAction: TextInputAction.go,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontFamily: "Amelia-Basic-Light",
                                      fontSize: 16,
                                      color: Color(0xff79848b),
                                    ),
                                    onSubmitted: (name) {
                                      setState(() {
                                        fulldataofrooms.switches[
                                                "a" + (index + 1).toString()]
                                            ["name"] = name;
                                        dbref
                                            .child(user.uid)
                                            .child("rooms")
                                            .child(fulldataofrooms.roomidarray[
                                                fulldataofrooms.index])
                                            .child("circuit")
                                            .child(fulldataofrooms.boardidarray[
                                                fulldataofrooms.boardindex])
                                            .child("a" + (index + 1).toString())
                                            .child("name")
                                            .set(name);
                                        edit = List.filled(5, false);
                                        focusnode = List.filled(5, false);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height: 147.00,
                          width: 194.00,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0.00, 5.00),
                                color: Color(0xff0792ef).withOpacity(0.60),
                                blurRadius: 18,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              GestureDetector(
                child: Card(
                  child: Container(
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                              height: 2 * SizeConfig.heightMultiplier,
                              width: 30 * SizeConfig.widthMultiplier,
                              child: IconButton(
                                icon: new Icon(
                                  Icons.label,
                                  size: 10 * SizeConfig.widthMultiplier,
                                  color: Color(0xff79848b),
                                ),
                                onPressed: () {
                                  setState(() {
                                    int flag = 0;
                                    if (fulldataofrooms.switches[
                                            "a" + (4 + 1).toString()]["val"] ==
                                        0) {
                                      flag = 1;
                                    }
                                    fulldataofrooms
                                            .switches["a" + (4 + 1).toString()]
                                        ["val"] = flag;
                                    dbref
                                        .child(user.uid)
                                        .child("rooms")
                                        .child(fulldataofrooms
                                            .roomidarray[fulldataofrooms.index])
                                        .child("circuit")
                                        .child(fulldataofrooms.boardidarray[
                                            fulldataofrooms.boardindex])
                                        .child("a" + (4 + 1).toString())
                                        .child("val")
                                        .set(flag);
                                  });
                                },
                              )),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 30, 0, 0),
                            child: Row(
                              children: [
                                new IconButton(
                                  icon: new Icon(
                                    Icons.remove,
                                    size: 8 * SizeConfig.widthMultiplier,
                                    color: Color(0xff79848b),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      int flag = fulldataofrooms.switches[
                                          "a" + (4 + 1).toString()]["val"];
                                      flag--;
                                      flag = (flag % 6).abs();
                                      fulldataofrooms.switches["a" +
                                          (4 + 1).toString()]["val"] = flag;
                                      dbref
                                          .child(user.uid)
                                          .child("rooms")
                                          .child(fulldataofrooms.roomidarray[
                                              fulldataofrooms.index])
                                          .child("circuit")
                                          .child(fulldataofrooms.boardidarray[
                                              fulldataofrooms.boardindex])
                                          .child("a" + (4 + 1).toString())
                                          .child("val")
                                          .set(flag);
                                    });
                                  },
                                ),
                                Text(fulldataofrooms
                                    .switches["a" + (4 + 1).toString()]["val"]
                                    .toString()),
                                new IconButton(
                                  icon: new Icon(
                                    Icons.add,
                                    size: 8 * SizeConfig.widthMultiplier,
                                    color: Color(0xff79848b),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      int flag = fulldataofrooms.switches[
                                          "a" + (4 + 1).toString()]["val"];
                                      flag++;
                                      flag = flag % 6;
                                      fulldataofrooms.switches["a" +
                                          (4 + 1).toString()]["val"] = flag;
                                      dbref
                                          .child(user.uid)
                                          .child("rooms")
                                          .child(fulldataofrooms.roomidarray[
                                              fulldataofrooms.index])
                                          .child("circuit")
                                          .child(fulldataofrooms.boardidarray[
                                              fulldataofrooms.boardindex])
                                          .child("a" + (4 + 1).toString())
                                          .child("val")
                                          .set(flag);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Text("Regulator"),
                        ),
                      ],
                    ),
                    height: 19 * SizeConfig.heightMultiplier,
                    width: 48 * SizeConfig.widthMultiplier,
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0.00, 5.00),
                          color: Color(0xff0792ef).withOpacity(0.60),
                          blurRadius: 18,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  favouritesdialogbox(BuildContext context, int index) async {
    String dropdownfavouriteroom = "Select";
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
                  title: Text(
                    'Details',
                    style: TextStyle(
                      fontFamily: "Amelia-Basic-Light",
                      fontSize: 3 * SizeConfig.textMultiplier,
                      color: Color(0xff79848b),
                    ),
                  ),
                  content: Container(
                    height: 25 * SizeConfig.heightMultiplier,
                    width: 95 * SizeConfig.widthMultiplier,
                    child: Column(
                      children: <Widget>[
                        Form(
                          key: form,
                          child: new TextFormField(
                            controller: id,
                            enabled: dropdownfavouriteroom == "Select"
                                ? true
                                : false,
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
                              labelText: "Create new fav list",
                              labelStyle: TextStyle(
                                fontFamily: "Amelia-Basic-Light",
                                fontSize: 16,
                                color: Color(0xff79848b),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(child: Text("OR")),
                        ),
                        DropdownButton<String>(
                          items: fulldataofrooms.favroomsarray
                              .map((String listvalue) {
                            return DropdownMenuItem<String>(
                              value: listvalue,
                              child: Text(
                                listvalue,
                                style: TextStyle(
                                  fontFamily: "Amelia-Basic-Light",
                                  fontSize: 16,
                                  color: Color(0xff79848b),
                                ),
                              ),
                            );
                          }).toList(),
                          value: dropdownfavouriteroom,
                          onChanged: (val) {
                            setState(() {
                              id.text = "";
                              dropdownfavouriteroom = val;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Container(
                      height: 5 * SizeConfig.heightMultiplier,
                      width: 25 * SizeConfig.widthMultiplier,
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
                      child: new FlatButton(
                          child: new Text(
                            'Submit',
                            style: TextStyle(
                              fontFamily: "Amelia-Basic-Light",
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                              color: Color(0xff79848b),
                            ),
                          ),
                          onPressed: pressed
                              ? null
                              : () async {
                                  setState(() {
                                    pressed = true;
                                  });
                                  String flag;

                                  if (id.text != null && id.text != "") {
                                    print("asdf");
                                    flag = id.text;
                                    dbref
                                        .child(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .child("favourites")
                                        .child(flag)
                                        .child("val")
                                        .set(0);
                                  } else {
                                    flag = dropdownfavouriteroom;
                                  }

                                  if (dropdownfavouriteroom == "Select" &&
                                      (id.text == null || id.text == "")) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Please select any one of the above");
                                  } else {
                                    String room = fulldataofrooms
                                        .roomidarray[fulldataofrooms.index];
                                    String board = fulldataofrooms.boardidarray[
                                        fulldataofrooms.boardindex];
                                    String switchh =
                                        ('a' + (index + 1).toString());
                                    dbref
                                        .child(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .child("favourites")
                                        .child(flag)
                                        .child(room + board + switchh)
                                        .set(
                                            room + " " + board + " " + switchh);

                                    //change
                                    setState(() {
                                      dropdownfavouriteroom = "Select";
                                    });
                                    fulldataofrooms f = new fulldataofrooms();
                                    await f.fetchfavourites();
                                  }
                                  setState(() {
                                    pressed = false;
                                    print("aaya");
                                    Navigator.pop(context);
                                  });
                                }),
                    ),
                    Container(
                      height: 5 * SizeConfig.heightMultiplier,
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
