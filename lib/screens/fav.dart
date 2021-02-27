import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation_app/responsive/Screensize.dart';
import 'package:home_automation_app/screens/main_data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class favourite extends StatefulWidget {
  @override
  _favouriteState createState() => _favouriteState();
}

class _favouriteState extends State<favourite> {
  var _tapPosition;
  int globalindex;
  String globalvalue;
  final dbref = FirebaseDatabase.instance.reference().child('Users');
  User user = FirebaseAuth.instance.currentUser;
  List<PopupMenuItem> fun(BuildContext context, String name) {
    try {
      Fluttertoast.showToast(msg: name);
      var elements = fulldataofrooms.favouritecontentnamesmap[name];
      var sList = List<String>.from(elements);
      // var l = elements.Cast<String>().ToList();
      Fluttertoast.showToast(msg: sList.runtimeType.toString());

      List<PopupMenuItem> t = sList
          .map((String e) => PopupMenuItem<String>(
                value: e,
                child: Text(e),
              ))
          .toList();
      // print(fulldataofrooms.favroomsarray.length);
      return t;
    } catch (ex) {
      Fluttertoast.showToast(msg: "null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        shrinkWrap: true,
        children: List.generate(
          fulldataofrooms.favroomsarray.length - 1,
          (index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTapDown: (TapDownDetails details) {
                  _tapPosition = details.globalPosition;
                },
                //Rename
                onLongPress: () async {
                  final RenderBox overlay =
                      Overlay.of(context).context.findRenderObject();
                },

                //switches//////////////////////////////////////////////////////////////////////////////////

                onTap: () {},
                child: Container(
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Center(
                              child: Row(
                                children: [
                                  Container(
                                    height: 6 * SizeConfig.heightMultiplier,
                                    width: 20 * SizeConfig.widthMultiplier,
                                    margin: EdgeInsets.all(10.0),
                                    child: Text(
                                      fulldataofrooms.favroomsarray[index + 1],
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: PopupMenuButton(
                                      // initialValue: ,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10.0)),
                                      onSelected: (val) {
                                        confirm(index, val, context);
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          fun(
                                              context,
                                              fulldataofrooms
                                                  .favroomsarray[index + 1]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                height: 6 * SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: LiteRollingSwitch(
                                    //value: true,
                                    textOn: 'Active',
                                    textOff: 'Inactive',
                                    colorOn: Colors.greenAccent,
                                    colorOff: Colors.blueGrey,
                                    iconOn: Icons.lightbulb_outline,
                                    iconOff: Icons.power_settings_new,
                                    onChanged: (bool state) async {
                                      print('turned ${(state) ? 'on' : 'off'}');
                                      if (state) {
                                        try {
                                          int flag = fulldataofrooms
                                                      .favouriteroomscontents[
                                                  fulldataofrooms
                                                      .favroomsarray[index + 1]]
                                              ["val"];
                                          Map m = fulldataofrooms
                                                  .favouriteroomscontents[
                                              fulldataofrooms
                                                  .favroomsarray[index + 1]];
                                          for (final i in m.values) {
                                            if (i == 1 || i == 0) continue;
                                            String s = i.toString();
                                            var list = s.split(" ");
                                            Fluttertoast.showToast(
                                                msg: list.toString());
                                            if (flag == 1) {
                                              setState(() {
                                                fulldataofrooms
                                                        .favouriteroomscontents[
                                                    fulldataofrooms
                                                            .favroomsarray[
                                                        index + 1]]["val"] = 0;
                                              });
                                              await dbref
                                                  .child(user.uid)
                                                  .child("favourites")
                                                  .child(fulldataofrooms
                                                      .favroomsarray[index + 1])
                                                  .child("val")
                                                  .set(0);
                                              await dbref
                                                  .child(user.uid)
                                                  .child("rooms")
                                                  .child(list[0])
                                                  .child("circuit")
                                                  .child(list[1])
                                                  .child(list[2])
                                                  .child("val")
                                                  .set(0);
                                            } else {
                                              setState(() {
                                                fulldataofrooms
                                                        .favouriteroomscontents[
                                                    fulldataofrooms
                                                            .favroomsarray[
                                                        index + 1]]["val"] = 1;
                                              });
                                              await dbref
                                                  .child(user.uid)
                                                  .child("favourites")
                                                  .child(fulldataofrooms
                                                      .favroomsarray[index + 1])
                                                  .child("val")
                                                  .set(1);
                                              await dbref
                                                  .child(user.uid)
                                                  .child("rooms")
                                                  .child(list[0])
                                                  .child("circuit")
                                                  .child(list[1])
                                                  .child(list[2])
                                                  .child("val")
                                                  .set(1);
                                            }
                                          }
                                        } catch (Ex) {
                                          print("eception");
                                        }
                                      }
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      // Text("wsedf"),
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
    );
  }

  Future<void> confirm(int index, String value, context) async {
    await Alert(
      context: context,
      type: AlertType.warning,
      style: AlertStyle(
          animationType: AnimationType.fromTop,
          isCloseButton: false,
          isOverlayTapDismiss: false,
          descStyle: TextStyle(fontWeight: FontWeight.bold),
          animationDuration: Duration(milliseconds: 400),
          titleStyle: TextStyle(color: Color(0xff00004d)),
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
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
                color: Colors.white, fontSize: 2.5 * SizeConfig.textMultiplier),
          ),
          // ignore: missing_return
          onPressed: () async {
            final dbref = FirebaseDatabase.instance.reference().child('Users');
            User user = FirebaseAuth.instance.currentUser;

            dbref
                .child(user.uid)
                .child("favourites")
                .child(fulldataofrooms.favroomsarray[index + 1])
                .child(fulldataofrooms.path[value])
                .remove();
            fulldataofrooms f = new fulldataofrooms();
            await f.fetchfavourites();
            await f.fetchfavouritescontentdata();
            Navigator.pop(context);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => favourite()));
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(
                color: Colors.white, fontSize: 2.5 * SizeConfig.textMultiplier),
          ),
          onPressed: () => Navigator.pop(context),
          gradient:
              LinearGradient(colors: [Color(0xffe63900), Color(0xffe63900)]),
        )
      ],
    ).show();
  }
}
