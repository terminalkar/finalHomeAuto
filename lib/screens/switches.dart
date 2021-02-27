import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation_app/responsive/Screensize.dart';
import 'package:home_automation_app/screens/main_data.dart';

import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
  var iconStr = false;
  var icnstr = "assets/kitchen.png";
  var image = new Map();
  var iconlist = new Map();
  Color dropcolor = Color(0xff79848b);
  String room = 'Select';
  List<String> Rooms = [
    'Select',
    'A.C.',
    'Gaming Station',
    'Bedroom',
    'Bathroom',
    "Children's Room",
    'Other',
  ];

  @override
  void initState() {
    iconlist.addAll({
      "Gaming Station": {
        0: "assets/console-normal.png",
        1: "assets/console-green.png"
      },
      "A.C.": {
        0: "assets/air-conditioner-normal.png",
        1: "assets/air-conditioner-green.png"
      }
    });
    // image.addAll({
    //   'Hall': "assets/hall.png",
    //   'Kitchen': "assets/kitchen.png",
    //   'Bedroom': "assets/bedroom.png",
    //   'Bathroom': "assets/bathroom.png",
    //   "Children's Room": "assets/Children's_Room.png",
    //   'Other': "assets/logo.png"
    // });
    super.initState();
  }

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
                              ),
                              PopupMenuItem(
                                value: index,
                                child: DropdownButton<String>(
                                  iconEnabledColor: dropcolor,
                                  items: Rooms.map((String listvalue) {
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
                                  onChanged: (val) {
                                    room = val;
                                    setState(() {
                                      fulldataofrooms.switches[
                                              "a" + (index + 1).toString()]
                                          ["icon"] = room;
                                    });
                                    dbref
                                        .child(user.uid)
                                        .child("rooms")
                                        .child(fulldataofrooms
                                            .roomidarray[fulldataofrooms.index])
                                        .child("circuit")
                                        .child(fulldataofrooms.boardidarray[
                                            fulldataofrooms.boardindex])
                                        .set(fulldataofrooms.switches);
                                    Navigator.pop(context);
                                  },
                                  value: room,
                                ),
                              ),
                            ],
                            context: context,
                            position: RelativeRect.fromRect(
                                _tapPosition & const Size(40, 40),
                                Offset.zero & overlay.size),
                          );
                          //
                        },
                        //switches//////////////////////////////////////////////////////////////////////////////////
                        onTap: () {
                          setState(() {
                            int flag = 0;
                            print(fulldataofrooms
                                .switches["a" + (index + 1).toString()]);
                            if (fulldataofrooms
                                        .switches["a" + (index + 1).toString()]
                                    ["val"] ==
                                0) {
                              flag = 1;
                            }
                            if (fulldataofrooms
                                        .switches["a" + (index + 1).toString()]
                                    ["icon"] ==
                                "null") {
                              icnstr = "assets/logo.png";
                            } else {
                              icnstr = iconlist[fulldataofrooms
                                      .switches["a" + (index + 1).toString()]
                                  ["icon"]][flag];
                            }
                            fulldataofrooms
                                    .switches["a" + (index + 1).toString()]
                                ["val"] = flag;
                            dbref
                                .child(user.uid)
                                .child("rooms")
                                .child(fulldataofrooms
                                    .roomidarray[fulldataofrooms.index])
                                .child("circuit")
                                .child(fulldataofrooms
                                    .boardidarray[fulldataofrooms.boardindex])
                                .child("a" + (index + 1).toString())
                                .child("val")
                                .set(flag);
                          });
                        },
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Container(
                                  height: 7 * SizeConfig.heightMultiplier,
                                  width: 30 * SizeConfig.widthMultiplier,
                                  child: Image(
                                    image: fulldataofrooms.switches["a" + (index + 1).toString()]
                                                ["icon"] ==
                                            "null"
                                        ? AssetImage("assets/logo.png")
                                        : AssetImage(iconlist[fulldataofrooms
                                                .switches["a" + (index + 1).toString()]
                                            ["icon"]][fulldataofrooms.switches[
                                                "a" + (index + 1).toString()]
                                            ["val"]]),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
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
                                    onSubmitted: (name) async {
                                      setState(() {
                                        if (fulldataofrooms.indexlist
                                                .contains(name) ==
                                            true) {
                                          Fluttertoast.showToast(
                                              msg: "Please use different Name");
                                        } else {
                                          dbref
                                              .child(user.uid)
                                              .child("index")
                                              .child(fulldataofrooms.switches[
                                                  "a" +
                                                      (index + 1)
                                                          .toString()]["name"])
                                              .remove();
                                          fulldataofrooms.indexlist.remove(
                                              fulldataofrooms.switches["a" +
                                                      (index + 1).toString()]
                                                  ["name"]);
                                          fulldataofrooms.indexlist.add(name);
                                          fulldataofrooms.switches[
                                                  "a" + (index + 1).toString()]
                                              ["name"] = name;
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
                                              .child("name")
                                              .set(name);

                                          dbref
                                              .child(user.uid)
                                              .child("index")
                                              .child(name)
                                              .set(fulldataofrooms.roomidarray[
                                                      fulldataofrooms.index] +
                                                  " " +
                                                  fulldataofrooms.boardidarray[
                                                      fulldataofrooms
                                                          .boardindex] +
                                                  " " +
                                                  "a" +
                                                  (index + 1).toString());
                                          edit = List.filled(5, false);
                                          focusnode = List.filled(5, false);
                                        }
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
              /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

              Container(
                child: Center(
                    child: Container(
                  height: 40 * SizeConfig.heightMultiplier,
                  width: 70 * SizeConfig.widthMultiplier,
                  child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                      size: 180,
                      startAngle: 210,
                      angleRange: 300,
                      customWidths: CustomSliderWidths(
                        progressBarWidth: 15,
                      ),
                      customColors: CustomSliderColors(
                        hideShadow: false,
                        trackColor: Color(0xff79848b),
                        progressBarColor: Colors.blue[300],
                        shadowMaxOpacity: 10,
                      ),
                      infoProperties: InfoProperties(
                        topLabelText: 'Regulator Speed',
                        modifier: (double value) {
                          return "${value.toInt()}";
                        },
                        topLabelStyle: TextStyle(
                          color: Color(0xff0792ef),
                          fontSize: 20,
                        ),
                      ),
                    ),
                    initialValue: fulldataofrooms
                        .switches["a" + (4 + 1).toString()]["val"]
                        .toDouble(),
                    min: 0,
                    max: 5,
                    // innerWidget: (double value) {
                    //   // use your custom widget inside the slider (gets a slider value from the callback)
                    //   return Text("regulator speed ${value}");
                    // },
                    onChange: (double value) {
                      print(value);

                      setState(() {
                        int flag = value.toInt();

                        fulldataofrooms.switches["a" + (4 + 1).toString()]
                            ["val"] = flag;
                        dbref
                            .child(user.uid)
                            .child("rooms")
                            .child(fulldataofrooms
                                .roomidarray[fulldataofrooms.index])
                            .child("circuit")
                            .child(fulldataofrooms
                                .boardidarray[fulldataofrooms.boardindex])
                            .child("a" + (4 + 1).toString())
                            .child("val")
                            .set(flag);
                      });
                    },
                  ),
                )),
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
