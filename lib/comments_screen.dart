import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:job_seekar_app/constants.dart';
import 'package:job_seekar_app/globle.dart';
import 'package:job_seekar_app/providers_data.dart';
import 'package:job_seekar_app/time_ago.dart';
import 'package:provider/provider.dart';

import 'models/Comments.dart';

class CommentsScreen extends StatefulWidget {
  // final DocumentReference documentReference;
  // ignore: deprecated_member_use
  final String post_id;

  CommentsScreen({this.post_id});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  List<Comments> _list = [];
  TextEditingController _commentController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _commentController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final proveder = Provider.of<ProvidersData>(context, listen: true);
    print("PostId" + widget.post_id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: new Color(0xfff8faf8),
        title: Text(
          'Comments',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            commentsListWidget(widget.post_id, proveder),
            Divider(
              height: 20.0,
              color: Colors.grey,
            ),
            commentInputWidget()
          ],
        ),
      ),
    );
  }

  Widget commentInputWidget() {
    return Container(
      height: 50.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 40.0,
            height: 40.0,
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.0),
                image: DecorationImage(

                    image: NetworkImage(imagePath(Globle.image)),fit: BoxFit.fill)),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                // ignore: missing_return
                validator: (String input) {
                  if (input.isEmpty) {
                    return "Please enter comment";
                  }
                },
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: "Add a comment...",
                ),
                onFieldSubmitted: (value) {
                  _commentController.text = value;
                },
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: Text('post', style: TextStyle(color: Colors.blue)),
            ),
            onTap: () {
              if (_formKey.currentState.validate()) {
                setState(() {
                  final DateTime now = DateTime.now();
                  final DateFormat formatter =
                      DateFormat('yyyy-MM-dd h:mm:ss a"');
                  final String dateTimeNow = formatter.format(now);
                  postComment(widget.post_id, Globle.id,
                      _commentController.text.toString());
                  Provider.of<ProvidersData>(context, listen: false)
                      .addTaskInList(Comments(
                          id: "1",
                          comments: _commentController.text.toString(),
                          name: Globle.name,
                          image: Globle.image,
                          timestamp: dateTimeNow));
                  _commentController.text = "";
                });
                // String id;
                // String comments;
                // String name;
                // String image;
                // String timestamp;
              }
            },
          )
        ],
      ),
    );
  }

  // postComment() {
  //   // var _comment = Comment(
  //   //     comment: "_commentController.text",
  //   //     timeStamp: "FieldValue.serverTimestamp()",
  //   //     ownerName: "widget.user.displayName",
  //   //     ownerPhotoUrl:" widget.user.photoUrl",
  //   //     ownerUid: "widget.user.uid)";
  //   // widget.documentReference
  //   //     .collection("comments")
  //   //     .document()
  //   //     .setData(_comment.toMap(_comment)).whenComplete(() {
  //   //       _commentController.text = "";
  //   //     });
  // }

  Widget commentsListWidget(String post_id, ProvidersData proveder) {
    print("PostId :::" + widget.post_id);
    // proveder.fetchCommentsList(post_id);
    // List<Comments> list = proveder.commentsList;

    return FutureBuilder<List<Comments>>(
      future: proveder.fetchCommentsList(post_id),
      // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<List<Comments>> snapshot) {
        // AsyncSnapshot<Your object type>
          List<Comments> list = snapshot.data;
          _list = list;
          if (snapshot.hasData) {
            return  Flexible(child: ListView.builder(
              itemCount: list == null ? 0 : list.length,
              itemBuilder: ((context, index) => commentItem(
                  list[index].comments,
                  list[index].name,
                  list[index].image,
                  list[index].timestamp)),
            ));
          } else if (snapshot.hasError) {
            return Flexible(child: Center(child:Text("No comments found")));
          }else {
            return Flexible(child: Center(child: CircularProgressIndicator()));
          }

        }
    );

    // print("Document Ref : ${widget.documentReference.path}");
    // return Flexible(
    //       child: list != null
    //           ? ListView.builder(
    //         itemCount: list == null ? 0 : list.length,
    //         itemBuilder: ((context, index) => commentItem(
    //             list[index].comments,
    //             list[index].name,
    //             list[index].image,
    //             list[index].timestamp)),
    //       )
    //           :  CircularProgressIndicator());
  }

  Widget commentItem(
      String comments, String name, String image, String timestamp) {
    // var inputFormat = DateFormat('yyyy-MM-dd hh:mm:s a');
    //
    // var inputDate = inputFormat.parse(timestamp); // <-- Incoming date
    // var outputFormat = DateFormat('dd-MM-yyyy h:mma');
    // var outputDate = outputFormat.format(inputDate); // <-- Desired date
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(commentImagePath(image)),
                  radius: 20,
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Text(name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(comments),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Center(
                          child: Container(
                            child: Text(
                              TimeAgo.timeAgoSinceDate(timestamp),
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

//   Future<List<Comments>> getCommentsData(String post_id) async {
//     // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     // var uri = Uri.http("http://paperjob.devass.info", "api/get_login.php", data);
//     var jsonResponse;
//     var response =
//         await http.get(Uri.parse(get_comments + "?post_id=${post_id}"));
//     if (response.statusCode == 200) {
//       jsonResponse = json.decode(response.body);
//       print(jsonResponse);
//
//       List data = jsonResponse["data"] as List;
//       print(data.toString());
//
//       return data.map<Comments>((json) => Comments.fromJson(json)).toList();
//     } else {
//       Fluttertoast.showToast(
//           msg: "some thing went wrong",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//           fontSize: 16.0);
//     }
// //  radio button
//   }

  Future<Void> postComment(
      String post_id, String user_id, String comments) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'user_id': user_id,
      'post_id': post_id,
      'comments': comments,
    };

    await http.post(Uri.parse(send_comments), body: data).then((value) {
      if (value.statusCode == 200) {
        // widget.postData.add(Comments(
        //     id: "1",
        //     comments: _commentController.text.toString(),
        //     name: Globle.name,
        //     image: Globle.image,
        //     timestamp: ""));

      }
      print(value.body);
    });
  }
  String imagePath(String path){
    var imagePath;
    if(path.contains("http://") || path.contains("https://")){
      imagePath=Globle.image;

    }else{
      imagePath="$mainUrl${Globle.image}";

    }
    return imagePath;
  }
  String commentImagePath(String path){
    var imagePath;
    print(path);
    if(path.contains("http://") || path.contains("https://")){
      imagePath=path;

    }else{

      imagePath="$mainUrl$path";

    }
    return imagePath;
  }
}
