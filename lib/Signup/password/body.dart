import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_seekar_app/Signup/profile/profile.dart';
import 'package:job_seekar_app/Signup/username/username.dart';
import 'package:job_seekar_app/custom_page_route.dart';

import '../../components/rounded_button.dart';
import '../../components/text_field_container.dart';
import '../../constants.dart';
import 'background.dart';

class Body extends StatefulWidget {
  String firstName, lastName, username;

  Body(String firstName, String lastName, String username) {
    this.firstName = firstName;
    this.lastName = lastName;
    this.username = username;
  }

  @override
  _BodyState createState() => _BodyState();
}

enum SignUpOption { phone_number, email }

class _BodyState extends State<Body> {
  String _confirmPassword, _password = "";
  final _formKey = GlobalKey<FormState>();
  SignUpOption _character = SignUpOption.phone_number;

  // FocusNode _usernameFocusNode = FocusNode();
  // FocusNode _emailFocusNode = FocusNode();
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.10),
              new Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
                child: new Text(
                  'Paper Job',
                  style: new TextStyle(fontFamily: 'Billabong', fontSize: 50.0),
                ),
              ),
              Center(
                child: Text(
                  "Create Password",
                  style: new TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 30.0),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Center(
                child: Text(
                  "Add your Password go to next page",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Form(key: _formKey, child: textSection()),
              RoundedButton(
                text: "Next",
                press: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() async {
                      FirebaseUser user = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: widget.username, password: passwordController.text);
                      try {
                        await user.sendEmailVerification().whenComplete(() {
                          Navigator.of(context).push(
                              CustomPageRoute(
                                  Profile(firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    username: widget.username,
                                    password: passwordController.text,)));
                        });
                        return user.uid;
                      } catch (e) {
                        print("An error occurred while trying to send email        verification");
                        print(e.message);
                      }
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

  final TextEditingController confirmPasswordController =
      new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container textSection() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          TextFieldContainer(
            child: TextFormField(
              autofocus: true,
              obscureText: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {},
              validator: (password) {
                // Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
                // RegExp regex = new RegExp(pattern);
                // if (!regex.hasMatch(password))
                if (password.length < 6)
                  // return "Password should be alphanumeric with \n special character (Abc123@)";
                  return "Password should be at least six character";
                else
                  return null;
              },
              onSaved: (password) => _password = password,
              controller: passwordController,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextFieldContainer(
            child: TextFormField(
              textInputAction: TextInputAction.go,
              autofocus: true,
              obscureText: true,
              onFieldSubmitted: (_) {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    Navigator.of(context).push(CustomPageRoute(Profile(
                      firstName: widget.firstName,
                      lastName: widget.lastName,
                      username: widget.username,
                      password: passwordController.text,
                    )));
                  });
                }
              },
              validator: (confirmPassword) {
                if (confirmPassword != passwordController.text)
                  return 'password not match';
                else
                  return null;
              },
              onSaved: (confirmPassword) => _confirmPassword = confirmPassword,
              controller: confirmPasswordController,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
// void signUp(String name,String email,String pass, ProgressDialog pr) async {
//   // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   Map data = {'name':name,'email': email, 'password': pass};
//   var jsonResponse;
//   var response = await http.post(Globle.signUp, body: data);
//   if (response.statusCode == 200) {
//     jsonResponse = json.decode(response.body);
//     if (jsonResponse != null) {
//       print(jsonResponse.toString());
//       setState(() {
//         pr.hide();
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false);
//
//       });
//       }
//   } else {
//     setState(() {
//       Fluttertoast.showToast(
//           msg: "Some thing went wrong",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
//       pr.hide();
//     });
//     print(response.body);
//   }
//  radio button

}

void fieldFocusChange(
    BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

@override
void initState() {
  // _passwordVisible = false;
}
