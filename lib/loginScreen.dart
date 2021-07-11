import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:job_seekar_app/constants.dart';
import 'package:job_seekar_app/custom_page_route.dart';
import 'package:job_seekar_app/globle.dart';
import 'package:job_seekar_app/instagram_home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Signup/name/signup_screen.dart';
import 'models/users.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userId = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  var _textStyleBlack = new TextStyle(fontSize: 12.0, color: Colors.black);
  var _textStyleGrey = new TextStyle(fontSize: 12.0, color: Colors.grey);
  var _textStyleBlueGrey =
      new TextStyle(fontSize: 12.0, color: Colors.blueGrey);
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    return new Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomBar(),
      body: _body(),
    );
  }

  Widget _userIDEditContainer() {
    return new Container(
      child: new TextField(
        textInputAction: TextInputAction.next,
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

  Widget _passwordEditContainer() {
    return new Container(
      padding: const EdgeInsets.only(top: 5.0),
      child: new TextField(
        textInputAction: TextInputAction.go,
        onSubmitted: (value) {
          _login();
        },
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
      onTap: () {
        setState(() {
          _login();
        });
      },
      child: new Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 10.0),
        width: 500.0,
        height: 40.0,
        child: new Text(
          "Log In",
          style: new TextStyle(color: Colors.white),
        ),
        color: Colors.blue,
      ),
    );
  }

  Widget _facebookContainer() {
    return new Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10.0),
      width: 500.0,
      height: 40.0,
      color: Colors.blue,
      child: new GestureDetector(
        onTap: () {
          signInWithGoogle();
          // googleSignIn();

          //  signInWithGoogle();
        },
        child: new Text(
          "Log in with Google",
          style:
              new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
                    onTap: _signUp,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text("Don't have an account?",
                            style: _textStyleGrey),
                        new Text('Sign up.', style: _textStyleBlueGrey),
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
          _userIDEditContainer(),
          _passwordEditContainer(),
          _loginContainer(),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                'Forgot your login details?',
                style: _textStyleGrey,
              ),
              new FlatButton(
                onPressed: () {},
                child: new Text(
                  'Get help signing in.',
                  style: _textStyleBlueGrey,
                ),
              )
            ],
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                height: 1.0,
                width: MediaQuery.of(context).size.width / 2.7,
                color: Colors.grey,
                child: new ListTile(),
              ),
              new Text(
                ' OR ',
                style: new TextStyle(color: Colors.blueGrey),
              ),
              new Container(
                height: 1.0,
                width: MediaQuery.of(context).size.width / 2.7,
                color: Colors.grey,
              ),
            ],
          ),
          _facebookContainer()
        ],
      ),
    );
  }

  void _login() {
    if (_userId.text.isEmpty) {
      _showEmptyDialog("Type something");
    } else if (_password.text.isEmpty) {
      _showEmptyDialog("Type something");
    } else {
      pr.show();
      login(_userId.text.toString(), _password.text.toString(), pr);
      // Navigator.pushReplacement(context,
      // PageTransition(type: PageTransitionType.leftToRight, duration: Duration(seconds: 1), child: InstaHome()));
      // // Navigator.pushReplacement(
      // //     context,
      // //     new MaterialPageRoute(
      // //         builder: (BuildContext context) => new InstaHome()));

    }
  }

  void _signUp() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight, child: SignUpScreen()));

    // Navigator.push(
    //   context,
    //   PageRouteBuilder(
    //     pageBuilder: (c, a1, a2) => SignUpScreen(),
    //     transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
    //     transitionDuration: Duration(milliseconds: 0),
    //   ),
    // );
    //     Navigator.of(context).push(CustomPageRoute(SignUpScreen()));
    //   Navigator.pushReplacement(
    //       context,
    //       new CupertinoPageRoute(
    //           builder: (BuildContext context) => new SignUpScreen()));
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

  void login(String username, String password, ProgressDialog pr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Globle.token = prefs.getString('token');
    var data = {'username': username, 'password': password};
    // var uri = Uri.http("http://paperjob.devass.info", "api/get_login.php", data);
    var jsonResponse;
    var response = await http.get(Uri.parse(login_url +
        "?username=$username&password=$password&token=${Globle.token}"));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse["status"] == 200) {
        setState(() async {
          List data = jsonResponse["data"] as List;

          List<Users> list =
              data.map<Users>((json) => Users.fromJson(json)).toList();

          print(list[0].username);
          Globle.userId = list[0].user_id;
          Globle.id = list[0].id;
          Globle.name = list[0].name;
          Globle.username = list[0].username;
          Globle.password = list[0].password;
          Globle.user_type = list[0].login_type;
          Globle.image = list[0].image;
          Globle.bio = list[0].bio;
          Globle.token = list[0].token;
          Globle.field = list[0].field;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('name', Globle.name);
          prefs.setString('username', Globle.username);
          prefs.setString('password', Globle.password);
          prefs.setString('user_id', Globle.id);
          prefs.setString('image', Globle.image);
          prefs.setString('bio', Globle.bio);
          prefs.setString('token', Globle.token);
          prefs.setString('field', Globle.field);
          // print(Globle.image);

          pr.hide();
          Navigator.of(context)
              .pushReplacement(new CustomPageRoute(InstagramHome()));
        });
      } else {
        pr.hide();
        setState(() {
          Fluttertoast.showToast(
              msg: "username or password is incorrect",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        });
      }
    } else {
      setState(() {
        pr.hide();
        Fluttertoast.showToast(
            msg: "some thing went wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
//  radio button
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  final gooleSignIn = GoogleSignIn();

  Future<bool> googleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      var result = await auth.signInWithCredential(credential);
      print(result.email);
      print(result.displayName);
      print(result.photoUrl);

      return Future.value(true);
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    FirebaseUser authResult = await _auth.signInWithCredential(credential);
    final _user = authResult;
    assert(!_user.isAnonymous);
    assert(await _user.getIdToken() != null);
    FirebaseUser currentUser = await _auth.currentUser();
    assert(_user.uid == currentUser.uid);
    print("User Name: ${_user.displayName}");
    print("User Email ${_user.email}");
    print("User Profile ${_user.photoUrl}");
    print("User Profile ${_user.uid}");
    signUp(context, _user.displayName, _user.email, "", _user.photoUrl,
        _user.uid, pr);
  }

  void signUp(BuildContext context, String name, String username,
      String password, String image, String user_id, ProgressDialog pr) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // Globle.token = prefs.getString('token');
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'name': name,
      'username': username,
      'password': password,
      'user_id': user_id,
      'image': image,
      'bio': '',
      'token': Globle.token
    };
    var jsonResponse;
    var response = await http.post(Uri.parse(social_login), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse["status"] == 200) {
        List data = jsonResponse["data"] as List;
        List<Users> list =
            data.map<Users>((json) => Users.fromJson(json)).toList();
        print(list[0].username);
        Globle.userId = list[0].user_id;
        Globle.id = list[0].id;
        Globle.name = list[0].name;
        Globle.username = list[0].username;
        Globle.password = list[0].password;
        Globle.user_type = list[0].login_type;
        Globle.image = list[0].image;
        Globle.bio = list[0].bio;
        Globle.token = list[0].token;
        Globle.field = list[0].field;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('name', Globle.name);
        prefs.setString('username', Globle.username);
        prefs.setString('password', Globle.password);
        prefs.setString('user_id', Globle.id);
        prefs.setString('image', Globle.image);
        prefs.setString('bio', Globle.bio);
        prefs.setString('token', Globle.token);
        prefs.setString('field', Globle.field);
        // print(Globle.image);

        pr.hide();
        Navigator.of(context)
            .pushReplacement(new CustomPageRoute(InstagramHome()));
      }
    } else {
      setState(() {
        Fluttertoast.showToast(
            msg: "Some thing went wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        pr.hide();
      });
      print(response.body);
    }
  }
}
