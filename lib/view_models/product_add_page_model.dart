import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/core/services/products_service.dart';
import 'package:toptanci_otomasyon/core/services/storage_service.dart';
import 'package:toptanci_otomasyon/models/product.dart';
import 'package:toptanci_otomasyon/view_models/base_model.dart';

class ProductAddModel extends BaseModel{
  final ProductService _db=getIt<ProductService>();
  final StorageService _storageService=getIt<StorageService>();
  String? imageUrl;

  bool isComplete=true;
  void addProduct(Product product)async{
    isComplete=false;
    notifyListeners();
    await _db.addProduct(product);
    isComplete=true;
    notifyListeners();
    navigatorService.navigateToBackPage();
    notifyListeners();
  }
  uploadMedia(ImageSource source)async{
    XFile? pickedFile=await ImagePicker().pickImage(source: source);
    if(pickedFile==null)return;
    imageUrl =await _storageService.uploadMedia(File(pickedFile.path),'productsPictures');
    notifyListeners();
  }
  bool isSelected=false;
  changeSelected(){
    isSelected=!isSelected;
    notifyListeners();
  }

  final ProductService _productService=getIt<ProductService>();
  void updateProduct(String id,Product product)async{

    //await _productService.updateProduct(id,product);

    navigatorService.navigateToBackPage();
  }
}