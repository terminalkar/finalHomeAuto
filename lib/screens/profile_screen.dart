import 'dart:ffi';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation_app/responsive/Screensize.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:home_automation_app/screens/main_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class profile extends StatefulWidget {
  @override
  profileState createState() => profileState();
}

// ignore: camel_case_types
class profileState extends State<profile> {
  FocusNode focusNode = new FocusNode();
  PickedFile _image;
  bool upload = false;
  String uploadedurl = fulldataofrooms.uploadedimageurl;
  int profilepickflag = 0;
  var l = [];
  bool pressed = false;
  final dbref = FirebaseDatabase.instance.reference();
  final FocusNode myFocusNode = FocusNode();
  final TextEditingController _idcontroller = new TextEditingController();
  final TextEditingController _mailcontroller = new TextEditingController();
  bool _status = true;
  User user = FirebaseAuth.instance.currentUser;

  void initState() {
    // ignore: todo
    // TODO: implement initState
    getFirebaseImageFolder();
    _mailcontroller.text = user.email;
    _idcontroller.text = user.uid;
    super.initState();
    Fluttertoast.showToast(
        msg: "Loading please wait", toastLength: Toast.LENGTH_SHORT);
  }

  Future<Void> getFirebaseImageFolder() async {
    Reference storageRef =
        FirebaseStorage.instance.ref().child('advertisement');
    storageRef.listAll().then((result) async {
      result.items.forEach((Reference ref) async {
        String downloadURL =
            await FirebaseStorage.instance.ref(ref.fullPath).getDownloadURL();
        setState(() {
          l.add(downloadURL);
        });
      });
    });
    print(l);
  }

  _imgFromCamera() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
      profilepickflag = 1;
    });
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      profilepickflag = 1;
    });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = basename(_image.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(File(_image.path));
    TaskSnapshot taskSnapshot = await uploadTask;

    String imagedownloadurl = await taskSnapshot.ref.getDownloadURL();

    dbref
        .child("Users")
        .child(user.uid)
        .child("info")
        .child("profile")
        .set(imagedownloadurl);

    setState(() {
      fulldataofrooms.uploadedimageurl = uploadedurl = imagedownloadurl;

      print("Profile Picture uploaded");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();

                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();

                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Builder(
          builder: (context) => Column(
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: SizeConfig.widthMultiplier * 20,
                            backgroundColor: Color(0xff476cfb),
                            child: ClipOval(
                              child: new SizedBox(
                                width: SizeConfig.widthMultiplier * 45,
                                height: SizeConfig.heightMultiplier * 24,
                                child: profilepickflag == 0
                                    ? Image.network(
                                        uploadedurl,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.file(File(_image.path)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 60.0),
                          child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.camera,
                              size: SizeConfig.widthMultiplier * 7.5,
                            ),
                            onPressed: pressed
                                ? null
                                : () async {
                                    setState(() {
                                      pressed = true;
                                      upload = true;
                                    });
                                    await _showPicker(context);
                                    setState(() {
                                      pressed = false;
                                    });
                                  },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 3,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.black,
                            width: 5.0,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: 3.5 * SizeConfig.heightMultiplier),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 8 * SizeConfig.widthMultiplier,
                                    right: 8 * SizeConfig.widthMultiplier,
                                    top: 2.5 * SizeConfig.heightMultiplier),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Personal Information',
                                          style: TextStyle(
                                              fontSize: 2.5 *
                                                  SizeConfig.heightMultiplier,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 7 * SizeConfig.widthMultiplier,
                                    right: 7 * SizeConfig.widthMultiplier,
                                    top: 3.5 * SizeConfig.heightMultiplier),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Email ID',
                                          style: TextStyle(
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 7 * SizeConfig.widthMultiplier,
                                    right: 7 * SizeConfig.widthMultiplier,
                                    top: 0.25 * SizeConfig.heightMultiplier),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Enter Email ID"),
                                        controller: _mailcontroller,
                                        enabled: false,
                                        onChanged: (val) {},
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 7 * SizeConfig.widthMultiplier,
                                    right: 7 * SizeConfig.widthMultiplier,
                                    top: 3.5 * SizeConfig.heightMultiplier),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'UID',
                                          style: TextStyle(
                                              fontSize: 2.2 *
                                                  SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 7 * SizeConfig.widthMultiplier,
                                    right: 7 * SizeConfig.widthMultiplier,
                                    top: 0.28 * SizeConfig.heightMultiplier),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        decoration: const InputDecoration(
                                          hintText: "UID",
                                        ),
                                        controller: _idcontroller,
                                        enabled: !_status,
                                        autofocus: !_status,
                                        onChanged: (text) {
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.copy_outlined),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(
                                            text: _idcontroller.text));
                                        Fluttertoast.showToast(msg: "UId copied");
                                      },
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    upload
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                color: Color(0xff476cfb),
                                onPressed: () {
                                  setState(() {
                                    upload = false;
                                    profilepickflag = 0;
                                  });
                                },
                                elevation: 4.0,
                                splashColor: Colors.blueGrey,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                              RaisedButton(
                                color: Color(0xff476cfb),
                                onPressed: pressed
                                    ? null
                                    : () {
                                        setState(() {
                                          pressed = true;
                                        });
                                        uploadPic(context);
                                        setState(() {
                                          upload = false;
                                          pressed = false;
                                        });
                                      },
                                elevation: 4.0,
                                splashColor: Colors.blueGrey,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              ),
              //Text("Our Products"),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: SizeConfig.heightMultiplier * 4,
                  width: SizeConfig.grp < 4
                      ? SizeConfig.widthMultiplier * 40
                      : SizeConfig.widthMultiplier * 50,
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
                  child: FlatButton(
                    child: Row(
                      children: [
                        Center(
                            child: Icon(
                          Icons.public,
                          color: Color(0xff79848b),
                        )),
                        Center(
                          child: Text(
                            '  Visit Website',
                            style: TextStyle(
                              fontFamily: "Amelia-Basic-Light",
                              fontSize: SizeConfig.textMultiplier * 2,
                              color: Color(0xff79848b),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: pressed == false
                        ? () async {
                            //to be implemented
                          }
                        : null,
                  ),
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 180.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: l.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          //decoration: BoxDecoration(color: Colors.amber),
                          child: Image.network(
                            i,
                            fit: BoxFit.cover,
                          ));
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
