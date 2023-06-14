/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'package:toptanci_otomasyon/models/profile.dart';

class ChatService{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Stream<List<Conversation>> getConversations(String userId){
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
 Stream<List<Conversation2>> getConversations2(String userId){
    var ref=_firestore.collection('messages');

    Stream<QuerySnapshot<Map<String, dynamic>>> conversationsStream=ref.snapshots();
    var profilesStreams=getContacts().asStream();

    return Rx.combineLatest2(
        conversationsStream,
        profilesStreams,
            (QuerySnapshot conversations, List<Profile> profiles ) => conversations.docs.map(
                (snapshot) {
              String members=snapshot['gonderen'];
              Profile profile=profiles.firstWhere((element) => element.id==members);
              return Conversation2.fromSnapshot(snapshot,profile);
            }
        ).toList()
    );
  }
  Future<List<Profile>> getContacts()async{
    var ref=_firestore.collection('users');
    var documents=await ref.get();
    return documents.docs.map((snapshot) => Profile.fromSnapshot(snapshot)).toList();
  }

  Future<Conversation> startConversation(User user, Profile profile) async{
    var ref=_firestore.collection('conversations');
    DocumentReference<Map<String, dynamic>> documentRef=await ref.add({
      'displayMessage':'',
      'members':[user.uid,profile.id],
    });
    return Conversation(
        id:documentRef.id,
        name: profile.userName,
        profileImage: profile.image,
        displayMessage: ''
    );
  }
}*/