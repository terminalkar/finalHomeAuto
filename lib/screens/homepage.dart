import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'circuitboard.dart';
import 'main_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
////import 'package:home_automation/Login_page.dart';
//import 'package:home_automation/responsive/Screesize.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:fluttertoast/fluttertoast.dart';
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
  List<String> _list = [];
  var _tapPosition;
  var assetImageString;
  var assetImage;
  var image1;
  var _isRoomfetched = true;
  var image = new Map();

  // "assets/Children's_Room.png",
  // "assets/Children's_Room.png",
  // "assets/Children's_Room.png",
  // "assets/Children's_Room.png",
  // "assets/logo.png",

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
      'Other': "assets/logo.png"
    });
    super.initState();
    _roomData();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
        ),

        ////Drawer
        drawer: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              //This will change the drawer background to blue.
              //other styles
              selectedRowColor: Colors.blue.shade300),
          child: Container(
            width: 300,
            child: Drawer(
              child: new ListView(
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    accountName: new Text(
                      "Name",
                      style: TextStyle(
                        fontFamily: "Amelia-Basic-Light",
                        fontSize: 16,
                        color: Color(0xff79848b),
                      ),
                    ),
                    accountEmail: new Text(user.email,
                        style: TextStyle(
                          fontFamily: "Amelia-Basic-Light",
                          fontSize: 16,
                          color: Color(0xff79848b),
                        )),
                    currentAccountPicture: new CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 60,
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
                                size: 10,
                              ),
                            ),
                            new Text(
                              "Profile",
                              style: TextStyle(
                                fontFamily: "Amelia-Basic-Light",
                                fontSize: 16,
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
                          //Navigator.pop(context);
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
                                size: 10,
                              ),
                            ),
                            new Text(
                              "Like Us",
                              style: TextStyle(
                                  fontFamily: "Amelia-Basic-Light",
                                  fontSize: 16,
                                  color: Color(0xff79848b)),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          color: Color(0xff79848b),
                        ),
                        onTap: () {
                          //Navigator.pop(context);
                        }),
                  ),
                  // new Divider(),
                  Card(
                    child: new ListTile(
                        title: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(2.0, 0.0, 10.0, 0),
                              child: new Icon(
                                Icons.phonelink_erase,
                                color: Color(0xff79848b),
                                size: 10,
                              ),
                            ),
                            new Text(
                              "Log out",
                              style: TextStyle(
                                  fontFamily: "Amelia-Basic-Light",
                                  fontSize: 16,
                                  color: Color(0xff79848b)),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_right,
                          color: Color(0xff79848b),
                        ),
                        onTap: () async {
                          FirebaseAuth.instance.signOut();
                        }),
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
                        fontSize: 16,
                        color: Color(0xff79848b)),
                  ))
                : GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    shrinkWrap: true,
                    children: List.generate(
                      fulldataofrooms.roomidarray.length,
                      (index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTapDown: (TapDownDetails details) {
                              _tapPosition = details.globalPosition;
                            },
                            //delete
                            onLongPress: () {
                              final RenderBox overlay = Overlay.of(context)
                                  .context
                                  .findRenderObject();
                              showMenu(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                                items: <PopupMenuEntry>[
                                  PopupMenuItem(
                                    value: index,
                                    child: GestureDetector(
                                      onTap: () {
                                        try {
                                          dbref
                                              .child(user.uid)
                                              .child("rooms")
                                              .child(fulldataofrooms
                                                  .roomidarray[index])
                                              .remove();
                                          setState(() {
                                            fulldataofrooms.roomidmap.remove(
                                                fulldataofrooms
                                                    .roomidarray[index]);
                                            fulldataofrooms.roomidarray.remove(
                                                fulldataofrooms
                                                    .roomidarray[index]);
                                          });
                                        } catch (ex) {
                                          print("pop");
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.delete),
                                          SizedBox(
                                            width: 25,
                                          ),
                                          Text(
                                            "Delete slot",
                                            style: TextStyle(
                                                fontFamily:
                                                    "Amelia-Basic-Light",
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

                            //Rooms//////////////////////////////////////////////////////////////////////////////////
                            onTap: () {
                              setState(() {
                                fulldataofrooms.index = index;
                                fulldataofrooms.boardid = fulldataofrooms
                                    .id[fulldataofrooms.roomidarray[index]];
                                fulldataofrooms.boardidarray = fulldataofrooms
                                    .array[fulldataofrooms.roomidarray[index]];
                              });
                              if (fulldataofrooms.boardidarray == null ||
                                  fulldataofrooms.boardid == null) {
                                fulldataofrooms.boardidarray = [];
                                fulldataofrooms.boardid = new Map();
                              } else {
                                fulldataofrooms.boardidarray.sort();
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Circuit()));
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        margin: EdgeInsets.all(10),
                                        child: Image(
                                          image: AssetImage(image[
                                              fulldataofrooms.roomidmap[
                                                      fulldataofrooms
                                                          .roomidarray[index]]
                                                  ["type"]]),
                                        ),
                                      ),
                                      Text(index.toString())
                                    ],
                                  ),
                                  Text(
                                      fulldataofrooms.roomidmap[fulldataofrooms
                                          .roomidarray[index]]["name"],
                                      style: TextStyle(
                                        fontFamily: "Amelia-Basic-Light",
                                        fontSize: 16,
                                        color: Color(0xff79848b),
                                      )),
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            try {
              _addroom(context);
            } catch (Exc) {
              print(Exc);
            }
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      ),
    );
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
    'Other',
  ];
  FocusNode focusNode = new FocusNode();
  TextEditingController name = TextEditingController();
  return showGeneralDialog(
      // barrierColor: Colors.black.withOpacity(0.5),
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
                    fontSize: 20,
                    color: Color(0xff79848b),
                  ),
                ),
                content: Container(
                  height: 200,
                  width: 400,
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: form,
                        child: new TextFormField(
                          controller: name,
                          onChanged: (val) {},
                          cursorColor: Colors.black87,
                          focusNode: focusNode,
                          style: TextStyle(
                            fontFamily: "Amelia-Basic-Light",
                            fontSize: 16,
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
                            labelText: "Room name",
                            labelStyle: TextStyle(
                              fontFamily: "Amelia-Basic-Light",
                              fontSize: 16,
                              color: Color(0xff79848b),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.all(5),
                        height: 40.00,
                        width: 150.00,
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
                          },
                          value: room,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Container(
                    height: 40.00,
                    width: 100.00,
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
                            fontSize: 16,
                            color: Color(0xff79848b),
                          ),
                        ),
                        onPressed: pressed
                            ? null
                            : () async {
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
                                  print("sdf");
                                  print(noofrooms);
                                  dbref
                                      .child(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .child("rooms")
                                      .child("room" + noofrooms)
                                      .set({
                                    "name": name.text,
                                    "type": room,
                                    "circuit": -1
                                  });

                                  dbref
                                      .child(
                                          FirebaseAuth.instance.currentUser.uid)
                                      .child("info")
                                      .child("noofrooms")
                                      .set(noofrooms);
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
                              }),
                  ),
                  Container(
                    height: 40.00,
                    width: 100.00,
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
                      onPressed: pressed == false
                          ? () async {
                              Navigator.of(context).pop();
                            }
                          : null,
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
