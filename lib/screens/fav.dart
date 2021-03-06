import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  List<PopupMenuItem> fun(BuildContext context, String name, int index) {
    try {
      //Fluttertoast.showToast(msg: name);
      var elements = fulldataofrooms.favouritecontentnamesmap[name];
      var sList = List<String>.from(elements);

      List<PopupMenuItem> t = sList
          .map((String e) => PopupMenuItem<String>(
                value: e,
                child: InkWell(
                    child: Container(
                        height: SizeConfig.heightMultiplier * 5,
                        child: Center(child: Text(e))),
                    onTap: () {
                      confirm(index, e, context);
                    }),
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
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.blue,
        title: Text(
          'Favourite',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: fulldataofrooms.favroomsarray.length - 1 <= 0
          ? Container(
              child: Center(child: Text("No favourites added")),
            )
          : GridView.count(
              crossAxisCount: 2,
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
                        showMenu(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          items: <PopupMenuEntry>[
                            PopupMenuItem(
                              value: index,
                              child: GestureDetector(
                                onTap: () {
                                  try {
                                    dbref
                                        .child(user.uid)
                                        .child("favourites")
                                        .child(fulldataofrooms
                                            .favroomsarray[index + 1])
                                        .remove();
                                    setState(() {
                                      fulldataofrooms.favouriteroomscontents
                                          .remove(fulldataofrooms
                                              .favroomsarray[index + 1]);
                                      fulldataofrooms.favroomsarray.remove(
                                          fulldataofrooms
                                              .favroomsarray[index + 1]);
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
                                      "Delete Favourite",
                                      style: TextStyle(
                                          fontFamily: "Amelia-Basic-Light",
                                          fontSize:
                                              SizeConfig.textMultiplier * 2.5,
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
                        final RenderBox overlay =
                            Overlay.of(context).context.findRenderObject();

                        showMenu(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            items: fun(
                                context,
                                fulldataofrooms.favroomsarray[index + 1],
                                index),
                            context: context,
                            position: RelativeRect.fromRect(
                                _tapPosition & const Size(40, 40),
                                Offset.zero & overlay.size));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    height: SizeConfig.grp < 4
                                        ? 9 * SizeConfig.heightMultiplier
                                        : 6 * SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                                    child: Center(
                                      child: Text(
                                        fulldataofrooms
                                            .favroomsarray[index + 1],
                                        style: TextStyle(
                                          fontSize: SizeConfig.grp < 4
                                              ? SizeConfig.textMultiplier * 2.8
                                              : SizeConfig.textMultiplier * 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height: 6 * SizeConfig.heightMultiplier,
                                      width: 30 * SizeConfig.widthMultiplier,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: LiteRollingSwitch(
                                          value: fulldataofrooms
                                                          .favouriteroomscontents[
                                                      fulldataofrooms
                                                              .favroomsarray[
                                                          index + 1]]["val"] ==
                                                  1
                                              ? true
                                              : false,
                                          textOn: 'Active',
                                          textOff: 'Inactive',
                                          colorOn: Colors.greenAccent,
                                          colorOff: Colors.blueGrey,
                                          iconOn: Icons.lightbulb_outline,
                                          iconOff: Icons.power_settings_new,
                                          onChanged: (bool status) async {
                                            print(
                                                'turned ${(status) ? 'on' : 'off'}');
                                            int state = status ? 1 : 0;

                                            try {
                                              Map m = fulldataofrooms
                                                      .favouriteroomscontents[
                                                  fulldataofrooms.favroomsarray[
                                                      index + 1]];
                                              await dbref
                                                  .child(user.uid)
                                                  .child("favourites")
                                                  .child(fulldataofrooms
                                                      .favroomsarray[index + 1])
                                                  .child("val")
                                                  .set(state);
                                              fulldataofrooms
                                                      .favouriteroomscontents[
                                                  fulldataofrooms.favroomsarray[
                                                      index +
                                                          1]]["val"] = state;
                                              for (final i in m.values) {
                                                if (i == 1 || i == 0) continue;
                                                String s = i.toString();
                                                var list = s.split(" ");

                                                await dbref
                                                    .child(user.uid)
                                                    .child("rooms")
                                                    .child(list[0])
                                                    .child("circuit")
                                                    .child(list[1])
                                                    .child(list[2])
                                                    .child("val")
                                                    .set(state);
                                              }
                                            } catch (Ex) {
                                              print("eception");
                                            }
                                          },
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        height: SizeConfig.heightMultiplier * 24,
                        width: SizeConfig.widthMultiplier * 48,
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
