import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'createPost.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ReviewVideo extends StatefulWidget {
  final String filePath;
  const ReviewVideo({Key? key, required this.filePath}) : super(key: key);

  @override
  State<ReviewVideo> createState() => _ReviewVideoState();
}

class _ReviewVideoState extends State<ReviewVideo> {
  final _isVisible_afterVideoOptions = true;
  String userPhoto = "";
  var recipient;
  var addons;
  String selectedAmount = "0";
  PostController postController = Get.find<PostController>();
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;
  int? bufferDelay;

  List<String> srcs = [
    "https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-daytime-city-traffic-aerial-view-56-large.mp4",
    "https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4"
  ];

  Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.file(File(widget.filePath));
    _videoPlayerController2 = VideoPlayerController.file(File(widget.filePath));
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    // final subtitles = [
    //     Subtitle(
    //       index: 0,
    //       start: Duration.zero,
    //       end: const Duration(seconds: 10),
    //       text: 'Hello from subtitles',
    //     ),
    //     Subtitle(
    //       index: 0,
    //       start: const Duration(seconds: 10),
    //       end: const Duration(seconds: 20),
    //       text: 'Whats up? :)',
    //     ),
    //   ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,

      additionalOptions: (context) {
        return <OptionItem>[
          OptionItem(
            onTap: toggleVideo,
            iconData: Icons.live_tv_sharp,
            title: 'Toggle Video Src',
          ),
        ];
      },
      //subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),

