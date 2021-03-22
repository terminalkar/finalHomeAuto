import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:home_automation_app/responsive/Screensize.dart';
import 'package:home_automation_app/screens/profile_screen.dart';
import 'circuitboard.dart';
import 'fav.dart';
import 'main_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:home_automation/maindata.dart';
//import 'package:home_automation/circuit.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  var _tapPosition;
  String profilename = "default";
  var assetImageString;
  var assetImage;
  var image1;
  var _isRoomfetched = true;
  var image = new Map();
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  bool pressed = false;
  double _confidence = 1.0;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final dbref = FirebaseDatabase.instance.reference().child('Users');
  User user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    image.addAll({
      'Hall': "assets/hall.png",
      'Kitchen': "assets/kitchen.png",
      'Bedroom': "assets/bedroom.png",
      'Bathroom': "assets/bathroom.png",
      "Children's Room": "assets/Children's_Room.png",
      "Temple": "assets/temple.png",
      "Balcony": "assets/balcony.png",
      'Other': "assets/logo.png"
    });
    super.initState();
    fetchname();
    _roomData();
    _speech = stt.SpeechToText();
  }

  _roomData() async {
    setState(() {
      _isRoomfetched = true;
    });
    try {
      fulldataofrooms d = new fulldataofrooms();
      await d.fetchrooms();

      fulldataofrooms.roomidarray.sort();
    } catch (Ex) {
      print("exception honme roomdata");
    }
    setState(() {
      //
      _isRoomfetched = false;
    });
  }

