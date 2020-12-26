import 'package:flutter/material.dart';
import 'package:home_automation_app/responsive/Screensize.dart';
import 'package:home_automation_app/screens/main_data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class favourite extends StatefulWidget {
  @override
  _favouriteState createState() => _favouriteState();
}

class _favouriteState extends State<favourite> {
  var _tapPosition;

  List<PopupMenuItem> fun(BuildContext context) {
    try {
      List<PopupMenuItem> t = fulldataofrooms.favroomsarray
          .map((String e) => PopupMenuItem<String>(
                value: e,
                child: Text(e),
              ))
          .toList();
      // print(fulldataofrooms.favroomsarray.length);
      return t;
    } catch (ex) {}
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
          4,
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
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Row(
                          children: [
                            Container(
                                height: 5 * SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                child: IconButton(
                                  icon: new Icon(
                                    Icons.lightbulb_outline,
                                    size: 15 * SizeConfig.widthMultiplier,
                                    color: Color(0xff79848b),
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                  },
                                )),
                            PopupMenuButton(
                              // initialValue: ,
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                              onSelected: (val) {
                                print(val);
                                confirm();
                              },
                              itemBuilder: (BuildContext context) =>
                                  fun(context),
                            ),
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

  Future<void> confirm() async {
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
          onPressed: () {},
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
