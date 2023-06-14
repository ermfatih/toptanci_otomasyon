import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService{
  final FirebaseStorage _firebaseStorage=FirebaseStorage.instance;

  Future<String> uploadMedia(File file,String path) async {
    Reference ref= _firebaseStorage.ref().child('$path/${DateTime.now().millisecondsSinceEpoch}.${file.path.split('.').last}');
    //await ref.putFile(file).then((p0) => debugPrint('bu işlem tamam'));
    //uploadTask.snapshotEvents.listen((event) {});

    //TaskSnapshot storageRef=await uploadTask.whenComplete(() =>null);

    return await ref.getDownloadURL();
  }
  Future<void> deleteMedia(String imagePath)async{
    await _firebaseStorage.ref().child(imagePath).delete();
  }
}