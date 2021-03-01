import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  }

  Future<Void> getFirebaseImageFolder() async {
    Reference storageRef =
        FirebaseStorage.instance.ref().child('advertisement');
    storageRef.listAll().then((result) async {
      result.items.forEach((Reference ref) async {
        // print(ref.fullPath);

        String downloadURL =
            await FirebaseStorage.instance.ref(ref.fullPath).getDownloadURL();
        setState(() {
          l.add(downloadURL);
        });
      });
    });
    print(l);
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      PickedFile image =
          await ImagePicker().getImage(source: ImageSource.gallery);
      profilepickflag = 1;
      setState(() {
        _image = image;
        print('Image Path $_image');
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
      //Fluttertoast.showToast(msg: imagedownloadurl);
      setState(() {
        fulldataofrooms.uploadedimageurl = uploadedurl = imagedownloadurl;

        print("Profile Picture uploaded");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }

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
                            onPressed: () {
                              setState(() {
                                upload = true;
                              });
                              getImage();
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
                                onPressed: () {
                                  uploadPic(context);
                                  setState(() {
                                    upload = false;
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
              Text("Our Products"),
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
