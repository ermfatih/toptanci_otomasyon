import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/models/chat.dart';
import 'package:toptanci_otomasyon/screens/my_chat_room.dart';


class AdminChatRoom extends StatelessWidget {
  const AdminChatRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var model=getIt<ChatsModel>();
    Stream<QuerySnapshot<Map<String, dynamic>>> a=FirebaseFirestore.instance.collection('messages').snapshots();
    return Scaffold(
      appBar: AppBar(title: Text('Gelen Mesajlar'),),
      body: StreamBuilder<QuerySnapshot>(
        stream: a,
        builder: (context, chats) {
          if (!chats.hasData || chats.data == null) return Container();
          var list=chats.data!.docs.map((e) => Chats.fromSnapshot(e)).toList();
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(list[index].id).snapshots(),
                builder: (context, user) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyRoom(id: list[index].id!,userName: user.data?['userName'] ?? ''),));
                      },
                      child: Card(
                            child: ListTile(
                              title: Text(user.data?['userName'] ?? ''),
                              subtitle: Text(chats.data!.docs[index]['displayMessage'] ?? ''),
                              leading: CircleAvatar(backgroundImage: NetworkImage(user.data?['image'] ?? '')),
                            ),
                          )
                        );
                }
              );
            },);
        },
      ),
    );
  }
}
/*,*/