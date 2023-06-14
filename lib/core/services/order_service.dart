import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toptanci_otomasyon/models/cart_model.dart';
import 'package:toptanci_otomasyon/models/order.dart';
import 'package:toptanci_otomasyon/models/product.dart';
import 'package:toptanci_otomasyon/models/userModel.dart';

class OrderService{
  var ref=FirebaseFirestore.instance.collection('orders');
  var userRef=FirebaseFirestore.instance.collection('users');
  var productsRef=FirebaseFirestore.instance.collection('products');
  Future<void> addOrder(Orders order,List<Tuple> list)async{
    await ref.doc(order.dateTime.millisecondsSinceEpoch.toString()).set(
      order.toMap()
    );

    list.forEach((tuple) async{
      await FirebaseFirestore.instance.collection('products').doc(tuple.product.id).update({
        'stock':tuple.product.stock-tuple.quantity
      });
      await ref.doc(order.dateTime.millisecondsSinceEpoch.toString()).collection('products').add({
        'productId':tuple.product.id,
        'count':tuple.quantity
        }
      );
      await productsRef.doc(tuple.product.id).update({
        'howMoneySold':tuple.product.howMoneySold+tuple.quantity
      });
    });
  }
  Future<void> order(Orders order)async{
    await ref.add({
      'gonderen':FirebaseAuth.instance.currentUser!.uid,
      'siparisTutari':order.siparisTutari
    });

  }
  Future<List<UserModel>> getUsers()async{
    var documents=await userRef.get();
    return documents.docs.map((snapshot) => UserModel.fromMap(snapshot as Map<String,dynamic>)).toList();
  }


}

/*Stream<List<Conversation>> getConversations(String userId){
    var ref=_firestore.collection('conversations')
        .where('members',arrayContains: userId);

    var conversationsStream=ref.snapshots();
    var profilesStreams=getContacts().asStream();

    return Rx.combineLatest2(
        conversationsStream,
        profilesStreams,
            (QuerySnapshot conversations, List<Profile> profiles ) => conversations.docs.map(
                    (snapshot) {
                      List<String> members=List.from(snapshot['members']);
                      Profile profile=profiles.firstWhere((element) => element.id==members.firstWhere((element) => element!=userId));
                      return Conversation.fromSnapshot(snapshot,profile);
                    }
            ).toList()
    );
  }
  }
  Future<List<Profile>> getContacts()async{
    var ref=_firestore.collection('users');
    var documents=await ref.get();
    return documents.docs.map((snapshot) => Profile.fromSnapshot(snapshot)).toList();
  }*/