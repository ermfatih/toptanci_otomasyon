import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toptanci_otomasyon/models/profile.dart';
import 'package:toptanci_otomasyon/models/userModel.dart';

class AuthService2{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _fireStore=FirebaseFirestore.instance;
  Future<User?> signIn(String email,String password)async{
    UserCredential user=await _auth.signInWithEmailAndPassword(email: email, password: password);
    return user.user;
  }
  Future signOut()async{
    return await _auth.signOut();
  }
  Future createAccount(UserModel userModel)async{
    //await _fireStore.collection('users').doc('admin').collection('messages').add(userModel.toMap());
    UserCredential user =await _auth.createUserWithEmailAndPassword(email: userModel.email!, password: userModel.password!);
    await _fireStore.collection('users').doc(user.user!.uid).set(userModel.toMap());
    return user.user!;
  }
  Future<User?> get currentUser async => _auth.currentUser;
  Future<UserModel?> getUser(String? id)async{
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await _fireStore.collection('users').doc(id).get();
    if(documentSnapshot.data()==null)return null;
    return UserModel.fromMap(documentSnapshot.data()!);
  }
}