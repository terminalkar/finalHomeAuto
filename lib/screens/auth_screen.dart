import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_automation_app/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseDatabase.instance.reference();
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String mobile,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await _database
            .child('Users')
            .child(authResult.user.uid)
            .child('info')
            .set({
          'mobile': mobile,
          'email': email,
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, Please chech your credentials!!';
      if (err != null) {
        message = err.message;
        print(message);
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      var m1 = err.toString();
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(m1),
        backgroundColor: Colors.red,
      ));

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor:
          Theme.of(context).primaryColor, // Theame set kraychi bakiye

      body: SingleChildScrollView(
        child: AuthForm(
          _submitAuthForm,
          _isLoading,
        ),
      ),
    );
  }
}
