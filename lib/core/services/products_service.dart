import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptanci_otomasyon/models/product.dart';

class ProductService{
  final FirebaseFirestore _db=FirebaseFirestore.instance;
  Future<List<Product>> getProducts()async{
    var documents=await _db.collection('products').where('stock',isGreaterThanOrEqualTo: 0).get();
    return documents.docs.map((e) => Product.fromSnapshot(e)).toList();
  }
  Future<void> addProduct(Product product)async{
    await _db.collection('products').add(product.toMap());
  }
  getProductss(){
    _db.collection('products').where('stock',isGreaterThanOrEqualTo: 1).snapshots();
  }
  Future<void> updateProduct(Product product,String id,DateTime? dateTime,int? newPrice)async{
    await _db.collection('products').doc(id).update(product.toMap());
    await _db.collection('products').doc(id).update({'dateTime':dateTime,'newPrice':newPrice});
  }
  Future<void> deleteProduct(Product product)async{
    await _db.collection('products').doc(product.id).delete();
  }
  Future<List<Product>> getProductsByCategoryId(List<String> category)async{
    var documents=await _db.collection('products').where('categoryName',arrayContainsAny: category).get();
    return documents.docs.map((e) => Product.fromSnapshot(e)).toList();
  }
  Future<List<Product>> getProductsBySearch(String value)async{
    var documents=await _db.collection('products').where('name',arrayContains: value).get();
    return documents.docs.map((e) => Product.fromSnapshot(e)).toList();
  }
  getProductsByStock(){
    //if(_db.collection('products').where('stock').count()<10){ }
    // return documents.docs.map((e) => Product.fromSnapshot(e)).toList();
    _db.collection('products').where('stock',isGreaterThanOrEqualTo:10).snapshots();
  }
}