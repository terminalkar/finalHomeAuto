import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:home_automation_app/screens/main_data.dart';

class switches extends StatefulWidget {
  @override
  _switchesState createState() => _switchesState();
}

class _switchesState extends State<switches> {
  var _tapPosition;
  final dbref = FirebaseDatabase.instance.reference().child("Users");
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Switches',
            style: TextStyle(color: Colors.white),
          ),
        ),

        ////////////////////////////////////////////////////////////////////////////////////
        body: GridView.count(
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
                  //delete
                  onLongPress: () {
                    final RenderBox overlay =
                        Overlay.of(context).context.findRenderObject();
                    showMenu(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      items: <PopupMenuEntry>[
                        PopupMenuItem(
                          value: index,
                          child: GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.delete),
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
                  onTap: () {
                    int flag = 1;
                    if (fulldataofrooms
                            .switches["a" + (index + 1).toString()] ==
                        1) {
                      flag = 0;
                    }
                    fulldataofrooms.switches["a" + (index + 1).toString()] =
                        flag;
                    dbref
                        .child(user.uid)
                        .child("rooms")
                        .child(
                            fulldataofrooms.roomidarray[fulldataofrooms.index])
                        .child("circuit")
                        .child(fulldataofrooms
                            .boardidarray[fulldataofrooms.boardindex])
                        .child("a" + (index + 1).toString())
                        .set(flag);
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
                                image: AssetImage("assets/logo.png"),
                              ),
                            ),
                            Text(index.toString())
                          ],
                        ),
                        Text(
                            // button name
                            "buttons",
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
      ),
    );
  }
}
