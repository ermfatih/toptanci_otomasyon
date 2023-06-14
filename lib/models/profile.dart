/*import 'package:cloud_firestore/cloud_firestore.dart';

class Profile{
  String? id;
  String? userName;
  String? image;


  Profile({required this.id,required this.userName,required this.image});
  Profile.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    image = json['image'];
  }
  factory Profile.fromSnapshot(DocumentSnapshot snapshot){
    return Profile(
        id: snapshot.id,
        userName: snapshot['userName'] ?? 'boş',
        image: snapshot['image']);
  }
  Map<String,dynamic>toMap(){
    return {
      'id':id,
      'userName':userName,
      'image':image
    };
  }
}*/