// voice recognition speak
  void _listen() async {
    if (!_speech.isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');

          if (val == "listening") {
            setState(() => _isListening = true);
          } else {
            setState(() => _isListening = false);
          }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        _speech.listen(
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;
                  print(_text);

                  Fluttertoast.showToast(msg: "Running command " + _text);
                  if (val.hasConfidenceRating && val.confidence > 0) {
                    _confidence = val.confidence;
                  }
                  fulldataofrooms f = new fulldataofrooms();
                  f.solvequery(_text);
                }),
            listenFor: Duration(seconds: 10),
            partialResults: false,
            cancelOnError: true,
            listenMode: stt.ListenMode.confirmation);
      } else {
        setState(() => _isListening = false);
        _speech.stop();
        print(_isListening);
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      print(_isListening);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              AvatarGlow(
                  animate: _isListening,
                  glowColor: Theme.of(context).primaryColor,
                  endRadius: SizeConfig.widthMultiplier * 8,
                  duration: const Duration(milliseconds: 2000),
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  repeat: true,
                  child: IconButton(
                    icon:
                        Icon(_speech.isListening ? Icons.mic : Icons.mic_none),
                    onPressed: _listen,
                  ))
            ]),

        ////Drawer
        drawer: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              //This will change the drawer background to blue.
              //other styles
              selectedRowColor: Colors.blue.shade300),
          child: Container(
            width: SizeConfig.widthMultiplier * 61,
            child: Drawer(
              child: new ListView(
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    accountName: new Text(
                      profilename,
                      style: TextStyle(
                        fontFamily: "Amelia-Basic-Light",
                        fontSize: SizeConfig.textMultiplier * 2.5,
                        color: Color(0xff79848b),
                      ),
                    ),
                    accountEmail: new Text(user.email,
                        style: TextStyle(
                          fontFamily: "Amelia-Basic-Light",
                          fontSize: SizeConfig.textMultiplier * 2.5,
                          color: Color(0xff79848b),
                        )),
                    currentAccountPicture: new CircleAvatar(
                      radius: SizeConfig.heightMultiplier * 4.5,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: SizeConfig.imageSizeMultiplier * 15,
                        color: Color(0xff79848b),
                      ),
                    ),
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //     image: new AssetImage("assets/profile.jpg"),
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                  ),

                  Card(
                    child: new ListTile(
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(2.0, 0.0, 15.0, 0),
                              child: new Icon(
                                Icons.person,
                                color: Color(0xff79848b),
                                size: SizeConfig.imageSizeMultiplier * 5,
                              ),
                            ),
                            new Text(
                              "Profile",
                              style: TextStyle(
                                fontFamily: "Amelia-Basic-Light",
                                fontSize: SizeConfig.textMultiplier * 2.5,
                                color: Color(0xff79848b),
                              ),
                            )
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          color: Color(0xff79848b),
                        ),
                        onTap: () {
                          if (_scaffoldKey.currentState.isDrawerOpen) {
                            _scaffoldKey.currentState.openEndDrawer();
                          } else
                            _scaffoldKey.currentState.openDrawer();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => profile()));
                        }),
                  ),
                  //new Divider(),

                  Card(
                    child: new ListTile(
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                              child: new Icon(
                                Icons.thumb_up,
                                color: Color(0xff79848b),
                                size: SizeConfig.imageSizeMultiplier * 5,
                              ),
                            ),
                            new Text(
                              "Favourites",
                              style: TextStyle(
                                  fontFamily: "Amelia-Basic-Light",
                                  fontSize: SizeConfig.textMultiplier * 2.5,
                                  color: Color(0xff79848b)),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          color: Color(0xff79848b),
                        ),
                        onTap: pressed
                            ? null
                            : () async {
                                setState(() {
                                  pressed = true;
                                });
                                fulldataofrooms f1 = new fulldataofrooms();
                                await f1.fetchfavourites();
                                await f1.fetchfavouritescontentdata();

                                if (_scaffoldKey.currentState.isDrawerOpen) {
                                  _scaffoldKey.currentState.openEndDrawer();
                                } else
                                  _scaffoldKey.currentState.openDrawer();
                                setState(() {
                                  pressed = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => favourite()));
                              }),
                  ),
                  // new Divider(),
                  InkWell(
                    onTap: pressed
                        ? null
                        : () {
                            setState(() {
                              pressed = true;
                            });
                            FirebaseAuth.instance.signOut();
                            setState(() {
                              pressed = false;
                            });
                          },
                    child: Card(
                      child: new ListTile(
                          title: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    2.0, 0.0, 10.0, 0),
                                child: new Icon(
                                  Icons.phonelink_erase,
                                  color: Color(0xff79848b),
                                  size: SizeConfig.imageSizeMultiplier * 5,
                                ),
                              ),
                              new Text(
                                "Log out",
                                style: TextStyle(
                                    fontFamily: "Amelia-Basic-Light",
                                    fontSize: SizeConfig.textMultiplier * 2.5,
                                    color: Color(0xff79848b)),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_right,
                            color: Color(0xff79848b),
                          ),
                          onTap: () async {
                            if (_scaffoldKey.currentState.isDrawerOpen) {
                              _scaffoldKey.currentState.openEndDrawer();
                            } else
                              _scaffoldKey.currentState.openDrawer();
                            FirebaseAuth.instance.signOut();
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ////////////////////////////////////////////////////////////////////////////////////
        body: _isRoomfetched
            ? Center(child: CircularProgressIndicator())
            : fulldataofrooms.roomidmap.length == 0
                ? Center(
                    child: Text(
                    "No rooms added",
                    style: TextStyle(
                        fontFamily: "Amelia-Basic-Light",
                        fontSize: SizeConfig.textMultiplier * 2.5,
                        color: Color(0xff79848b)),
                  ))
                : AnimationLimiter(
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      children: List.generate(
                        fulldataofrooms.roomidarray.length,
                        (index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                  child: Padding(
                                padding: EdgeInsets.all(10),
                                child: InkWell(
                                  onTapDown: (TapDownDetails details) {
                                    _tapPosition = details.globalPosition;
                                  },
                                  //delete
                                  onLongPress: pressed
                                      ? null
                                      : () {
                                          setState(() {
                                            pressed = true;
                                          });
                                          final RenderBox overlay =
                                              Overlay.of(context)
                                                  .context
                                                  .findRenderObject();
                                          showMenu(
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        10.0)),
                                            items: <PopupMenuEntry>[
                                              PopupMenuItem(
                                                value: index,
                                                child: GestureDetector(
                                                  onTap: pressed
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            pressed = true;
                                                          });
                                                          try {
                                                            dbref
                                                                .child(user.uid)
                                                                .child("rooms")
                                                                .child(fulldataofrooms
                                                                        .roomidarray[
                                                                    index])
                                                                .remove();
                                                            setState(() {
                                                              fulldataofrooms
                                                                  .roomidmap
                                                                  .remove(fulldataofrooms
                                                                          .roomidarray[
                                                                      index]);
                                                              fulldataofrooms
                                                                  .roomidarray
                                                                  .remove(fulldataofrooms
                                                                          .roomidarray[
                                                                      index]);
                                                            });
                                                          } catch (ex) {
                                                            print("pop");
                                                          }
                                                          setState(() {
                                                            pressed = false;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                  child: Container(
                                                    height: SizeConfig
                                                            .heightMultiplier *
                                                        6,
                                                    child: Center(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(Icons.delete),
                                                          SizedBox(
                                                            width: SizeConfig
                                                                    .widthMultiplier *
                                                                6,
                                                          ),
                                                          Text(
                                                            "Delete Room",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Amelia-Basic-Light",
                                                                fontSize: SizeConfig
                                                                        .textMultiplier *
                                                                    2.5,
                                                                color: Color(
                                                                    0xff79848b)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                            context: context,
                                            position: RelativeRect.fromRect(
                                                _tapPosition &
                                                    const Size(40, 40),
                                                Offset.zero & overlay.size),
                                          );
                                          setState(() {
                                            pressed = false;
                                          });
                                          //
                                        },

                                  //Rooms//////////////////////////////////////////////////////////////////////////////////
                                  onTap: pressed
                                      ? null
                                      : () {
                                          setState(() {
                                            pressed = true;
                                            fulldataofrooms.index = index;
                                            fulldataofrooms.boardid =
                                                fulldataofrooms.id[
                                                    fulldataofrooms
                                                        .roomidarray[index]];
                                            fulldataofrooms.boardidarray =
                                                fulldataofrooms.array[
                                                    fulldataofrooms
                                                        .roomidarray[index]];
                                          });
                                          if (fulldataofrooms.boardidarray ==
                                                  null ||
                                              fulldataofrooms.boardid == null) {
                                            fulldataofrooms.boardidarray = [];
                                            fulldataofrooms.boardid = new Map();
                                          } else {
                                            fulldataofrooms.boardidarray.sort();
                                          }
                                          setState(() {
                                            pressed = false;
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Circuit()));
                                        },
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            margin: EdgeInsets.all(10),
                                            child: Image(
                                              image: AssetImage(image[
                                                  fulldataofrooms.roomidmap[
                                                      fulldataofrooms
                                                              .roomidarray[
                                                          index]]["type"]]),
                                            ),
                                          ),
                                        ),
                                        Text(
                                            fulldataofrooms.roomidmap[
                                                    fulldataofrooms
                                                        .roomidarray[index]]
                                                ["name"],
                                            style: TextStyle(
                                              fontFamily: "Amelia-Basic-Light",
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      2.5,
                                              color: Color(0xff79848b),
                                            )),
                                      ],
                                    ),
                                    height: SizeConfig.heightMultiplier * 18,
                                    width: SizeConfig.widthMultiplier * 45,
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
                                      borderRadius: BorderRadius.circular(8.0),
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
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.blue,
            onPressed: pressed
                ? null
                : () {
                    setState(() {
                      pressed = true;
                    });
                    try {
                      _addroom(context);
                    } catch (Exc) {
                      print(Exc);
                    }
                    setState(() {
                      pressed = false;
                    });
                  },
            tooltip: 'Increment',
            label: Text("Add Rooms"),
            icon: Icon(Icons.add)),
      ),
    );
  }

  void fetchname() async {
    try {
      await dbref
          .child(user.uid)
          .child("info")
          .child("Name")
          .once()
          .then((value) {
        profilename = value.value;
      });
    } catch (ex) {
      print("exception in name fetching");
      profilename = "a";
    }
  }
}

_addroom(BuildContext context) async {
  bool pressed = false;
  final dbref = FirebaseDatabase.instance.reference().child('Users');
  final form = new GlobalKey<FormState>();
  Color dropcolor = Color(0xff79848b);
  String room = 'Select';
  List<String> Rooms = [
    'Select',
    'Hall',
    'Kitchen',
    'Bedroom',
    'Bathroom',
    "Children's Room",
    'Temple',
    'Balcony',
    'Other',
  ];
  FocusNode focusNode = new FocusNode();
  TextEditingController name = TextEditingController();

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
                height: SizeConfig.heightMultiplier * 100 / (5.33),
                width: SizeConfig.widthMultiplier * 111,
                child: Column(
                  children: <Widget>[
                    Form(
                      key: form,
                      child: new TextFormField(
                        textAlign: TextAlign.center,
                        controller: name,
                        onChanged: (val) {},
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
                          labelText: "Room name",
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
                      width: SizeConfig.widthMultiplier * 50,
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
                              room = val;
                              focusNode = new FocusNode();
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
                                setState(() {
                                  pressed = true;
                                });
                                if (room != "Select" && name.text != "") {
                                  String noofrooms;
                                  int max = 0;
                                  for (int i = 0;
                                      i < fulldataofrooms.roomidarray.length;
                                      i++) {
                                    String s = fulldataofrooms.roomidarray[i];

                                    int n = int.parse(s.substring(4));
                                    if (n > max) max = n;
                                  }
                                  max++;
                                  if (max < 10)
                                    noofrooms = "0" + max.toString();
                                  else
                                    noofrooms = max.toString();

                                  await dbref
                                      .child(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .child("rooms")
                                      .child("room" + noofrooms)
                                      .set({
                                    "name": name.text,
                                    "type": room,
                                    "circuit": -1
                                  });

                                  setState(() async {
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Homepage()));
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please select the type of room");
                                }
                                setState(() {
                                  pressed = false;
                                });
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
