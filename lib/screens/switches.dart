import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  var iconStr = false, pressed = false;
  Icon obj;
  bool show = true;
  var icnstr = "assets/kitchen.png";
  var image = new Map();
  var iconlist = new Map();
  var controllerlist = List.filled(4, TextEditingController());
  final _focusNode = FocusNode();
  Color dropcolor = Color(0xff79848b);
  String room = 'Select Type';
  void addicon() {
    iconlist.addAll({
      "Gaming Station": {
        0: "assets/console-normal.png",
        1: "assets/console-green.png"
      },
      "Bulb": {0: "assets/bulb.png", 1: "assets/bulb-green.png"},
      "Exhaust Fan": {0: "assets/exhaust.png", 1: "assets/exhaust-green.png"},
      "A.C.": {
        0: "assets/air-conditioner-normal.png",
        1: "assets/air-conditioner-green.png"
      },
      "Chimney": {
        0: "assets/chimney-normal.png",
        1: "assets/chimney-green.png"
      },
      "Dressing Table": {
        0: "assets/dressing-table-normal.png",
        1: "assets/dressing-table-green.png"
      },
      "Fan": {0: "assets/fan-normal.png", 1: "assets/fan-green.png"},
      "Refrigerator": {
        0: "assets/fridge-normal.png",
        1: "assets/fridge-green.png"
      },
      "Geyser": {0: "assets/heater-normal.png", 1: "assets/heater-green.png"},
      "Home Theater": {
        0: "assets/home-theater-normal.png",
        1: "assets/home-theater-green.png"
      },
      "Tubelight": {
        0: "assets/tubelight-normal.png",
        1: "assets/tubelight-green.png"
      },
      "Charging Plug": {
        0: "assets/plug-normal.png",
        1: "assets/plug-green.png"
      },
      "Microwave": {
        0: "assets/microwave-normal.png",
        1: "assets/microwave-green.png"
      },
      "Pump": {0: "assets/pump-normal.png", 1: "assets/pump-green.png"},
      "Induction Stove": {
        0: "assets/induction-stove-normal.png",
        1: "assets/induction-stove-green.png"
      },
      "LED Bulb": {0: "assets/led-normal.png", 1: "assets/led-green.png"},
      "Table Lamp": {
        0: "assets/table-lamp-normal.png",
        1: "assets/table-lamp-green.png"
      },
      "Television": {0: "assets/tv-normal.png", 1: "assets/tv-green.png"},
      "Washing Machine": {
        0: "assets/washing-machine-normal.png",
        1: "assets/washing-machine-green.png"
      },
      "Water Filter": {
        0: "assets/water-filter-normal.png",
        1: "assets/water-filter-green.png"
      },
    });
  }

  void fetch() async {
    fulldataofrooms f1 = new fulldataofrooms();
    setState(() {
      fulldataofrooms.fetched = false;
    });

    try {
      f1.fetchfavourites();
      await f1.fetchindex();

      await f1.fetchboards();
      fulldataofrooms.boardidarray.sort();
    } catch (Ex) {
      print("on tap circuit");
    }
    setState(() {
      show = false;
    });
  }

  @override
  void initState() {
    addicon();
    fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(FontAwesomeIcons.arrowLeft),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.blue,
          title: Text(
            'Switches',
            style: TextStyle(color: Colors.white),
          ),
        ),

        ////////////////////////////////////////////////////////////////////////////////////
        body: show
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    AnimationLimiter(
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        children: List.generate(
                          4,
                          (index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                    child: Padding(
                                  padding: EdgeInsets.all(
                                      SizeConfig.widthMultiplier * 2.8),
                                  child: InkWell(
                                    onTapDown: (TapDownDetails details) {
                                      _tapPosition = details.globalPosition;
                                    },
                                    //switches//////////////////////////////////////////////////////////////////////////////////
                                    onTap: pressed
                                        ? null
                                        : () {
                                            setState(() {
                                              int flag = 0;
                                              pressed = true;
                                              if (fulldataofrooms.switches["a" +
                                                      (index + 1)
                                                          .toString()]["val"] ==
                                                  0) {
                                                flag = 1;
                                              }
                                              if (flag == 0) {
                                                fulldataofrooms.linktofav(
                                                    fulldataofrooms.roomidarray[
                                                            fulldataofrooms
                                                                .index] +
                                                        fulldataofrooms
                                                                .boardidarray[
                                                            fulldataofrooms
                                                                .boardindex] +
                                                        "a" +
                                                        (index + 1).toString());
                                              }
                                              if (fulldataofrooms.switches["a" +
                                                          (index + 1)
                                                              .toString()]
                                                      ["icon"] ==
                                                  "null") {
                                                icnstr = "assets/logo.png";
                                              } else {
                                                icnstr = iconlist[
                                                    fulldataofrooms.switches[
                                                            "a" +
                                                                (index + 1)
                                                                    .toString()]
                                                        ["icon"]][flag];
                                              }
                                              fulldataofrooms.switches["a" +
                                                      (index + 1).toString()]
                                                  ["val"] = flag;
                                              dbref
                                                  .child(user.uid)
                                                  .child("rooms")
                                                  .child(fulldataofrooms
                                                          .roomidarray[
                                                      fulldataofrooms.index])
                                                  .child("circuit")
                                                  .child(fulldataofrooms
                                                          .boardidarray[
                                                      fulldataofrooms
                                                          .boardindex])
                                                  .child("a" +
                                                      (index + 1).toString())
                                                  .child("val")
                                                  .set(flag);
                                              pressed = false;
                                            });
                                          },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  size: SizeConfig
                                                          .widthMultiplier *
                                                      7,
                                                  color: Colors.grey[400],
                                                ),
                                                onPressed: pressed
                                                    ? null
                                                    : () async {
                                                        await _Rename(
                                                            context, index);
                                                        edit = List.filled(
                                                            5, false);
                                                        focusnode = List.filled(
                                                            5, false);
                                                      },
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.star_border,
                                                  size: SizeConfig
                                                          .widthMultiplier *
                                                      7,
                                                  color: Colors.yellow[400],
                                                ),
                                                onPressed: pressed
                                                    ? null
                                                    : () async {
                                                        setState(() {
                                                          pressed = true;
                                                        });
                                                        await favouritesdialogbox(
                                                            context, index);
                                                        setState(() {
                                                          pressed = false;
                                                        });
                                                      },
                                              ),
                                            ],
                                          ),

                                          // SizedBox(
                                          //   height: SizeConfig.widthMultiplier * 2.5,
                                          // ),
                                          Center(
                                            child: Container(
                                              height: 7 *
                                                  SizeConfig.heightMultiplier,
                                              width: 30 *
                                                  SizeConfig.widthMultiplier,
                                              child: Image(
                                                image: fulldataofrooms
                                                                .switches["a" + (index + 1).toString()]
                                                            ["icon"] ==
                                                        "null"
                                                    ? AssetImage(
                                                        "assets/logo.png")
                                                    : AssetImage(iconlist[fulldataofrooms
                                                            .switches["a" + (index + 1).toString()]
                                                        ["icon"]][fulldataofrooms
                                                            .switches["a" + (index + 1).toString()]
                                                        ["val"]]),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 20,
                                          // ),
                                          Center(
                                            child: Container(
                                              width: 14 *
                                                  SizeConfig.heightMultiplier,
                                              child: TextField(
                                                enableInteractiveSelection:
                                                    true,
                                                autofocus: focusnode[index],
                                                focusNode: new FocusNode(),
                                                controller:
                                                    TextEditingController()
                                                      ..text = fulldataofrooms
                                                                  .switches[
                                                              "a" +
                                                                  (index + 1)
                                                                      .toString()]
                                                          ["name"],
                                                expands: false,
                                                enabled: edit[index],
                                                textInputAction:
                                                    TextInputAction.go,
                                                keyboardType:
                                                    TextInputType.text,
                                                style: TextStyle(
                                                  fontFamily:
                                                      "Amelia-Basic-Light",
                                                  fontSize: SizeConfig
                                                          .textMultiplier *
                                                      2.5,
                                                  color: Color(0xff79848b),
                                                ),
                                                onSubmitted: (name) async {},
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                                    ),
                                  ),
                                )),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                    Container(
                      child: Center(
                          child: Container(
                        height: SizeConfig.grp > 3
                            ? 35 * SizeConfig.heightMultiplier
                            : 25 * SizeConfig.heightMultiplier,
                        width: 55 * SizeConfig.widthMultiplier,
                        child: SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                            animDurationMultiplier: 2.0,
                            size: 180,
                            startAngle: 210,
                            angleRange: 300,
                            customWidths: CustomSliderWidths(
                              progressBarWidth: 10,
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
                                  fontSize: SizeConfig.heightMultiplier * 2.5),
                            ),
                          ),
                          initialValue: fulldataofrooms
                              .switches["a" + (4 + 1).toString()]["val"]
                              .toDouble(),
                          min: 0,
                          max: 5,
                          onChange: (double value) {
                            print(value);

                            setState(() {
                              int flag = 0;
                              if (fulldataofrooms
                                      .switches["a" + (4 + 1).toString()]["val"]
                                      .toDouble() >
                                  value) {
                                flag = value.floor().toInt();
                              } else {
                                flag = value.ceil().toInt();
                              }

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
                  title: Center(
                    child: Text(
                      'Details',
                      style: TextStyle(
                        fontFamily: "Amelia-Basic-Light",
                        fontSize: 3 * SizeConfig.textMultiplier,
                        color: Color(0xff79848b),
                      ),
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
                                fontSize: SizeConfig.textMultiplier * 2.5,
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
                                  fontSize: SizeConfig.textMultiplier * 2.5,
                                  color: Color(0xff79848b),
                                ),
                              ),
                            );
                          }).toList(),
                          value: dropdownfavouriteroom,
                          onChanged: (val) {
                            setState(() {
                              id.text = "";
                              dropdownfavouriteroom = val.toString();
                            });
                          },
                        )
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
                                      String board =
                                          fulldataofrooms.boardidarray[
                                              fulldataofrooms.boardindex];
                                      String switchh =
                                          ('a' + (index + 1).toString());
                                      dbref
                                          .child(FirebaseAuth
                                              .instance.currentUser.uid)
                                          .child("favourites")
                                          .child(flag)
                                          .child(room + board + switchh)
                                          .set(room +
                                              " " +
                                              board +
                                              " " +
                                              switchh);

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
                    ),
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
                                fontSize: SizeConfig.textMultiplier * 2.5,
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

_Rename(BuildContext context, int index) async {
  bool pressed = false;
  User user = FirebaseAuth.instance.currentUser;
  final dbref = FirebaseDatabase.instance.reference().child('Users');
  final form = new GlobalKey<FormState>();
  Color dropcolor = Color(0xff79848b);
  String room = 'Select Type';

  FocusNode focusNode = new FocusNode();
  TextEditingController name = TextEditingController();
  List<String> Rooms = [
    'Select Type',
    'A.C.',
    'Gaming Station',
    'Bulb',
    'Exhaust Fan',
    'Chimney',
    'Dressing Table',
    "Fan",
    "Refrigerator",
    "Geyser",
    "Home Theater",
    "Tubelight",
    'Charging Plug',
    "Microwave",
    "Pump",
    "Induction Stove",
    "LED Bulb",
    "Table Lamp",
    "Television",
    "Washing Machine",
    "Water Filter",
  ];
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Center(
                child: Text(
                  'Details of Room',
                  style: TextStyle(
                    fontFamily: "Amelia-Basic-Light",
                    fontSize: SizeConfig.heightMultiplier * 3,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff79848b),
                  ),
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
                        validator: validationofthename,
                        textAlign: TextAlign.center,
                        controller: name,
                        onChanged: (val) {
                          val =
                              val.toString().replaceAll(new RegExp(r'\W'), "");
                        },
                        cursorColor: Colors.black87,
                        focusNode: focusNode,
                        style: TextStyle(
                          fontFamily: "Amelia-Basic-Light",
                          fontSize: SizeConfig.textMultiplier * 2.5,
                          color: Color(0xff79848b),
                        ),
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xff444422),
                              ),
                              borderRadius: BorderRadius.circular(10.00)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: "Switch name",
                          labelStyle: TextStyle(
                            fontFamily: "Amelia-Basic-Light",
                            fontSize: SizeConfig.textMultiplier * 3.2,
                            color: Color(0xff79848b),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.widthMultiplier * 2.5),
                    Container(
                      height: SizeConfig.heightMultiplier * 6,
                      width: SizeConfig.grp < 4
                          ? SizeConfig.widthMultiplier * 50
                          : SizeConfig.widthMultiplier * 55,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0.00, 3.00),
                            color: Color(0xff0792ef).withOpacity(0.32),
                            blurRadius: 6,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(4.00),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          iconEnabledColor: dropcolor,
                          items: Rooms.map((String listvalue) {
                            return DropdownMenuItem<String>(
                              value: listvalue,
                              child: Text(
                                listvalue,
                                style: TextStyle(
                                  fontFamily: "Amelia-Basic-Light",
                                  fontSize: SizeConfig.textMultiplier * 2.5,
                                  color: Color(0xff79848b),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              room = val.toString();
                            });
                          },
                          value: room,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Container(
                  height: SizeConfig.heightMultiplier * 6,
                  width: SizeConfig.widthMultiplier * 25,
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
                            fontSize: SizeConfig.textMultiplier * 2.5,
                            color: Color(0xff79848b),
                          ),
                        ),
                        onPressed: pressed
                            ? () => null
                            : () async {
                                if (form.currentState.validate()) {
                                  setState(() {
                                    pressed = true;
                                  });
                                  if (room != "Select Type" &&
                                      name.text != "") {
                                    name.text = name.text
                                        .replaceAll(new RegExp(r'\W'), "");
                                    try {
                                      await dbref
                                          .child(user.uid)
                                          .child("index")
                                          .child(fulldataofrooms.switches["a" +
                                              (index + 1).toString()]["name"])
                                          .remove();

                                      setState(() {
                                        fulldataofrooms.indexlist.remove(
                                            fulldataofrooms.switches["a" +
                                                    (index + 1).toString()]
                                                ["name"]);
                                        fulldataofrooms.indexlist
                                            .add(name.text);
                                        fulldataofrooms.switches[
                                                "a" + (index + 1).toString()]
                                            ["name"] = name.text;
                                        fulldataofrooms.switches[
                                                "a" + (index + 1).toString()]
                                            ["icon"] = room;
                                      });

                                      dbref
                                          .child(user.uid)
                                          .child("index")
                                          .child(name.text)
                                          .set(fulldataofrooms.roomidarray[
                                                  fulldataofrooms.index] +
                                              " " +
                                              fulldataofrooms.boardidarray[
                                                  fulldataofrooms.boardindex] +
                                              " " +
                                              "a" +
                                              (index + 1).toString());
                                      await dbref
                                          .child(user.uid)
                                          .child("rooms")
                                          .child(fulldataofrooms.roomidarray[
                                              fulldataofrooms.index])
                                          .child("circuit")
                                          .child(fulldataofrooms.boardidarray[
                                              fulldataofrooms.boardindex])
                                          .set(fulldataofrooms.switches);
                                    } catch (e) {}
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => switches()));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Please select the type of room");
                                  }
                                  setState(() {
                                    pressed = false;
                                  });
                                }
                              }),
                  ),
                ),
                SizedBox(width: SizeConfig.widthMultiplier * 2.5),
                Container(
                  height: SizeConfig.heightMultiplier * 6,
                  width: SizeConfig.widthMultiplier * 25,
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
                          fontSize: SizeConfig.textMultiplier * 2.5,
                          color: Color(0xff79848b),
                        ),
                      ),
                      onPressed: pressed == false
                          ? () async {
                              Navigator.of(context).pop();
                            }
                          : null,
                    ),
                  ),
                )
              ],
            );
          },
        );
      });
}

String validationofthename(String value) {
  value=value.replaceAll(new RegExp(r'\W'), "");
  Pattern pattern = r'^[a-zA-Z_ ]*$';
  RegExp regex = new RegExp(pattern);
  print(fulldataofrooms.indexlist);
  if (value.isEmpty ||
      !regex.hasMatch(value) ||
      fulldataofrooms.indexlist.contains(value) == true) {
    return "Only Alphabets and unique name allowed";
  } else {
    return null;
  }
}
