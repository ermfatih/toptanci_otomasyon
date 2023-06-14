import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/core/services/auth_service.dart';
import 'package:toptanci_otomasyon/core/services/products_service.dart';
import 'package:toptanci_otomasyon/core/services/storage_service.dart';
import 'package:toptanci_otomasyon/models/userModel.dart';
import 'package:toptanci_otomasyon/view_models/base_model.dart';

class AdminHomeModel extends BaseModel{
  final AuthService2 _authService=getIt<AuthService2>();
  final StorageService _storageService=getIt<StorageService>();
  //final ProductService _productService=getIt<ProductService>();
  String? mediaUrl;

  
  Stream<QuerySnapshot<Map<String, dynamic>>> howMoneySold(){
    return FirebaseFirestore.instance.collection('products').orderBy('howMoneySold',descending: true).limit(10).snapshots();
  }
  getProductsByStock(){
    return FirebaseFirestore.instance.collection('products').where('stock',isLessThanOrEqualTo:10).snapshots();
  }
  uploadMedia(ImageSource source)async{
    XFile? pickedFile=await ImagePicker().pickImage(source: source);
    if(pickedFile==null)return;
    mediaUrl=await _storageService.uploadMedia(File(pickedFile.path),'usersPictures');
    notifyListeners();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getOrders(){
    return FirebaseFirestore.instance.collection('orders').where('isComplete',isEqualTo: 0).orderBy('dateTime').limit(10).snapshots();
  }
  getUsers(String userId){
    return FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
  }
  signOut()async{
    try{
      await _authService.signOut();
      await navigatorService.navigateToRoutingPage();
    }catch(e){
      print(e);
    }
  }
  sumOrdersWeek(){
    return FirebaseFirestore.instance.collection('orders').where('dateTime',isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 7)),isLessThanOrEqualTo: DateTime.now()).snapshots();
  }
  sumOrdersDay(){
    return FirebaseFirestore.instance.collection('orders').where('dateTime',isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 1)),isLessThanOrEqualTo: DateTime.now()).snapshots();
  }
  sumOrdersMount(){
    return FirebaseFirestore.instance.collection('orders').where('dateTime',isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 30)),isLessThanOrEqualTo: DateTime.now()).snapshots();
  }
  
  goToPage(Widget route)async{
    await navigatorService.navigateTo(route);
  }
}
/*Future<UserModel> getUser()async{
    return await _authService.getUser(FirebaseAuth.instance.currentUser!.uid) as UserModel;
  }*/