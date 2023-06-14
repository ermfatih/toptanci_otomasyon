import 'package:cloud_firestore/cloud_firestore.dart';

class Product{
  final String? id;
  final String name;
  final int price;
  final List<dynamic> category;
  final int stock;
  final String? photoUrl;
  final String description;
  final int koliAdet;
  final int howMoneySold;


  Product( {required this.category,required this.name,required this.price, this.id,required this.stock,required this.photoUrl,required this.description,required this.koliAdet,required this.howMoneySold, });
  factory Product.fromSnapshot(DocumentSnapshot snapshot){
    return Product(
        name: snapshot['name'],
        price: snapshot['price'],
        category: snapshot['category'],
        stock: snapshot['stock'],
        photoUrl: snapshot['photoUrl'],
        koliAdet: snapshot['koliAdet'],
        description: snapshot['description'],
        howMoneySold: snapshot['howMoneySold'],
        //dateTime: snapshot['dateTime'],
        //newPrice: snapshot['newPrice'],
        id: snapshot.id
    );
  }
  Map<String,dynamic>toMap(){
    return {
      'name':name,
      'price':price,
      'category':category,
      'stock':stock,
      'photoUrl':photoUrl,
      'description':description,
      'koliAdet':koliAdet,
      'howMoneySold':howMoneySold,
      //'newPrice':newPrice,
      //'dateTime':dateTime,
    };
  }
}
