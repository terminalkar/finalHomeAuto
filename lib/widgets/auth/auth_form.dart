import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation_app/responsive/Screensize.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String mobile,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  bool pressed = false;
  var _isLogin = true;
  var _userEmail = '';
  var _userMobile = '';
  var _userPassword = '';
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  void _trySubmit() {
    //removes keyboard after form submission
    FocusScope.of(context).unfocus();

    if (_isLogin && _formkey.currentState.validate()) {
      _formkey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userMobile.trim(),
        _isLogin,
        context,
      );
    } else if (!_isLogin && _formkey2.currentState.validate()) {
      _formkey2.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userMobile.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            //For Space
            SizedBox(height: 3.0 * SizeConfig.heightMultiplier),
            //LOGO
            ////////////////////////////////////////////////////
            Container(
              child: Center(child: Image(image: AssetImage('assets/logo.png'))),
              height: 20 * SizeConfig.heightMultiplier,
              width: 20 * SizeConfig.heightMultiplier,
              margin: EdgeInsets.all(4 * SizeConfig.imageSizeMultiplier),
              decoration: BoxDecoration(
                color: Color(0xffffffff),
                border: Border.all(
                  width: 2.00,
                  color: Color(0xffffffff),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(5.00, 3.00),
                    color: Color(0xff0792ef),
                    blurRadius: 10,
                  ),
                ],
                shape: BoxShape.circle,
              ),
            ),
            /////////////////////////////////////////////////////

            ///Card
            /////////////////////////////////////////////////////////////////////////////////////

            Align(
              alignment: Alignment.bottomCenter,
              child: FlipCard(
                key: cardKey,
                flipOnTouch: false,
                front: Card(
                  // Card contains scrollview to stop overflow
                  shadowColor: Colors.blue,
                  margin: EdgeInsets.all(18),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(2.1 * SizeConfig.textMultiplier),

                      /////////Form starts here
                      child: Form(
                        key: _formkey,
                        child: Column(
                          //mainAxisSize: MainAxisSize.min, //This is for so that column takes place only that reqires
                          children: [
                            SizedBox(height: 3.5 * SizeConfig.heightMultiplier),
                            //Email
                            Container(
                              //external decortion
                              height: 7.5 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff).withOpacity(0.59),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0.00, 5.00),
                                    color: Color(0xff0792ef).withOpacity(0.19),
                                    blurRadius: 14,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(21.50),
                              ),

                              //internal textfield
                              child: TextFormField(
                                key: ValueKey('email'),
                                //validotor  improved
                                validator: validateEmail,

                                //Saving email
                                onChanged: (value) {
                                  _userEmail = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  //andar ka decoration ko none kiya hai
                                  hintText: 'Email',
                                  contentPadding: EdgeInsets.all(20),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),

                            //Username

                            //For Space
                            SizedBox(height: 3.5 * SizeConfig.heightMultiplier),

                            //Password
                            Container(
                              //external decortion
                              height: 7 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff).withOpacity(0.59),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0.00, 5.00),
                                    color: Color(0xff0792ef).withOpacity(0.19),
                                    blurRadius: 14,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(21.50),
                              ),

                              //internal textfield
                              child: TextFormField(
                                key: ValueKey('password'),

                                //validotor  improved
                                validator: validatePassword,

                                //Saving Password
                                onChanged: (value) {
                                  _userPassword = value;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  //andar ka decoration ko none kiya hai
                                  hintText: 'Password',
                                  contentPadding: EdgeInsets.all(20),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            //For Space
                            SizedBox(height: 3.5 * SizeConfig.heightMultiplier),

                            //login button iska design baki hai
                            if (widget.isLoading) CircularProgressIndicator(),
                            if (!widget.isLoading)
                              Container(
                                height: 43.00,
                                width: 146.00,
                                decoration: BoxDecoration(
                                  color: Color(0xff0792ef),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0.00, 5.00),
                                      color:
                                          Color(0xff0792ef).withOpacity(0.32),
                                      blurRadius: 14,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(21.50),
                                ),
                                child: FlatButton(
                                  child: Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: pressed ? null : _trySubmit,
                                ),
                              ),

                            //For Space
                            SizedBox(height: 3.5 * SizeConfig.heightMultiplier),

                            Container(
                                child: Text(
                              "--------------------- Or go with ---------------------",
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 2.1 * SizeConfig.textMultiplier,
                                color: Color(0xff707070),
                              ),
                            )),

                            //For Space
                            SizedBox(height: 3.5 * SizeConfig.heightMultiplier),

                            //Row of 2 buttons....Forgot password logic baki hai
                            if (!widget.isLoading)
                              Row(
                                children: [
                                  Container(
                                    height: 6.5 * SizeConfig.heightMultiplier,
                                    width: 35 * SizeConfig.widthMultiplier,
                                    decoration: BoxDecoration(
                                      color: Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0.00, 3.00),
                                          color: Color(0xff0792ef)
                                              .withOpacity(0.32),
                                          blurRadius: 6,
                                        ),
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(13.00),
                                    ),
                                    child: FlatButton(
                                      child: Text(
                                        'Create new account',
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontSize:
                                              2.1 * SizeConfig.textMultiplier,
                                          color: Color(0xff707070),
                                        ),
                                      ),
                                      onPressed: pressed
                                          ? null
                                          : () {
                                              setState(() {
                                                pressed = true;
                                                cardKey.currentState
                                                    .toggleCard();
                                                _isLogin = !_isLogin;
                                                pressed = false;
                                              });
                                            },
                                    ),
                                  ),

                                  //For Space
                                  SizedBox(
                                      width: SizeConfig.widthMultiplier * 6),

                                  //forgot password////////////////////////////////////
                                  Container(
                                    height: 6.5 * SizeConfig.heightMultiplier,
                                    width: 35 * SizeConfig.widthMultiplier,
                                    decoration: BoxDecoration(
                                      color: Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0.00, 3.00),
                                          color: Color(0xff0792ef)
                                              .withOpacity(0.32),
                                          blurRadius: 6,
                                        ),
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(13.00),
                                    ),
                                    child: FlatButton(
                                      child: Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontSize:
                                              2.1 * SizeConfig.textMultiplier,
                                          color: Color(0xff707070),
                                        ),
                                      ),
                                      onPressed: pressed
                                          ? null
                                          : () {
                                              setState(() {
                                                pressed = true;
                                              });
                                              //Forgot password logic goes here
                                              fun(context);
                                              setState(() {
                                                pressed = false;
                                              });
                                            },
                                    ),
                                  ),
                                ],
                              ),

                            ////////////////////////SINGLE BIG BUTTON
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ///////////////////////////////////////////
                ///flipping///////////////////////////////////////////////////////////////
                back: Card(
                  // Card contains scrollview to stop overflow
                  shadowColor: Colors.blue,
                  margin: EdgeInsets.all(18),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(2.1 * SizeConfig.textMultiplier),

                      /////////Form starts here
                      child: Form(
                        key: _formkey2,
                        child: Column(
                          //mainAxisSize: MainAxisSize.min, //This is for so that column takes place only that reqires
                          children: [
                            //For Space
                            SizedBox(height: 3.5 * SizeConfig.heightMultiplier),

                            //Email
                            Container(
                              //external decortion
                              height: 8 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff).withOpacity(0.59),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0.00, 5.00),
                                    color: Color(0xff0792ef).withOpacity(0.19),
                                    blurRadius: 14,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(21.50),
                              ),

                              //internal textfield
                              child: TextFormField(
                                key: ValueKey('email'),
                                //validotor  improved
                                validator: validateEmail,

                                //Saving email
                                onChanged: (value) {
                                  _userEmail = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  //andar ka decoration ko none kiya hai
                                  hintText: 'Email',
                                  contentPadding: EdgeInsets.all(20),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),

                            //Username

                            Column(
                              children: [
                                //For Space
                                SizedBox(
                                    height: 3.5 * SizeConfig.heightMultiplier),

                                Container(
                                  //external decortion
                                  height: 8 * SizeConfig.heightMultiplier,
                                  width: 100 * SizeConfig.widthMultiplier,

                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff).withOpacity(0.59),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0.00, 5.00),
                                        color:
                                            Color(0xff0792ef).withOpacity(0.19),
                                        blurRadius: 14,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(21.50),
                                  ),

                                  //internal textfield
                                  child: TextFormField(
                                    key: ValueKey('mobile'),
                                    //validotor  improved
                                    validator: validatenumber,

                                    //Saving Username
                                    onChanged: (value) {
                                      _userMobile = value;
                                    },
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      //andar ka decoration ko none kiya hai
                                      hintText: 'Mobile Number',
                                      contentPadding: EdgeInsets.all(20),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            //For Space
                            SizedBox(height: 3.5 * SizeConfig.heightMultiplier),

                            //Password
                            Container(
                              //external decortion
                              height: 8 * SizeConfig.heightMultiplier,
                              width: 100 * SizeConfig.widthMultiplier,

                              decoration: BoxDecoration(
                                color: Color(0xffffffff).withOpacity(0.59),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0.00, 5.00),
                                    color: Color(0xff0792ef).withOpacity(0.19),
                                    blurRadius: 14,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(21.50),
                              ),

                              //internal textfield
                              child: TextFormField(
                                key: ValueKey('password'),
                                //validotor  improved
                                validator: validatePassword,

                                //Saving Password
                                onSaved: (value) {
                                  _userPassword = value;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  //andar ka decoration ko none kiya hai
                                  hintText: 'Password',
                                  contentPadding: EdgeInsets.all(20),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ),
                            ),
                            //For Space
                            SizedBox(height: 3.5 * SizeConfig.heightMultiplier),

                            //login button iska design baki hai
                            if (widget.isLoading) CircularProgressIndicator(),
                            if (!widget.isLoading)
                              Container(
                                height: 6.5 * SizeConfig.heightMultiplier,
                                width: 35 * SizeConfig.widthMultiplier,
                                decoration: BoxDecoration(
                                  color: Color(0xff0792ef),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0.00, 5.00),
                                      color:
                                          Color(0xff0792ef).withOpacity(0.32),
                                      blurRadius: 14,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(21.50),
                                ),
                                child: FlatButton(
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: _trySubmit,
                                ),
                              ),

                            //For Space
                            SizedBox(height: 3.5 * SizeConfig.heightMultiplier),

                            Container(
                                child: Text(
                              "--------------------- Or go with ---------------------",
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 15,
                                color: Color(0xff707070),
                              ),
                            )),

                            //For Space
                            SizedBox(height: 3.5 * SizeConfig.heightMultiplier),

                            //Row of 2 buttons....Forgot password logic baki hai

                            ////////////////////////SINGLE BIG BUTTON
                            if (!widget.isLoading)
                              Container(
                                height: 7 * SizeConfig.heightMultiplier,
                                width: 50 * SizeConfig.widthMultiplier,
                                decoration: BoxDecoration(
                                  color: Color(0xffffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0.00, 3.00),
                                      color:
                                          Color(0xff0792ef).withOpacity(0.32),
                                      blurRadius: 6,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(13.00),
                                ),
                                child: FlatButton(
                                  child: Text(
                                    'I already have an account',
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 2.1 * SizeConfig.textMultiplier,
                                      color: Color(0xff707070),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      cardKey.currentState.toggleCard();
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /////////////////////////////////////////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}

fun(BuildContext context) async {
  bool pressed = false;
  final formKey = new GlobalKey<FormState>();
  String disp = "";
  FocusNode focusNode1 = new FocusNode();
  TextEditingController _controller = TextEditingController();
  return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return StatefulBuilder(
            // transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            builder: (context, setState) {
          return Opacity(
            opacity: a1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Column(
                children: <Widget>[
                  new Icon(
                    Icons.email,
                    color: Colors.blue,
                    size: 4.2 * SizeConfig.heightMultiplier,
                  ),
                  Text(
                    'Enter registered email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff00004d),
                    ),
                  )
                ],
              ),
              content: Container(
                height: 12 * SizeConfig.heightMultiplier,
                child: Column(
                  children: <Widget>[
                    //    new Padding(padding: EdgeInsets.only(top:5)),
                    new Form(
                      key: formKey,
                      child: TextFormField(
                        controller: _controller,
                        cursorColor: Color(0xff00004d),
                        focusNode: focusNode1,
                        style: TextStyle(
                            fontFamily: 'BalooChettan2',
                            fontWeight: FontWeight.bold,
                            color: Color(0xff00004d),
                            fontSize: 2.4 * SizeConfig.textMultiplier),
                        decoration: new InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 20.00, right: 20.00),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xff00004d)),
                                borderRadius: BorderRadius.circular(10.00)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xff800000)),
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: "Enter here",
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                // fontWeight: FontWeight.bold,
                                fontSize: 2.3 * SizeConfig.textMultiplier)),
                        keyboardType: TextInputType.emailAddress,
                        validator: validateEmail,
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      'send email',
                      style: TextStyle(
                          color: Color(0xff00004d),
                          fontWeight: FontWeight.bold,
                          fontSize: 2.3 * SizeConfig.textMultiplier),
                    ),
                    onPressed: pressed == false
                        ? () async {
                            if (formKey.currentState.validate()) {
                              resetPassword(_controller.text.toLowerCase());
                              setState(() {
                                disp = "email sent";
                              });
                              Fluttertoast.showToast(
                                  msg: "Check mail inbox",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            setState(() {
                              pressed = true;
                            });
                          }
                        : null),
                new FlatButton(
                  child: new Text(
                    'cancel',
                    style: TextStyle(
                        color: Color(0xff00004d),
                        fontWeight: FontWeight.bold,
                        fontSize: 2.3 * SizeConfig.textMultiplier),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
      },
      // transitionDuration: Duration(milliseconds: 1000),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {});
}

@override
Future<void> resetPassword(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

String validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty || !regex.hasMatch(value)) {
    return "invalid Email";
  } else {
    return null;
  }
}

String validatePassword(String value) {
  if (value.trim().isEmpty) {
    return 'Password cannot be empty';
  } else if (value.length < 6) {
    return 'Password too short';
  }
  return null;
}

String validatenumber(String value) {
  RegExp re = RegExp(r'^[1-9]\d*$');
  if (value.trim().isEmpty) {
    return 'number cannot be empty';
  } else if (value.length != 10 || !re.hasMatch(value)) {
    return 'Ennter a valid number';
  }
  return null;
}

String validate(String value) {
  if (value.isEmpty)
    return "please! update the field";
  else
    return null;
}
