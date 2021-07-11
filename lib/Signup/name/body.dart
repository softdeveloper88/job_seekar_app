import 'package:flutter/material.dart';
import 'package:job_seekar_app/Signup/username/username.dart';
import 'package:job_seekar_app/custom_page_route.dart';

import '../../components/rounded_button.dart';
import '../../components/text_field_container.dart';
import '../../constants.dart';
import 'background.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

final TextEditingController firstNameController = new TextEditingController();
final TextEditingController lastNameController = new TextEditingController();

enum SignUpOption { phone_number, email }

class _BodyState extends State<Body> {
  String _lastName,
      _firstName = "";
  final _formKey = GlobalKey<FormState>();
  SignUpOption _character = SignUpOption.phone_number;
  int _groupValue = -1;

  @override
  void dispose() {
    firstNameController.clear();
    lastNameController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  "Profile Name",
                  style: new TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 30.0),
                ),
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.03),
              Center(
                child: Text(
                  "Add your full name go to next page",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
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
                        Navigator.of(context).pushReplacement(CustomPageRoute(
                            Username(
                                firstName: firstNameController.text.toString(),
                                lastName: lastNameController.text.toString())));
                      });
                    }
                  }),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }


  Container textSection() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
      TextFieldContainer(
      child: TextFormField(
        textInputAction: TextInputAction.next,
        autofocus: true,
        onFieldSubmitted: (_) {},
        validator: (firstName) {
          Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
          RegExp regex = new RegExp(pattern);
          if (!regex.hasMatch(firstName))
            return 'Please Enter valid first name';
          else
            return null;
        },
        onSaved: (firstName) => _firstName = firstName,
        controller: firstNameController,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "First Name",
          border: OutlineInputBorder(),
        ),
      ),
    ),
    TextFieldContainer(
    child: TextFormField(
    textInputAction: TextInputAction.go,
    autofocus: true,
    onFieldSubmitted: (_) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        Navigator.of(context).pushReplacement(CustomPageRoute(
            Username(firstName: firstNameController.text.toString(),
                lastName: lastNameController.text.toString())));
      });
    }
    },
    validator: (lastName) {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(lastName))
    return 'Please Enter valid last name';
    else
    return null;
    },
    onSaved: (lastName) => _lastName = lastName,
    controller: lastNameController,
    cursorColor: kPrimaryColor,
    decoration: InputDecoration(
    hintText: "Last Name",
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

  void fieldFocusChange(BuildContext context, FocusNode currentFocus,
      FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void initState() {
    // _passwordVisible = false;
  }
