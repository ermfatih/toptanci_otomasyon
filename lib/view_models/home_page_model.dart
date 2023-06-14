import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/core/services/auth_service.dart';
import 'package:toptanci_otomasyon/core/services/products_service.dart';
import 'package:toptanci_otomasyon/view_models/base_model.dart';

class HomePageModel extends BaseModel{
  final ProductService _productService=getIt<ProductService>();
  final AuthService2 _authService=getIt<AuthService2>();


  getProducts(){
    FirebaseFirestore.instance.collection('products').where('stock',isGreaterThan: 0).snapshots();
  }
  signOut()async{
    try{
      await _authService.signOut();
      await navigatorService.navigateToRoutingPage();
    }catch(e){
      print(e);
    }
  }
}