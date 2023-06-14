import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toptanci_otomasyon/models/userModel.dart';

class MessageService{

  var userRef=FirebaseFirestore.instance.collection('users');
  void sendMessages(Message message,String id,{required UserModel profile})async{
      await FirebaseFirestore.instance.collection('messages').doc(id).collection('messages').add({
        'message': message.message,
        'dateTime':message.dateTime,
        'senderId':FirebaseAuth.instance.currentUser!.uid,
        //message.toMap()
      });
    await FirebaseFirestore.instance.collection('messages').doc(id).set({
      'gonderen':id,
      //'userRef': userRef.doc(FirebaseAuth.instance.currentUser!.uid),
      'userName':profile.userName,
      'image':profile.image,
      'displayMessage':message.message
    });
  }
  void adminSendMessage(Message message,String id,)async{
    await FirebaseFirestore.instance.collection('messages').doc(id).collection('messages').add(message.toMap());
    await FirebaseFirestore.instance.collection('messages').doc(id).update({'displayMessage':message.message});
  }

  Future<void> startConversation(User user) async{
    var ref=FirebaseFirestore.instance.collection('conversations');
    await ref.add({
      'gonderen':user.uid,
    });
  }
  Stream<QuerySnapshot<Map<String,dynamic>>> get(){
    return FirebaseFirestore.instance.collection('messages').snapshots();
  }
}

class Message{
  String? message;
  DateTime? dateTime;
  String? senderId;
  Message({required this.message, required this.dateTime,required senderId});
  Message.fromMap(Map<String, dynamic> json) {
    message = json['message'];
    dateTime = json['dateTime'].toDate();
    senderId=json['senderId'];
  }
  Map<String,dynamic> toMap(){
    return {
      'message':message,
      'dateTime':dateTime,
      'senderId':senderId,
    };
  }
}