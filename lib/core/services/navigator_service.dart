import 'package:flutter/material.dart';
import 'package:toptanci_otomasyon/screens/routing_page.dart';

class NavigatorService{
  final GlobalKey<NavigatorState> _navigatorKey=GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Future<dynamic> navigateTo(Widget route){
    return _navigatorKey.currentState!.push(MaterialPageRoute(builder: (context) => route,));
  }
  Future<dynamic> navigateToReplacement(Widget route){
    return _navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context) => route,));
  }
  Future<dynamic> navigateToRoutingPage(){
    return _navigatorKey.currentState!.pushReplacement(MaterialPageRoute(builder: (context) => RoutingPage(),));
  }
  void navigateToBackPage(){
    _navigatorKey.currentState!.pop();
  }
}