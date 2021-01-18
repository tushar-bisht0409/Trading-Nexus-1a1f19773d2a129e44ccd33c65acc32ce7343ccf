import 'package:Nexus/main.dart';
import 'package:flutter/material.dart';
import '../models/http_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthMode { Signup, Login }

String uid;
String _labelText;
String _hintText;

class ZeroScreen extends StatefulWidget {
  static const routeName = '/auth';
  @override
  _ZeroScreenState createState() => _ZeroScreenState();
}

class _ZeroScreenState extends State<ZeroScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(color: Colors.white),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> getusersList() async {
    getData() async {
      return await FirebaseFirestore.instance
          .collection('usersList')
          .doc('usersList')
          .get();
    }

    await getData().then((val) {
      usersList = val.data()['usersList'];
    });
    print(usersList);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    UserCredential authResult;
    _formKey.currentState.save();
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      setState(() {
        _isLoading = true;
      });
      if (_authMode == AuthMode.Login) {
        getusersList();
        authResult = await _auth.signInWithEmailAndPassword(
          email: _authData['email'],
          password: _authData['password'],
        );
        print(FirebaseAuth.instance.currentUser.uid);
      } else {
        getusersList();
        authResult = await _auth.createUserWithEmailAndPassword(
          email: _authData['email'],
          password: _authData['password'],
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .set({'uid': FirebaseAuth.instance.currentUser.uid});
        usersList.add(FirebaseAuth.instance.currentUser.uid);
        FirebaseFirestore.instance
            .collection('usersList')
            .doc('usersList')
            .update({'usersList': usersList});
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      if (mounted) {
        setState(() {
          _authMode = AuthMode.Signup;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _authMode = AuthMode.Login;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
        height: deviceSize.height,
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Card(
              elevation: 0,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.Signup ? 320 : 260,
                ),
                padding: EdgeInsets.all(18),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        // padding: EdgeInsets.symmetric(
                        //     vertical: 8.0, horizontal: 94.0),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Image.asset('lib/assets/images/imageee.png',
                            // width: deviceSize.width * 0.2,
                            // height: deviceSize.height * 0.2,
                            fit: BoxFit.cover),
                      ),
                      Card(
                          color: Colors.blue[50],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  right: 12,
                                  left: 10,
                                  bottom: deviceSize.height * 0.1,
                                  top: deviceSize.height * 0.05),
                              child: SingleChildScrollView(
                                  child: Column(children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(right: 20, left: 20),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'E-Mail',
                                          fillColor: Colors.white,
                                          focusColor: Colors.blue,
                                          labelStyle: TextStyle(
                                              color: Colors.grey[600]),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white))),
                                      keyboardType: TextInputType.emailAddress,
                                      onSaved: (value) {
                                        _authData['email'] = value;
                                      },
                                    )),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(right: 20, left: 20),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: TextStyle(color: Colors.grey[600]),
                                          border: OutlineInputBorder()
                                        ),
                                      obscureText: true,
                                      controller: _passwordController,
                                      onSaved: (value) {
                                        _authData['password'] = value;
                                      },
                                    )),
                              if (_authMode == AuthMode.Signup)
                                  Padding(
                                      padding:
                                          EdgeInsets.only(right: 20, left: 20 ,top:15),
                                      child: TextFormField(
                                        enabled: _authMode == AuthMode.Signup,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                            labelText: 'Confirm Password',
                                            labelStyle: TextStyle(
                                                color: Colors.grey[600])),
                                        obscureText: true,
                                        validator: _authMode == AuthMode.Signup
                                            ? null
                                            : null,
                                      )),
                              ])))),
                      SizedBox(
                        height: 5,
                      ),
                      if (_isLoading)
                        CircularProgressIndicator()
                      else
                        Card(
                            elevation: 0,
                            child: Column(children: <Widget>[
                              RaisedButton(
                                elevation: 20,
                                child: Text(_authMode == AuthMode.Login
                                    ? 'LOGIN'
                                    : 'SIGN UP'),
                                onPressed: _submit,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 8.0),
                                color: Colors.blue[800],
                                textColor: Colors.white,
                              ),
                              FlatButton(
                                child: Text(
                                    '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                                onPressed: _switchAuthMode,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 4),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                textColor: Colors.blue[800],
                              )
                            ])),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )));
  }
}
