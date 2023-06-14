import 'package:cloud_firestore/cloud_firestore.dart';

class Chats {
  final String? id;

  Chats({ this.id});

  factory Chats.fromSnapshot(DocumentSnapshot snapshot){
    return Chats(
      id: snapshot['gonderen'],
    );
  }
}