import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptanci_otomasyon/view_models/base_model.dart';

class OrderViewModel extends BaseModel{
  Stream<QuerySnapshot<Map<String, dynamic>>> getOrders(){
    return FirebaseFirestore.instance.collection('orders').orderBy('isComplete').orderBy('dateTime').snapshots();
  }
  Future<DocumentSnapshot<Object?>> getUser(String userId)async{
    return await FirebaseFirestore.instance.collection('users').doc(userId).get();
  }
  Future<QuerySnapshot<Object?>> getCartItem(String? orderId)async{
    return await FirebaseFirestore.instance.collection('orders').doc(orderId).collection('products').get();
  }
  Future<DocumentSnapshot<Object?>> getProduct(String productId)async{
    return await FirebaseFirestore.instance.collection('products').doc(productId).get();
  }
}