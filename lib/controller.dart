import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'HomeScreen.dart';
import 'package:postrecord/HomeScreen.dart';
import 'dart:io';
import 'package:video_compress/video_compress.dart';

class PostController extends GetxController {
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');
  RxString title = ''.obs;
  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;
  RxString description = ''.obs;
  RxString currentAddress = ''.obs;
  Position? currentPosition;
  Rx<File> videoFile = File('').obs;
  RxBool isUploading = false.obs;
  Future<MediaInfo?> compressVideo(String videoPath) async {
    final info = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.LowQuality,

      deleteOrigin:
          false, // Set to true if you want to delete the source video after compression
    );
    return info;
  }

  Future<DocumentReference<Object?>> uploadPost() async {
    isUploading.value = true;
    try {
      print(DateTime.now().toIso8601String());
      MediaInfo? t = await compressVideo(videoFile.value.path);
      if (t != null) {
        videoFile.value = File(t.path!);
      }
      print(DateTime.now().toIso8601String());
      String videoUrl = await uploadVideo(videoFile.value);
      String time = DateTime.now().toIso8601String();
      DocumentReference<Object?> v = await postCollection.add({
        'title': titleController.value.text,
        'description': descriptionController.value.text,
        'address': currentAddress.value,
        'time': time,
        'videoUrl': videoUrl,
      });
      isUploading.value = false;
      Get.to(HomeScreen());
      return v;
    } catch (e) {
      log(e.toString());
      isUploading.value = false;
      return Future.error(e);
    }
  }

  Future<String> uploadVideo(File videoFile) async {
    print(File(videoFile.path));
    try {
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('videos/${File(videoFile.path)}');
      UploadTask uploadTask = storageReference.putFile(videoFile);
      await uploadTask.whenComplete(() => null);
      return await storageReference.getDownloadURL();
    } catch (e) {
      log(e.toString());
      isUploading.value = false;
      return '';
    }
  }

  Stream<QuerySnapshot> getAllPosts() {
    return postCollection.snapshots();
  }

  Future<bool> handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return false;
      }
    }
    if (permission == LocationPermission.denied) {
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) {
      log("Permission Denied");
      return;
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      currentPosition = position;
      print(currentPosition!.latitude);
      await _getAddressFromLatLng(position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];

      currentAddress.value =
          "${place.subLocality},  ${place.subAdministrativeArea}, ${place.postalCode}";
      print(currentAddress.value);
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
