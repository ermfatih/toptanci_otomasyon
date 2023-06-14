import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/core/services/navigator_service.dart';
import 'package:toptanci_otomasyon/firebase_options.dart';
import 'package:toptanci_otomasyon/models/cart_model.dart';
import 'package:toptanci_otomasyon/models/check_box_model.dart';
import 'package:toptanci_otomasyon/screens/routing_page.dart';
import 'package:toptanci_otomasyon/view_models/home_page_model.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupLocators();
  runApp(MultiProvider(
    providers: [
    //ChangeNotifierProvider(create: (context) => CheckBoxModel(),),
    ChangeNotifierProvider(create: (context) => CartModel(),
    )
  ],child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: getIt<NavigatorService>().navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        appBarTheme:const AppBarTheme(
            centerTitle: true),
      ),
      home: const RoutingPage(),
    );
  }
}


