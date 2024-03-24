import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'controller.dart';
import 'createPost.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  PostController postController = Get.put(PostController());
  List<DocumentSnapshot> _posts = [];
  List<DocumentSnapshot> _filteredPosts = [];
  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      QuerySnapshot _querySnapshot = await _firestore
          .collection('posts')
          .orderBy('time', descending: true)
          .get();
      setState(() {
        _posts = _querySnapshot.docs;
        _filteredPosts = _querySnapshot.docs;
      });
    } catch (e) {
      // Handle the error according to your app's needs.
      print(e.toString());
    }
  }

  void filterPosts(String value) {
    _filteredPosts = _posts
        .where((element) => (element.data() as Map<String, dynamic>)['title']
            .toString()
            .toLowerCase()
            .contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        leading: SizedBox(),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        bottom: PreferredSize(
            preferredSize: Size(size.width, size.height * 0.1),
            child: Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  filterPosts(value);
                },
                decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon:
                        Icon(Icons.search, color: Colors.white, size: 20),
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.white, width: 1.0)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.white, width: 1.0))),
              ),
            )),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPosts,
        child: _posts.isEmpty
            ? Center(
                child: Container(
                  child: Text('Add Post'),
                ),
              )
            : ListView.builder(
                itemCount: _filteredPosts.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      _filteredPosts[index].data() as Map<String, dynamic>;

                  // VideoPlayerController _controller =
                  //     VideoPlayerController.network(
                  //   data['videoUrl'],
                  // )..initialize().then((_) {
                  //         setState(() {});
                  //       });

                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              child: Text(
                                  data['title'].toString().substring(0, 1)),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(data['title'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(width: 10),
                                    Text(
                                        data['time']
                                            .toString()
                                            .substring(0, 10),
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                SizedBox(
                                    width: size.width * 0.6,
                                    child: Text(data['address'])),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                            child: VideoPreview(
                          videoUrl: data['videoUrl'],
                          filePath: '',
                        )),
                        SizedBox(height: 10),
                        Container(
                            width: size.width * 0.8,
                            child: Text("Description:")),
                        SizedBox(
                            width: size.width * 0.8,
                            child: Text(
                              data['description'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                            )),
                      ],
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          postController.descriptionController.value.clear();
          postController.titleController.value.clear();
          postController.videoFile.value = File('');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreatePostPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class VideoPreview extends StatefulWidget {
  final String videoUrl;

  VideoPreview({required this.videoUrl, required String filePath});

  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _controller.value.isInitialized
        ? Column(
            children: [
              InkWell(
                onTap: () {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  width: size.width * 0.8,
                  height: size.height * 0.4,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                      _controller.value.isPlaying
                          ? SizedBox
                              .shrink() // If the video is playing, don't show the play button.
                          : Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size:
                                  64.0, // You can set the size of the play button as needed.
                            ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
