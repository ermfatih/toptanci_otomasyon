import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/core/services/storage_service.dart';
import 'package:toptanci_otomasyon/models/userModel.dart';
import 'package:toptanci_otomasyon/view_models/base_model.dart';

class SettingModel extends BaseModel{
  final StorageService _storageService=getIt<StorageService>();
  bool readOnly=true;
  String? imageUrl;
  changePhoto(ImageSource source,String userId)async{
    //String url;
    XFile? pickedFile=await ImagePicker().pickImage(source: source);
    if(pickedFile==null)return;
    imageUrl= await _storageService.uploadMedia(File(pickedFile.path),'usersPictures');
    FirebaseFirestore.instance.collection('users').doc(userId).update({'image':imageUrl,});
  }
  changePassword(){}

  void openEdit(){
    readOnly=!readOnly;
    notifyListeners();
  }
  Future<void> updateUser({required String id,required String userName,required String address,required String businessName})async{
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      'address':address,
      'businessName':businessName,
      'userName':userName
    });
  }
}