import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/core/services/products_service.dart';
import 'package:toptanci_otomasyon/core/services/storage_service.dart';
import 'package:toptanci_otomasyon/models/product.dart';
import 'package:toptanci_otomasyon/view_models/base_model.dart';

class UpdateViewModel extends BaseModel{
  bool isComplete=true;
  String? imageUrl;
  final ProductService _productService=getIt<ProductService>();
  final StorageService _storageService=getIt<StorageService>();
  void updateProduct(Product product,String id,DateTime? dateTime,int? newPrice)async{
    isComplete=false;
    notifyListeners();
    await _productService.updateProduct(product,id,dateTime,newPrice);
    isComplete=true;
    notifyListeners();
    navigatorService.navigateToBackPage();
  }
  uploadMedia(ImageSource source)async{
    XFile? pickedFile=await ImagePicker().pickImage(source: source);
    if(pickedFile==null)return;
    imageUrl =await _storageService.uploadMedia(File(pickedFile.path),'productsPictures');
    notifyListeners();
  }
  void deleteMedia(String? imagePath){
    _storageService.deleteMedia('productsPictures/$imagePath');
  }
}