      hideControlsTimer: const Duration(seconds: 1),

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex += 1;
    if (currPlayIndex >= srcs.length) {
      currPlayIndex = 0;
    }
    await initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
    /*
     _videoPlayerController.pause();
    _videoPlayerController.dispose();
     */
  }

  Future _initVideoPlayer() async {
    /*
    _videoPlayerController = await VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    //await _videoPlayerController.setLooping(false);
    await _videoPlayerController.play();
    await _videoPlayerController.setVolume(1.0);
     */
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // getUserData();
    });
  }

  // void getUserData() async {
  //   // var data = await AppData.getUserPhoto();
  //   // var dataR = await AppData.getStoredData('giftRecipients');
  //   recipient = jsonDecode(dataR);
  //   if (data != "") {
  //     setState(() {
  //       userPhoto = data;
  //       print(userPhoto);
  //     });
  //   }

  //   var dataB = await AppData.getGiftCardAddons();
  //   if (dataB != "") {
  //     setState(() {
  //       addons = dataB;
  //     });
  //   }

  //   var dataA = await AppData.getStoredData('giftAmount');
  //   if (dataA != "") {
  //     setState(() {
  //       selectedAmount = dataA;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child:
              //Video Save/Delete/Filter
              Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight / 1.12,
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: _chewieController != null &&
                                  _chewieController!
                                      .videoPlayerController.value.isInitialized
                              ? Chewie(
                                  controller: _chewieController!,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 20),
                                    Text('Loading'),
                                  ],
                                ),
                        ),
                      ),
                      /*
                      TextButton(
                        onPressed: () {
                          _chewieController?.enterFullScreen();
                        },
                        child: const Text('Fullscreen'),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _videoPlayerController1.pause();
                                  _videoPlayerController1.seekTo(Duration.zero);
                                  _createChewieController();
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Text("Landscape Video"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _videoPlayerController2.pause();
                                  _videoPlayerController2.seekTo(Duration.zero);
                                  _chewieController = _chewieController!.copyWith(
                                    videoPlayerController: _videoPlayerController2,
                                    autoPlay: true,
                                    looping: true,
                                    /* subtitle: Subtitles([
                            Subtitle(
                              index: 0,
                              start: Duration.zero,
                              end: const Duration(seconds: 10),
                              text: 'Hello from subtitles',
                            ),
                            Subtitle(
                              index: 0,
                              start: const Duration(seconds: 10),
                              end: const Duration(seconds: 20),
                              text: 'Whats up? :)',
                            ),
                          ]),
                          subtitleBuilder: (context, subtitle) => Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              subtitle,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ), */
                                  );
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Text("Portrait Video"),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _platform = TargetPlatform.android;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Text("Android controls"),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _platform = TargetPlatform.iOS;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Text("iOS controls"),
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _platform = TargetPlatform.windows;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Text("Desktop controls"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (Platform.isAndroid)
                        ListTile(
                          title: const Text("Delay"),
                          subtitle: DelaySlider(
                            delay:
                            _chewieController?.progressIndicatorDelay?.inMilliseconds,
                            onSave: (delay) async {
                              if (delay != null) {
                                bufferDelay = delay == 0 ? null : delay;
                                await initializePlayer();
                              }
                            },
                          ),
                        )
                       */
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: _isVisible_afterVideoOptions,
                child: Positioned.fill(
                  bottom: 20,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 230,
                      height: 80,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0x99202020),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                ),
                                iconSize: 40,
                              ),
                              IconButton(
                                onPressed: () async {
                                  postController.videoFile.value =
                                      File(widget.filePath);
                                  final route = MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (_) => CreatePostPage(),
                                  );
                                  Navigator.pushReplacement(context, route);
                                },
                                icon: Icon(
                                  Icons.save,
                                  color: Colors.white,
                                ),
                                iconSize: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null &&
                    _chewieController!
                        .videoPlayerController.value.isInitialized
                    ? Chewie(
                  controller: _chewieController!,
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading'),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _chewieController?.enterFullScreen();
              },
              child: const Text('Fullscreen'),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _videoPlayerController1.pause();
                        _videoPlayerController1.seekTo(Duration.zero);
                        _createChewieController();
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Landscape Video"),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _videoPlayerController2.pause();
                        _videoPlayerController2.seekTo(Duration.zero);
                        _chewieController = _chewieController!.copyWith(
                          videoPlayerController: _videoPlayerController2,
                          autoPlay: true,
                          looping: true,
                          /* subtitle: Subtitles([
                            Subtitle(
                              index: 0,
                              start: Duration.zero,
                              end: const Duration(seconds: 10),
                              text: 'Hello from subtitles',
                            ),
                            Subtitle(
                              index: 0,
                              start: const Duration(seconds: 10),
                              end: const Duration(seconds: 20),
                              text: 'Whats up? :)',
                            ),
                          ]),
                          subtitleBuilder: (context, subtitle) => Container(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              subtitle,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ), */
                        );
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Portrait Video"),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.android;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Android controls"),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.iOS;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("iOS controls"),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.windows;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Desktop controls"),
                    ),
                  ),
                ),
              ],
            ),
            if (Platform.isAndroid)
              ListTile(
                title: const Text("Delay"),
                subtitle: DelaySlider(
                  delay:
                  _chewieController?.progressIndicatorDelay?.inMilliseconds,
                  onSave: (delay) async {
                    if (delay != null) {
                      bufferDelay = delay == 0 ? null : delay;
                      await initializePlayer();
                    }
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
  */

  /*
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          child:
          //Video Save/Delete/Filter
          Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight/1.12,
                child: Padding(
                  padding: EdgeInsets.only(top: 60),
                  /*
                  child: FutureBuilder(
                    future: _initVideoPlayer(),
                    builder: (context, state) {
                      if (state.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return VideoPlayer(_videoPlayerController);
                      }
                    },
                  ),
                   */
                ),
              ),
              Visibility(
                visible: _isVisible_afterVideoOptions,
                child: Positioned.fill(
                  bottom: 20,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 230,
                      height: 80,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0x99202020),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  /*
                                  await _videoPlayerController.setVolume(0.0);
                                  await _videoPlayerController.setLooping(false);
                                  await _videoPlayerController.pause();
                                  await _videoPlayerController.dispose();
                                   */

                                  ArtDialogResponse response = await ArtSweetAlert.show(
                                      barrierDismissible: false,
                                      context: context,
                                      artDialogArgs: ArtDialogArgs(
                                          denyButtonText: "Cancel",
                                          title: "Are you sure?",
                                          text: "You won't be able to revert this!",
                                          confirmButtonText: "Yes, delete it",
                                          type: ArtSweetAlertType.warning
                                      )
                                  );

                                  if (response.isTapConfirmButton) {
                                    AppData.storeData('giftCardVideo', "");
                                    final route = MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (_) => RecordPVM(
                                          Recipients: recipient,
                                          SelectedAmount: int.parse(selectedAmount),
                                          DressUpStatus: addons,
                                          DeliverTo: [],
                                          SelectedDay: DateTime.now()
                                      ),
                                    );
                                    //Navigator.push(context, route);



                                    var data = await AppData.getStoredData('giftRecipients');
                                    var pageData = jsonDecode(data);
                                    List recipients = [];
                                    for(var recipient in pageData){
                                      recipients.add({
                                        "srno" : recipient['srno'],
                                        "name" : recipient['name'],
                                        "email" : recipient['email'],
                                        "phone" : recipient['phone']
                                      });
                                    }

                                    String amount = await AppData.getStoredData('giftAmount');
                                    int selectedAmountA = int.parse(amount);

                                    var dataR = await AppData.getStoredData('giftDressUp');
                                    pageData = jsonDecode(dataR);
                                    List dressUps = [];
                                    for(var item in pageData){
                                      dressUps.add({
                                        "id": item["id"],
                                        "name": item['name'],
                                        "price": item['amount']
                                      });
                                    }
                                    var thisSelectedDate = await AppData.getStoredData('giftDate');
                                    var selectedDay = DateTime.parse(thisSelectedDate);

                                    List DeliverTo = [];
                                    String cmpUser = await AppData.getStoredData('userName');
                                    String cmpAddress = await AppData.getStoredData('userAddress');
                                    String cmpCity = await AppData.getStoredData('userCity');
                                    String cmpState = await AppData.getStoredData('userState');
                                    String cmpZip = await AppData.getStoredData('userZip');
                                    DeliverTo.add({
                                      "name": cmpUser,
                                      "address": cmpAddress,
                                      "city": cmpCity,
                                      "state": cmpState,
                                      "zip": cmpZip
                                    });

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                        builder: (context) =>
                                        RecordPVM(
                                            Recipients: recipients,
                                            SelectedAmount: selectedAmountA,
                                            DressUpStatus: dressUps,
                                            DeliverTo: DeliverTo,
                                            SelectedDay: selectedDay),
                                        ));
                                    return;
                                  }
                                },
                                icon: Image.asset('assets/images/trash.png',),iconSize: 40,
                              ),
                              // IconButton(
                              //   onPressed: () {
                              //     Navigator.pushReplacementNamed(context,'record-video/filters');
                              //   },
                              //   icon: Image.asset('assets/images/filter.png',),iconSize: 40,
                              // ),
                              IconButton(
                                onPressed: () async {
                                  /*
                                  await _videoPlayerController.setVolume(0.0);
                                  await _videoPlayerController.setLooping(false);
                                  await _videoPlayerController.pause();
                                  await _videoPlayerController.dispose();
                                   */

                                  var fromRoute = await AppData.getStoredData('fromDiffRoute');
                                  if(fromRoute == 'Confirm'){

                                    var data = await AppData.getStoredData('giftRecipients');
                                    var pageData = jsonDecode(data);
                                    List recipients = [];
                                    for(var recipient in pageData){
                                      recipients.add({
                                        "srno" : recipient['srno'],
                                        "name" : recipient['name'],
                                        "email" : recipient['email'],
                                        "phone" : recipient['phone']
                                      });
                                    }

                                    String amount = await AppData.getStoredData('giftAmount');
                                    int selectedAmount = int.parse(amount);

                                    var dataR = await AppData.getStoredData('giftDressUp');
                                    pageData = jsonDecode(dataR);
                                    List dressUps = [];
                                    for(var item in pageData){
                                      dressUps.add({
                                        "id": item["id"],
                                        "name": item['name'],
                                        "price": item['amount']
                                      });
                                    }
                                    var thisSelectedDate = await AppData.getStoredData('giftDate');
                                    var _selectedDay = DateTime.parse(thisSelectedDate);

                                    List DeliverTo = [];
                                    String name = await AppData.getStoredData('userName');
                                    String address = await AppData.getStoredData('userAddress');
                                    String city = await AppData.getStoredData('userCity');
                                    String state = await AppData.getStoredData('userState');
                                    String zip = await AppData.getStoredData('userZip');
                                    DeliverTo.add({
                                      "name": name,
                                      "address": address,
                                      "city": city,
                                      "state": state,
                                      "zip": zip
                                    });

                                    AppData.storeData('giftDeliverTo', '[{}]');
                                    AppData.storeData('giftDeliverTo', jsonEncode(DeliverTo));


                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Confirm(
                                                  Recipients: recipients,
                                                  SelectedAmount: selectedAmount,
                                                  DressUpStatus: dressUps,
                                                  DeliverTo: DeliverTo,
                                                  SelectedDay: _selectedDay,
                                                  Message: ""),
                                        ), (route) => false);
                                    return;
                                  }else {
                                    Navigator.pushNamedAndRemoveUntil(context, 'record-video/video-completed', (route) => false);
                                    return;
                                    //Navigator.pushReplacementNamed(context, 'record-video/video-completed');
                                  }
                                },
                                icon: Image.asset('assets/images/save.png',),iconSize: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
   */
}

class DelaySlider extends StatefulWidget {
  const DelaySlider({Key? key, required this.delay, required this.onSave})
      : super(key: key);

  final int? delay;
  final void Function(int?) onSave;
  @override
  State<DelaySlider> createState() => _DelaySliderState();
}

class _DelaySliderState extends State<DelaySlider> {
  int? delay;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    delay = widget.delay;
  }

  @override
  Widget build(BuildContext context) {
    const int max = 1000;
    return ListTile(
      title: Text(
        "Progress indicator delay ${delay != null ? "${delay.toString()} MS" : ""}",
      ),
      subtitle: Slider(
        value: delay != null ? (delay! / max) : 0,
        onChanged: (value) async {
          delay = (value * max).toInt();
          setState(() {
            saved = false;
          });
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.save),
        onPressed: saved
            ? null
            : () {
                widget.onSave(delay);
                setState(() {
                  saved = true;
                });
              },
      ),
    );
  }
}
