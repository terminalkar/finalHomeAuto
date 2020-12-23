import 'package:flutter/material.dart';

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
  var _isLogin = true;
  var _userEmail = '';
  var _userMobile = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formkey.currentState.validate();

    //removes keyboard after form submission
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formkey.currentState.save();
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
      // decoration: BoxDecoration(
      //   color: Color(0xffffffff).withOpacity(0.59),
      //   boxShadow: [
      //     BoxShadow(
      //       offset: Offset(0.00, 5.00),
      //       color: Color(0xff0792ef).withOpacity(0.19),
      //       blurRadius: 10,
      //     ),
      //   ],
      // ),
      child: Center(
        child: Column(
          children: [
            //For Space
            SizedBox(height: 50),
            //LOGO
            ////////////////////////////////////////////////////
            Container(
              child: Center(child: Image(image: AssetImage('assets/logo.png'))),
              height: 172.00,
              width: 172.00,
              margin: EdgeInsets.all(20),
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

            //For Space
            SizedBox(height: 20),

            ///Card
            /////////////////////////////////////////////////////////////////////////////////////

            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                // Card contains scrollview to stop overflow
                shadowColor: Colors.blue,
                margin: EdgeInsets.all(18),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15),

                    /////////Form starts here
                    child: Form(
                      key: _formkey,
                      child: Column(
                        //mainAxisSize: MainAxisSize.min, //This is for so that column takes place only that reqires
                        children: [
                          //For Space
                          SizedBox(height: 30),

                          //Email
                          Container(
                            //external decortion
                            height: 60.00,
                            width: 400.00,
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
                              //validotor logic needs to improve
                              validator: (value) {
                                if (value.isEmpty || !value.contains('@')) {
                                  return 'Please enter valid Email.';
                                }
                                return null;
                              },

                              //Saving email
                              onSaved: (value) {
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
                          if (!_isLogin)
                            Column(
                              children: [
                                //For Space
                                SizedBox(height: 30),

                                Container(
                                  //external decortion
                                  height: 60.00,
                                  width: 400.00,
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
                                    //validotor logic needs to improve
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 10) {
                                        return 'Username must contain  10 integers.';
                                      }
                                      return null;
                                    },

                                    //Saving Username
                                    onSaved: (value) {
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
                          SizedBox(height: 30),

                          //Password
                          Container(
                            //external decortion
                            height: 60.00,
                            width: 400.00,
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
                              //validotor logic needs to improve
                              validator: (value) {
                                if (value.isEmpty || value.length < 7) {
                                  return 'Password must contain minimum of 7 characters.';
                                }
                                return null;
                              },

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
                          SizedBox(height: 30),

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
                                    color: Color(0xff0792ef).withOpacity(0.32),
                                    blurRadius: 14,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(21.50),
                              ),
                              child: FlatButton(
                                child: Text(
                                  _isLogin ? 'Login' : 'Sign Up',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: _trySubmit,
                              ),
                            ),

                          //For Space
                          SizedBox(height: 30),

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
                          SizedBox(height: 30),

                          //Row of 2 buttons....Forgot password logic baki hai
                          if (!widget.isLoading)
                            if (_isLogin)
                              Row(
                                children: [
                                  Container(
                                    height: 54.00,
                                    width: 150.00,
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
                                        _isLogin
                                            ? 'Create new account'
                                            : 'I already have an account',
                                        style: TextStyle(
                                          fontFamily: "Roboto",
                                          fontSize: 15,
                                          color: Color(0xff707070),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isLogin = !_isLogin;
                                        });
                                      },
                                    ),
                                  ),

                                  //For Space
                                  SizedBox(width: 20),

                                  //forgot password////////////////////////////////////
                                  Container(
                                    height: 54.00,
                                    width: 150.00,
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
                                          fontSize: 15,
                                          color: Color(0xff707070),
                                        ),
                                      ),
                                      onPressed: () {
                                        //Forgot password logic goes here
                                      },
                                    ),
                                  ),
                                ],
                              ),

                          ////////////////////////SINGLE BIG BUTTON
                          if (!widget.isLoading)
                            if (!_isLogin)
                              Container(
                                height: 54.00,
                                width: 200.00,
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
                                    _isLogin
                                        ? 'Create new account'
                                        : 'I already have an account',
                                    style: TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 15,
                                      color: Color(0xff707070),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
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

            /////////////////////////////////////////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
