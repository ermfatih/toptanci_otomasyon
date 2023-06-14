import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toptanci_otomasyon/widgets/chat_bubbles.dart';
import 'package:toptanci_otomasyon/models/profile.dart';
import 'package:toptanci_otomasyon/core/services/message_service.dart';
import 'package:toptanci_otomasyon/models/userModel.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController=TextEditingController();
  MessageService messageService=MessageService();
  late UserModel profile;
  

  Future<UserModel> getUser(String id)async{
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    //if(documentSnapshot.data()==null)return null;
    return UserModel.fromMap(documentSnapshot.data()!);
  }
  String id2=FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    setUser();
  }
  setUser()async{
    profile=await getUser(FirebaseAuth.instance.currentUser!.uid);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('destek ekranı')),
      body: Column(
        children: [
          Expanded(child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('messages').doc(FirebaseAuth.instance.currentUser!.uid).collection('messages')
                .orderBy('dateTime',descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) return Container();
              List<Message> list=snapshot.data!.docs.map((e) => Message.fromMap(e.data() as Map<String ,dynamic>)).toList();
              return ListView.builder(
                reverse: true,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ChatBubbles(
                    isCome: (list[index].senderId==FirebaseAuth.instance.currentUser!.uid) ? false:true,
                    text: list[index].message!,
                    time: list[index].dateTime!,
                  );
                },
              );
            }
          )
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
            child: Card(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                if (messageController.text != '') {
                                  messageService.sendMessages(
                                    profile: profile,
                                    Message(
                                      message: messageController.text,
                                      dateTime: DateTime.now(),
                                      senderId: 'asd',
                                    )
                                      ,FirebaseAuth.instance.currentUser!.uid);
                                  messageController.text = '';
                                }
                              });
                            },
                            icon: const Icon(Icons.send)),
                        contentPadding: const EdgeInsets.all(12),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide.none),
                        hintText: 'buraya mesajınızı giriniz')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}