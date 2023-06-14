import 'package:get_it/get_it.dart';
import 'package:toptanci_otomasyon/core/services/auth_service.dart';
import 'package:toptanci_otomasyon/core/services/navigator_service.dart';
import 'package:toptanci_otomasyon/core/services/order_service.dart';
import 'package:toptanci_otomasyon/core/services/products_service.dart';
import 'package:toptanci_otomasyon/core/services/storage_service.dart';
import 'package:toptanci_otomasyon/view_models/admin_home_page_model.dart';
import 'package:toptanci_otomasyon/view_models/admin_sign_in_model.dart';
import 'package:toptanci_otomasyon/view_models/home_page_model.dart';
import 'package:toptanci_otomasyon/view_models/order_view_model.dart';
import 'package:toptanci_otomasyon/view_models/payment_view_model.dart';
import 'package:toptanci_otomasyon/view_models/product_add_page_model.dart';
import 'package:toptanci_otomasyon/view_models/product_model.dart';
import 'package:toptanci_otomasyon/view_models/settings_view_model.dart';
import 'package:toptanci_otomasyon/view_models/sign_in_model.dart';
import 'package:toptanci_otomasyon/view_models/update_view_model.dart';

GetIt getIt=GetIt.instance;

setupLocators(){
  //getIt.registerLazySingleton(() => ChatService());
  getIt.registerLazySingleton(() => AuthService2());
  getIt.registerLazySingleton(() => NavigatorService());
  getIt.registerLazySingleton(() => StorageService());
  getIt.registerLazySingleton(() => ProductService());
  getIt.registerLazySingleton(() => OrderService());

  //getIt.registerFactory(() => ChatsModel());
  getIt.registerFactory(() => SignInModel());
  getIt.registerFactory(() => AdminSignInModel());
  //getIt.registerFactory(() => ContactsModel());
  //getIt.registerFactory(() => ConversationModel());
  getIt.registerFactory(() => AdminHomeModel());
  getIt.registerFactory(() => ProductModel());
  getIt.registerFactory(() => HomePageModel());
  getIt.registerFactory(() => ProductAddModel());
  //getIt.registerFactory(() => CartViewModel());
  getIt.registerFactory(() => UpdateViewModel());
  getIt.registerFactory(() => PaymentViewModel());
  getIt.registerFactory(() => OrderViewModel());
  getIt.registerFactory(() => SettingModel());


}