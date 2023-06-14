import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptanci_otomasyon/models/cart_model.dart';
import 'package:toptanci_otomasyon/models/product.dart';


class Orders{
  String? id;
  final double siparisTutari;
  final DateTime dateTime;
  final String userId;
  final int isComplete;
  final String orderNote;
  Orders( {required this.siparisTutari,required this.dateTime,required this.userId, this.id,required this.isComplete,required this.orderNote,});
  factory Orders.fromSnapshot(DocumentSnapshot snapshot){//, UserModel userModel
    return Orders(
      siparisTutari: snapshot['siparisTutari'],
      dateTime: snapshot['dateTime'].toDate(),
      userId: snapshot['userId'],
      isComplete: snapshot['isComplete'],
      orderNote: snapshot['orderNote'],
      id:snapshot.id,
    );
  }
  Map<String,dynamic>toMap(){
    return {
      'userId':userId,
      'orderNote':orderNote,
      'siparisTutari':siparisTutari,
      'dateTime':dateTime,
      'isComplete':isComplete,
    };
  }
}