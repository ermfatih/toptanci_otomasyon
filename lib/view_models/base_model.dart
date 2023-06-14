import 'package:flutter/material.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/core/services/navigator_service.dart';

abstract class BaseModel with ChangeNotifier{
  final NavigatorService navigatorService=getIt<NavigatorService>();
  bool _busy=false;

  bool get busy => _busy;

  set busy(bool state) {
    _busy = state;
    notifyListeners();
  }
}