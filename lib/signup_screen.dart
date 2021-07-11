import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_seekar_app/insta_home.dart';
import 'package:job_seekar_app/loginScreen.dart';

import 'custom_page_route.dart';
import 'instagram_home.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => new _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _userId = new TextEditingController();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _password = new TextEditingController();

  var _textStyleBlack = new TextStyle(fontSize: 12.0, color: Colors.black);
  var _textStyleGrey = new TextStyle(fontSize: 12.0, color: Colors.grey);
  var _textStyleBlueGrey =
      new TextStyle(fontSize: 12.0, color: Colors.blueGrey);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomBar(),
      body: _body(),
    );
  }

  Widget _userIDEditContainer() {
    return new Container(
      child: new TextField(
        controller: _userId,
        decoration: new InputDecoration(
            hintText: 'Phone number,email or username',
            border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.black),
            ),
            isDense: true),
        style: _textStyleBlack,
      ),
    );
  }

  Widget _nameEditContainer() {
    return new Container(
      child: new TextField(
        controller: _name,
        decoration: new InputDecoration(
            hintText: 'Name',
            border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.black),
            ),
            isDense: true),
        style: _textStyleBlack,
      ),
    );
  }

  Widget _passwordEditContainer() {
    return new Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: new TextField(
        controller: _password,
        obscureText: true,
        decoration: new InputDecoration(
            hintText: 'Password',
            border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.black),
            ),
            isDense: true),
        style: _textStyleBlack,
      ),
    );
  }

  Widget _loginContainer() {
    return new GestureDetector(
      onTap: _login,
      child: new Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10.0),
        width: 500.0,
        height: 40.0,
        child: new Text(
          "Sign Up",
          style: new TextStyle(color: Colors.white),
        ),
        color: Colors.blue,
      ),
    );
  }



  Widget _bottomBar() {
    return new Container(
        alignment: Alignment.center,
        height: 50.0,
        child: new Column(
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height: 1.0,
                  color: Colors.grey.withOpacity(0.7),
                ),
                new Padding(
                  padding: new EdgeInsets.only(top: 17.5),
                  child: GestureDetector(
                    onTap: _loginScreen,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text('Already have an account?',
                            style: _textStyleGrey),
                        new Text('Sign In.', style: _textStyleBlueGrey),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }

  Widget _body() {
    return new Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
              child: new Text(
                'Paper Job',
                style: new TextStyle(fontFamily: 'Billabong', fontSize: 50.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                              ))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.green,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 15,
                          ),
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            _userIDEditContainer(),
            SizedBox(
              height: 5.0,
            ),
            _nameEditContainer(),
            SizedBox(
              height: 5.0,
            ),
            _passwordEditContainer(),
            _loginContainer(),
          ],
        ));
  }

  void _login() {
    if (_userId.text.isEmpty) {
      _showEmptyDialog("Type something");
    } else if (_password.text.isEmpty) {
      _showEmptyDialog("Type something");
    } else {
      Navigator.pushReplacement(
          context,
          new CustomPageRoute(new InstagramHome()));
    }
  }

  void _loginScreen() {
    Navigator.pushReplacement(
        context,
        new CustomPageRoute( new LoginScreen()));
  }

  _showEmptyDialog(String title) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => new CupertinoAlertDialog(
              content: new Text("$title can't be empty"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("OK"))
              ],
            ));
  }
}
