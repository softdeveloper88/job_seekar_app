import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_seekar_app/Signup/password/password.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../components/rounded_button.dart';
import '../../components/text_field_container.dart';
import '../../constants.dart';
import '../../custom_page_route.dart';
import 'background.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Body extends StatefulWidget {
  String firstName, lastName;
  ProgressDialog pr;
  Body(String firstName, String lastName) {
    this.firstName = firstName;
    this.lastName = lastName;
  }

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _username;
  final _formKey = GlobalKey<FormState>();

  // FocusNode _usernameFocusNode = FocusNode();
  // FocusNode _emailFocusNode = FocusNode();
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
   ProgressDialog pr =ProgressDialog(context);

    return Background(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.10),
              new Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
                child: new Text(
                  'Paper Job',
                  style: new TextStyle(fontFamily: 'Billabong', fontSize: 50.0),
                ),
              ),
              Center(
                child: Text(
                  "Add Email",
                  style: new TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 30.0),
                ),
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.03),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 36.0, right: 36.0),
                  child: Text(
                    "Add your email go to next page",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.03),
              Form(key: _formKey, child: textSection()),
              RoundedButton(
                text: "Next",
                press: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
                       pr.show();
                      checkEmail(pr,usernameController.text.toString());
                    });
                  }
                },
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController usernameController = new TextEditingController();

  Container textSection() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          TextFieldContainer(
            child: TextFormField(
              textInputAction: TextInputAction.go,
              autofocus: true,
              onFieldSubmitted: (_) {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    widget.pr.show();
                    checkEmail(widget.pr,usernameController.text.toString());
                  });
                }

              },
              validator: (username) {
                Pattern pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(username))
                  return 'Email must be valid format';
                else
                  return null;
              },
              onSaved: (username) => _username = username,
              controller: usernameController,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Email address",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkEmail(pr,String username) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'username': username};
    var jsonResponse;
    var response = await http.post(Uri.parse(check_email), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse["status"]==200) {
        print(jsonResponse.toString());
        setState(() {
          pr.hide();
          Navigator.of(context).pushReplacement(CustomPageRoute(
                  Password(
                      firstName: widget.firstName,
                      lastName: widget.lastName,
                      username: usernameController.text.toString().trim())));
        });
      } else {
        setState(() {
          pr.hide();
          Fluttertoast.showToast(
              msg: "username already exist",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
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

  void fieldFocusChange(BuildContext context, FocusNode currentFocus,
      FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

}
