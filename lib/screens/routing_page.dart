import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptanci_otomasyon/screens/admin_login.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/screens/home_page.dart';
import 'package:toptanci_otomasyon/screens/login_page.dart';
import 'package:toptanci_otomasyon/screens/admin_home_page.dart';
import 'package:toptanci_otomasyon/view_models/sign_in_model.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({Key? key}) : super(key: key);

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureProvider(
      create:(context) => getIt<SignInModel>().currentUser,
      initialData: null,
      child: Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<User?>(
                  builder: (context, value, child) => SizedBox(width: width/2,child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      primary: Colors.indigo,
                      minimumSize: Size(width/1.5, height/20)
                    ),
                      onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      if(value==null){
                        return LoginPage();
                      }
                      else if(value.uid=='RaZl2H5re4ckPjJyOJFNxjjslGy2'){
                        return SizedBox(child: Text('Siz adminsiniz lütfen çıkış yapın'),);
                      }
                      return HomePage();
                    }));
                  }, child:const Text('Kullanıcı Girişi'))),
                ),
                SizedBox(height: width/20,),
                Consumer<User?>(
                  builder: (context, value, child) =>SizedBox(width: width/2,child: ElevatedButton(
                    style:ElevatedButton.styleFrom(
                      primary: Colors.indigo,
                      minimumSize: Size(width/1.5, height/20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                    ),
                      onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) {
                      if(value==null){
                        return AdminLoginPage();
                      }
                      else if(value.uid != 'RaZl2H5re4ckPjJyOJFNxjjslGy2'){
                        return const SizedBox(child: Text('bu alana yetkiniz yok'),);
                      }
                      return AdminPage();
                    }));
                  }, child:const Text('Admin Girişi'))) ,

                ),
              ],
            ),
          ),
        ),
    );
  }
}//value==null ? const AdminLoginPage():const AdminPage()