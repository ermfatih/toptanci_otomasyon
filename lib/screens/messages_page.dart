import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toptanci_otomasyon/screens/chat_room.dart';
import 'package:toptanci_otomasyon/core/services/message_service.dart';
import 'package:toptanci_otomasyon/models/userModel.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  //final a=FirebaseFirestore.instance.collection('messages').doc('admin').collection('fatih@gmail.com').orderBy('dateTime',descending: true).snapshots();
  //Stream<DocumentSnapshot<Map<String, dynamic>>> a=FirebaseFirestore.instance.collection('messages').doc('admin').get().asStream();
  //final String userId='RaZl2H5re4ckPjJyOJFNxjjslGy2';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child:const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>const UsersPage(),));
        },
      ),
      appBar: AppBar(title:const Text('Gelen mesajlar'),),
      body:
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('messages').doc('admin').collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) return const Text('veritabanı boş');
          List<Message> liste=snapshot.data!.docs.map((e) => Message.fromMap(e.data() as Map<String ,dynamic>)).toList();
          return ListView.builder(
                    itemCount: liste.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) =>const ChatRoom(),));
                        },
                        child:Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.account_circle),
                            ),
                            title: Text('kullanıcı adı'),
                            subtitle: Text(liste[index].message!),
                          ),
                        ),
                      );
                      },
          );
        }
      )
    );
  }
}
class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final Stream<QuerySnapshot> _userssStream = FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Tüm kullanıcılar'),),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userssStream,
        builder: (context, snapshot){
          if (!snapshot.hasData || snapshot.data == null) return Container();
          List<UserModel> list=snapshot.data!.docs.map((e) => UserModel.fromMap(e.data() as Map<String ,dynamic>)).toList();
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return  GestureDetector(
                onTap: () {//
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom()));
                },
                child: Card(
                  child: ListTile(
                    title: Text(list[index].userName ?? 'isimsiz kullanıcı'),
                    subtitle:const Text('asd'),
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}


