import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'addpost.dart';
import 'controller.dart';
import 'previewvedio.dart';
import 'package:postrecord/HomeScreen.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  PostController postController = Get.find<PostController>();

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    await postController.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Obx(() {
        return Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: size.width * 0.8,
                  child: TextFormField(
                    controller: postController.titleController.value,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSaved: (value) {
                      postController.title.value = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20), // Add 20px spacing
                Container(
                  width: size.width * 0.8,
                  child: TextFormField(
                    controller: postController.descriptionController.value,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onSaved: (value) {
                      postController.title.value = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20), // Add 20px spacing

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        if (postController.videoFile.value.path.isNotEmpty) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ReviewVideo(
                              filePath: postController.videoFile.value.path,
                            );
                          }));
                        }
                      },
                      child: Text('${postController.videoFile.value.path}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, color: Colors.blue)),
                    ),
                    InkWell(
                      onTap: () {
                        if (postController.isUploading.value == false)
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return RecordMain();
                          }));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: Text('Upload Video'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    if (postController.isUploading.value == false)
                      postController.uploadPost();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: postController.isUploading.value == false
                        ? Text('Save Post', style: TextStyle(fontSize: 20))
                        : CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
