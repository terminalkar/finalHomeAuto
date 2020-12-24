import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_automation_app/responsive/Screensize.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation_app/screens/main_data.dart';
import 'package:home_automation_app/screens/switches.dart';

class Circuit extends StatefulWidget {
  @override
  _CircuittState createState() => _CircuittState();
}

class _CircuittState extends State<Circuit> {
  @override
  void dispose() {
    super.dispose();
  }

  // Future<bool> _onbackpressed() {}
  bool isboardfetch = true;
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
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
                  ? ListView.builder(
                      padding: kMaterialListPadding,
                      itemCount: fulldataofrooms.boardidarray.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: SizeConfig.grp <= 4
                              ? 10 * SizeConfig.heightMultiplier
                              : 8.8 * SizeConfig.heightMultiplier,
                          child: Container(
                            height: 300.00,
                            width: 400.00,
                            margin: EdgeInsets.all(10),
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
                            child: Card(
                              //elevation: 20,
                              // shape: new RoundedRectangleBorder(
                              //     borderRadius:
                              //         new BorderRadius.circular(15.0)),
                              child: ListTile(
                                onLongPress: () async {},
                                onTap: () async {
                                  fulldataofrooms.switches =
                                      fulldataofrooms.boardid[
                                          fulldataofrooms.boardidarray[index]];
                                  fulldataofrooms.boardindex = index;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => switches(),
                                      ));
                                },
                                isThreeLine: false,
                                // leading: Text("hello",
                                //     style: TextStyle(
                                //       fontFamily: "Amelia-Basic-Light",
                                //       color: Color(0xff79848b),
                                //       fontSize: 2.2 * SizeConfig.textMultiplier,
                                //     )),
                                leading: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(Icons.bookmark_border_outlined),
                                ),
                                title: Text(
                                  fulldataofrooms.boardidarray[index],
                                  style: TextStyle(
                                    fontSize: 2 * SizeConfig.textMultiplier,
                                    color: Color(0xff997a00),
                                  ),
                                ),
                                trailing: Icon(Icons.navigate_next_outlined),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: new Text("Add Boards ",
                          style: TextStyle(
                              fontSize: 3 * SizeConfig.textMultiplier,
                              color: Color(0xff898989)))),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          try {
            _addboard(context);
          } catch (Exc) {
            print(Exc);
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
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
                            controller: id,
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
                                  if (id.text != "") {
                                    String noofboards;
                                    int max = 0;
                                    for (int i = 0;
                                        i < fulldataofrooms.boardidarray.length;
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

                                    dbref
                                        .child(FirebaseAuth
                                            .instance.currentUser.uid)
                                        .child("rooms")
                                        .child(fulldataofrooms
                                            .roomidarray[fulldataofrooms.index])
                                        .child("circuit")
                                        .child("board" + noofboards.toString())
                                        .set({
                                      "bid": id.text,
                                      "a1": 0,
                                      "a2": 0,
                                      "a3": 0,
                                      "a4": 0,
                                      "a5": 0
                                    });

                                    setState(() async {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Circuit()));
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Please Enter valid Id");
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
}
