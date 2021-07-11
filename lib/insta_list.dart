import 'dart:convert';
import 'dart:ui';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_seekar_app/comments_screen.dart';
import 'package:job_seekar_app/custom_page_route.dart';
import 'package:job_seekar_app/globle.dart';

import 'constants.dart';
import 'full_image_rout.dart';
import 'models/post.dart';

class InstaList extends StatefulWidget {
  @override
  _InstaListState createState() => _InstaListState();
}

class _InstaListState extends State<InstaList> {
  final FlareControls flareControls = FlareControls();
  Color _favIconColor = Colors.black;

  // bool isPressed = 0;
  bool _isLiked = false;

  Future<List<Post>> postData;

  @override
  void initState() {
    super.initState();
    postData = getPostData();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
          child: FutureBuilder<List<Post>>(
              future: postData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Post> data = snapshot.data;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      int isPressed = data[index].like;
                      int isSaved = data[index].save;

                      // if (data[index].like == 1) {
                      //   isPressed = true;
                      // } else {
                      //   isPressed = false;
                      // }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 8.0, 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    new Container(
                                      height: 40.0,
                                      width: 40.0,
                                      decoration: new BoxDecoration(
                                        border: Border.all(),
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                          fit: BoxFit.cover,
                                          image: ExactAssetImage(
                                              'assets/paper.png'),
                                        ),
                                      ),
                                    ),
                                    new SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        new Text(
                                          "Paperjob.pk",
                                          // data[index].title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(data[index].category),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(data[index].city),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                new IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: null,
                                )
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, CustomPageRoute( FullImagePageRoute( "$mainUrl${data[index].image}")));
                                },
                                onDoubleTap: () {
                                  setState(() {
                                    if (isPressed != 1) {
                                      setState(() {
                                        isPressed = 1;
                                        data[index].like = 1;
                                      });
                                      likes(Globle.id, data[index].id, "1");
                                      //     .then((res) {
                                      //   if (res.statusCode == 200) {
                                      //     isPressed = !isPressed;
                                      //   } else {
                                      //     isPressed = !isPressed;
                                      //   }
                                      // });
                                      // saveLikeValue(_isLiked);
                                      // postLike(widget.documentSnapshot.reference);
                                    } else {
                                      setState(() {
                                        isPressed = 0;
                                        data[index].like = 0;
                                      });

                                      likes(Globle.id, data[index].id, "0");
                                      //     .then((res) {
                                      //   if (res.statusCode == 200) {
                                      //     isPressed = !isPressed;
                                      //
                                      //   } else {
                                      //     isPressed = !isPressed;
                                      //   }
                                      // });
                                      //saveLikeValue(_isLiked);
                                      // postUnlike(widget.documentSnapshot.reference);
                                    }
                                    // isPressed = !isPressed;
                                  });
                                  flareControls.play("like");
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      height: 250,
                                      child: new Image.network(
                                        // "https://image.shutterstock.com/shutterstock/photos/143467093/display_1500/stock-photo-search-job-newspaper-with-advertisments-glasses-and-mobile-d-143467093.jpg",
                                        "$mainUrl${data[index].image}",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 250,
                                      child: Center(
                                        child: SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: FlareActor(
                                            'assets/instagram_like.flr',
                                            controller: flareControls,
                                            animation: 'idle',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        IconButton(
                                          icon: new Icon(isPressed == 1
                                              ? Icons.favorite
                                              : FontAwesomeIcons.heart),
                                          color: isPressed == 1
                                              ? Colors.red
                                              : Colors.black,
                                          onPressed: () {
                                            if (isPressed != 1) {
                                              setState(() {
                                                isPressed = 1;
                                                data[index].like = 1;
                                              });
                                              likes(Globle.id, data[index].id,
                                                  "1");
                                              //     .then((res) {
                                              //   if (res.statusCode == 200) {
                                              //     isPressed = !isPressed;
                                              //   } else {
                                              //     isPressed = !isPressed;
                                              //   }
                                              // });
                                              // saveLikeValue(_isLiked);
                                              // postLike(widget.documentSnapshot.reference);
                                            } else {
                                              setState(() {
                                                isPressed = 0;
                                                data[index].like = 0;
                                              });

                                              likes(Globle.id, data[index].id,
                                                  "0");
                                              //     .then((res) {
                                              //   if (res.statusCode == 200) {
                                              //     isPressed = !isPressed;
                                              //
                                              //   } else {
                                              //     isPressed = !isPressed;
                                              //   }
                                              // });
                                              //saveLikeValue(_isLiked);
                                              // postUnlike(widget.documentSnapshot.reference);
                                            }
                                          },
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.comment,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  CustomPageRoute(
                                                      new CommentsScreen(
                                                          post_id:
                                                              data[index].id)));
                                            })
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(isSaved == 1
                                        ? Icons.bookmark
                                        : FontAwesomeIcons.bookmark),
                                    color: isSaved == 1
                                        ? Colors.red
                                        : Colors.black,
                                    onPressed: () {
                                      if (isSaved != 1) {
                                        setState(() {
                                          isSaved = 1;
                                          data[index].save = 1;
                                        });
                                        save(Globle.id, data[index].id, "1");
                                        //     .then((res) {
                                        //   if (res.statusCode == 200) {
                                        //     isPressed = !isPressed;
                                        //   } else {
                                        //     isPressed = !isPressed;
                                        //   }
                                        // });
                                        // saveLikeValue(_isLiked);
                                        // postLike(widget.documentSnapshot.reference);
                                      } else {
                                        setState(() {
                                          isSaved = 0;
                                          data[index].save = 0;
                                        });

                                        save(Globle.id, data[index].id, "0");
                                        //     .then((res) {
                                        //   if (res.statusCode == 200) {
                                        //     isPressed = !isPressed;
                                        //
                                        //   } else {
                                        //     isPressed = !isPressed;
                                        //   }
                                        // });
                                        //saveLikeValue(_isLiked);
                                        // postUnlike(widget.documentSnapshot.reference);
                                      }
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Liked by  ${data[index].count_like} peoples",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Text(
                                  data[index].title,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                Padding(
                                  padding: const EdgeInsets.only(right:8.0),
                                  child: new Container(
                                    height: 20,
                                    width: MediaQuery.of(context).size.width / 4,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(child: Text(data[index].sub_category,style: TextStyle(fontSize: 12),)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Flexible(child: Text(data[index].description))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                Flexible(
                                    child: Text(
                                        timeConvert(data[index].timestamp)))
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Container(
                                  height: 30.0,
                                  width: 30.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                          imagePath(Globle.image),
                                        )),
                                  ),
                                ),
                                new SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                  child: new TextField(
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Add a comment...",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 16.0),
                          //   child: Text("1 Day Ago",
                          //       style: TextStyle(color: Colors.grey)),
                          // )
                        ],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default show a loading spinner.
                return CircularProgressIndicator();
              })),
    );
  }

  Future<List<Post>> getPostData() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // var uri = Uri.http("http://paperjob.devass.info", "api/get_login.php", data);
    var jsonResponse;
    var response =
        await http.get(Uri.parse(post_url + "?user_id=${Globle.id}"));
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);

      List data = jsonResponse["data"] as List;

      return data
          .map<Post>((json) => Post.fromJson(json))
          .toList()
          .reversed
          .toList();

      // print(_list.toString());

    } else {
      Fluttertoast.showToast(
          msg: "some thing went wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
//  radio button
  }

  Future<http.Response> likes(
      String user_id, String post_id, String like_status) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': user_id,
      'post_id': post_id,
      'like_status': like_status,
    };

    return await http.post(Uri.parse(set_like), body: data);
  }

  Future<http.Response> save(
      String user_id, String post_id, String like_status) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': user_id,
      'post_id': post_id,
      'save_status': like_status,
    };

    return await http.post(Uri.parse(save_post), body: data);
  }

  String imagePath(String path) {
    print(path);
    var imagePath;
    if (path.contains("http://") || path.contains("https://")) {
      imagePath = Globle.image;
    } else {
      imagePath = "$mainUrl${Globle.image}";
    }
    return imagePath;
  }

  String timeConvert(String time) {
    DateTime databaseDate = DateFormat("yyyy-MM-dd hh:mm a").parse(time);
    final DateFormat databaseDated = DateFormat('EEE, dd MMM yyyy hh:mm a');
    return databaseDated.format(databaseDate);
  }
}
