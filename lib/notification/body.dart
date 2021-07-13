import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_seekar_app/components/rounded_button.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../globle.dart';
import 'background.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {


// Declare this variable

int selectedRadio;
  @override
  void initState() {
    super.initState();
    // if(Globle.field=="All"){
    //   selectedRadio = 0;
    //   Globle.field = 0;
    // }else if(Globle.field=="Software Engineering"){
    //   selectedRadio = 1;
    //   Globle.field = 1;
    // }else if(Globle.field=="Computer Science"){
    //   selectedRadio = 2;
    //   Globle.field = 2;
    // }else if(Globle.field=="Civil Engineering"){
    //   selectedRadio = 3;
    //   Globle.field = 3;
    // }else if(Globle.field=="Electrical Engineering"){
    //   selectedRadio = 4;
    //   Globle.field = 4;
    // }else if(Globle.field=="Electronic Engineering"){
    //   selectedRadio = 5;
    //   Globle.field = 5;
    // }else{
    //   selectedRadio = 6;
    //   Globle.field = 6;
    // }


  }

  setSelectedRadioTile(String val) {
    setState(() {
      Globle.field = val;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Notification Setting',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18,color: Colors.black),),
                ),
                // This goes to the build method
                RadioListTile(
                  value: "All",
                  groupValue: Globle.field,
                  title: Text("All"),
                  onChanged: (val) {
                    print("Radio Tile pressed $val");
                    setSelectedRadioTile(val);
                  },
                  activeColor: Colors.red,
                  selected: true,
                ),
                RadioListTile(
                  value: "Software Engineering",
                  groupValue: Globle.field,
                  title: Text("Software Engineering"),
                  onChanged: (val) {
                    print("Radio Tile pressed $val");
                    setSelectedRadioTile(val);
                  },
                  activeColor: Colors.red,
                  selected: false,
                ),
                RadioListTile(
                  value: "Computer Science",
                  groupValue: Globle.field,
                  title: Text("Computer Science"),
                  onChanged: (val) {
                    print("Radio Tile pressed $val");
                    setSelectedRadioTile(val);
                  },
                  activeColor: Colors.red,
                  selected: false,
                ),
                RadioListTile(
                  value: "Civil Engineering",
                  groupValue: Globle.field,
                  title: Text("Civil Engineering"),
                  onChanged: (val) {
                    print("Radio Tile pressed $val");
                    setSelectedRadioTile(val);
                  },
                  activeColor: Colors.red,
                  selected: false,
                ),
                RadioListTile(
                  value: "Electrical Engineering",
                  groupValue: Globle.field,
                  title: Text("Electrical Engineering"),
                  onChanged: (val) {
                    print("Radio Tile pressed $val");
                    setSelectedRadioTile(val);
                  },
                  activeColor: Colors.red,
                  selected: false,
                ),
                RadioListTile(
                  value: "Electronic Engineering",
                  groupValue: Globle.field,
                  title: Text("Electronic Engineering"),
                  onChanged: (val) {
                    print("Radio Tile pressed $val");
                    setSelectedRadioTile(val);
                  },
                  activeColor: Colors.red,
                  selected: false,
                ),
                RadioListTile(
                  value: "Information Technology",
                  groupValue: Globle.field,
                  title: Text("Information Technology"),
                  onChanged: (val) {
                    print("Radio Tile pressed $val");
                    setSelectedRadioTile(val);
                  },
                  activeColor: Colors.red,
                  selected: false,
                ),
                SizedBox(height: 10.0),
                RoundedButton(
                    text: "Save",
                    press: () {

                        updateNotification(context, Globle.field);
                      }
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

void updateNotification(BuildContext context, String field) async {
  // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Map data = {
    'field': field,
    'user_id': Globle.id,


  };
  var jsonResponse;
  var response = await http.post(Uri.parse(set_notification), body: data);
  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body);
    if (jsonResponse != null) {
      print(jsonResponse.toString());
      setState(() async {
        // pr.hide();
        jsonResponse = json.decode(response.body);
        print(jsonResponse);
        if (jsonResponse["status"] == 400) {
          Fluttertoast.showToast(
              msg: jsonResponse['message'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {

          Globle.field=field;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('field',  Globle.field);
          Fluttertoast.showToast(
              msg: "Notification updated successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            SystemNavigator.pop();
          }
        }
      });
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
      // pr.hide();
    });
    print(response.body);
  }
}
}

