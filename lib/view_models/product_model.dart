import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/core/services/products_service.dart';
import 'package:toptanci_otomasyon/models/product.dart';
import 'package:toptanci_otomasyon/view_models/base_model.dart';

class ProductModel extends BaseModel{

  final ProductService _db=getIt<ProductService>();

  Map<String,bool> kategoriler={
    'Atıştırmalık':false,
    'Dondurma':false,
    'Su İçecek':false,
    'Süt Ürünleri':false,
    'Temel Gıda':false,
    'Yiyecek':false,
    'Diğer':false
  };
  List<String> selectedCategories = [];

  changeCategoryMap(int index,bool newBool){
    kategoriler.update(kategoriler.keys.elementAt(index), (val) => newBool);
    if (kategoriler.values.elementAt(index)) {
      selectedCategories.add(kategoriler.keys.elementAt(index).toString());
      notifyListeners();
    } else {
      selectedCategories.remove(kategoriler.keys.elementAt(index).toString());
      notifyListeners();
    }
    notifyListeners();
  }

  bool isOpenCategoryList=false;
  bool isOpenPriceList=false;

  void changeCategoryList(){
    isOpenCategoryList=!isOpenCategoryList;
    notifyListeners();
  }
  void changePriceList(){
    isOpenPriceList=!isOpenPriceList;
    notifyListeners();
  }


  Future<List<Product>>? getProducts()async{
    return await _db.getProducts();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshots(){
    return FirebaseFirestore.instance.collection('products').snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotsBySearch(String name){
    return FirebaseFirestore.instance.collection('products').orderBy('name').startAt([name]).snapshots();
    //orderBy('name').startAt([name]).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotsByFilter(List<String> list,double min,double max){
    return FirebaseFirestore.instance.collection('products').where('price',isLessThanOrEqualTo: max,isGreaterThanOrEqualTo: min).where('category',arrayContainsAny: list).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotsByMin(double min){
    return FirebaseFirestore.instance.collection('products').where('price',isGreaterThanOrEqualTo: min).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotsByCategories(List<String> list){
    return FirebaseFirestore.instance.collection('products').where('category',arrayContainsAny: list).snapshots();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotsBy({List<String>? list,String? name,double? min,double? max}){
    if(list==null || list.isEmpty){
      return FirebaseFirestore.instance.collection('products').where('price',isGreaterThanOrEqualTo: min,isLessThanOrEqualTo: max ??10000).snapshots();
    }
    if(name==null || name.isNotEmpty){
      return FirebaseFirestore.instance.collection('products').where('price',isGreaterThanOrEqualTo: min,isLessThanOrEqualTo: max ?? 10000).orderBy('name').startAt([name]).snapshots();
    }
    else{
      return FirebaseFirestore.instance.collection('products').where('category',arrayContainsAny: list).where('price',isGreaterThanOrEqualTo: min,isLessThanOrEqualTo: max ?? 10000).snapshots();
    }
  }

  Future<void> deleteProduct(Product product)async{
    navigatorService.navigateToBackPage();
    await _db.deleteProduct(product);
  }

}
