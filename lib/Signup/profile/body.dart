import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:job_seekar_app/models/users.dart';
import 'package:path/path.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/rounded_button.dart';
import '../../components/text_field_container.dart';
import '../../constants.dart';
import '../../custom_page_route.dart';
import '../../globle.dart';
import '../../instagram_home.dart';
import 'background.dart';

class Body extends StatefulWidget {
  String firstName, lastName, username, password;

  Body({this.firstName, this.lastName, this.username, this.password});

  @override
  _BodyState createState() => _BodyState();
}

enum SignUpOption { phone_number, email }

class _BodyState extends State<Body> {
  String _username, _email, _password = "";
  final _formKey = GlobalKey<FormState>();
  SignUpOption _character = SignUpOption.phone_number;
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  // FocusNode _usernameFocusNode = FocusNode();
  // FocusNode _emailFocusNode = FocusNode();
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = ProgressDialog(context);
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
                  " Profile Picture",
                  style: new TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 30.0),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.023),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 36, right: 36),
                  child: Text(
                    "Please add profile picture  and enjoy our paper job services",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Color(0xffFDCF09),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  new File(_image.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                      // Container(
                      //   width: 100,
                      //   height: 100,
                      //   decoration: BoxDecoration(
                      //       border: Border.all(
                      //           width: 4,
                      //           color:
                      //               Theme.of(context).scaffoldBackgroundColor),
                      //       boxShadow: [
                      //         BoxShadow(
                      //             spreadRadius: 2,
                      //             blurRadius: 10,
                      //             color: Colors.black.withOpacity(0.1),
                      //             offset: Offset(0, 10))
                      //       ],
                      //       shape: BoxShape.circle,
                      //       image: DecorationImage(
                      //           fit: BoxFit.cover,
                      //           image: Image.file(_image))),
                      // ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.green,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              RoundedButton(
                  text: "Save",
                  press: () {
                    if (_image != null) {
                      //   _formKey.currentState.save();
                      setState(() async {
                        try {
                          final user = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: widget.username,
                                  password: widget.password);
                          if (user.isEmailVerified) {
                            pr.show();
                            upload(new File(_image.path)).then((value) {
                              String imagePath =
                                  json.decode(value.body)["imagePath"];

                              if (value.statusCode == 200) {
                                signUp(
                                    context,
                                    "${widget.firstName}  ${widget.lastName}",
                                    widget.username,
                                    widget.password,
                                    imagePath,
                                    getRandomString(15).toString(),
                                    pr);
                              }
                            }).catchError((error) => throw (error));
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Please Verify your email first check email inbox",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg:
                                  "Please Verify your email first check email inbox",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          print(e);
                        }
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please add profile picture",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  final TextEditingController nameController = new TextEditingController();

  Container textSection() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          TextFieldContainer(
            child: TextFormField(
              autofocus: true,
              onFieldSubmitted: (_) {},
              validator: (name) {
                Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(name))
                  return 'Please enter valid name';
                else
                  return null;
              },
              onSaved: (name) => _username = name,
              // controller: nameController,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "First Name",
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Response> upload(File imageFile) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse(upload_image_url);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    // var response = await request.send();
    // print(response.statusCode);
    http.Response response =
        await http.Response.fromStream(await request.send());
    // listen for response
    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });
    return response;
  }

  void signUp(BuildContext context, String name, String username,
      String password, String image, String user_id, ProgressDialog pr) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'name': name,
      'username': username,
      'password': password,
      'user_id': user_id,
      'image': image,
      'token': Globle.token
    };
    var jsonResponse;
    var response = await http.post(Uri.parse(signUp_url), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        print(jsonResponse.toString());
        setState(() {
          login(context, username, password, pr);
          // pr.hide();
          // Fluttertoast.showToast(
          //     msg: "Account create successfully",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIos: 1,
          //     backgroundColor: Colors.green,
          //     textColor: Colors.white,
          //     fontSize: 16.0);
          // Navigator.of(context).pushAndRemoveUntil(
          //     CustomPageRoute( InstaHome()), (
          //     Route<dynamic> route) => false);
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
        pr.hide();
      });
      print(response.body);
    }
  }

//  radio button

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  PickedFile _image;
  final picker = ImagePicker();

  _imgFromCamera() async {
    PickedFile image =
        await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile image =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  @override
  void initState() {
    // _passwordVisible = false;
  }

  void login(BuildContext context, String username, String password,
      ProgressDialog pr) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = {'username': username, 'password': password};
    // var uri = Uri.http("http://paperjob.devass.info", "api/get_login.php", data);
    var jsonResponse;
    var response = await http
        .get(Uri.parse(login_url + "?username=$username&password=$password"));
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

          pr.hide();
          Navigator.of(context)
              .pushReplacement(new CustomPageRoute(InstagramHome()));
        });
      } else {
        pr.hide();
        setState(() {
          Fluttertoast.showToast(
              msg: "some thing went wrong",
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
  }
}
