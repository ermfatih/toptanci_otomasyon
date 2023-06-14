import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/core/services/auth_service.dart';
import 'package:toptanci_otomasyon/screens/admin_home_page.dart';
import 'package:toptanci_otomasyon/view_models/base_model.dart';

class AdminSignInModel extends BaseModel{
  final AuthService2 _authService=getIt<AuthService2>();
  final FirebaseFirestore _fireStore=FirebaseFirestore.instance;

  Future<User?> get currentUser async => _authService.currentUser;

  adminSignIn(String email,String password)async{
    busy=true;
    try{
      var user=await _authService.signIn(email, password);
      await _fireStore.collection('users').doc(user?.uid).update({
        'email':email,
        'password':password,
        'userName':'admin',
      });
      await navigatorService.navigateToReplacement(const AdminPage());
    }catch(e){
      print(e);
    }
    busy=false;
  }
  signOut()async{
    try{
      await _authService.signOut();
      await navigatorService.navigateToRoutingPage();
    }catch(e){
      print(e);
    }
  }
}