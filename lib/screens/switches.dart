import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:home_automation_app/responsive/Screensize.dart';
import 'package:home_automation_app/screens/main_data.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class switches extends StatefulWidget {
  @override
  _switchesState createState() => _switchesState();
}

class _switchesState extends State<switches> {
  var _tapPosition;
  final dbref = FirebaseDatabase.instance.reference().child("Users");
  User user = FirebaseAuth.instance.currentUser;
  var edit = List.filled(5, false);
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
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                edit[index] = true;
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
                            margin: EdgeInsets.all(10),
                            child: LiteRollingSwitch(
                              value: fulldataofrooms.switches[
                                      "a" + (index + 1).toString()]["val"]==1
                                  ? true
                                  : false,
                              textOn: 'Active',
                              textOff: 'Inactive',
                              colorOn: Colors.greenAccent,
                              colorOff: Color(0xff79848b),
                              iconOn: Icons.lightbulb_outline,
                              iconOff: Icons.power_settings_new,
                              textSize: 14,
                              onChanged: (bool state) {
                                print('turned ${(state) ? 'on' : 'off'}');
                                int flag = 0;
                                if (state) {
                                  flag = 1;
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
                                    .child(fulldataofrooms.boardidarray[
                                        fulldataofrooms.boardindex])
                                    .child("a" + (index + 1).toString())
                                    .child("val")
                                    .set(flag);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            width: 15 * SizeConfig.heightMultiplier,
                            child: TextField(
                              focusNode: new FocusNode(),
                              controller:TextEditingController()..text = fulldataofrooms
                                .switches["a" + (index + 1).toString()]["name"],
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
                                  fulldataofrooms.switches["a" +
                                      (index + 1).toString()]["name"] = name;
                                  dbref
                                      .child(user.uid)
                                      .child("rooms")
                                      .child(fulldataofrooms
                                          .roomidarray[fulldataofrooms.index])
                                      .child("circuit")
                                      .child(fulldataofrooms.boardidarray[
                                          fulldataofrooms.boardindex])
                                      .child("a" + (index + 1).toString())
                                      .child("name")
                                      .set(name);
                                  edit = List.filled(5, false);
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
      ),
    );
  }
}
