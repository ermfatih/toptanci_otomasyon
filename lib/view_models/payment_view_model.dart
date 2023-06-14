import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/core/services/order_service.dart';
import 'package:toptanci_otomasyon/models/cart_model.dart';
import 'package:toptanci_otomasyon/models/order.dart';
import 'package:toptanci_otomasyon/models/product.dart';
import 'package:toptanci_otomasyon/view_models/base_model.dart';

class PaymentViewModel extends BaseModel{
  final OrderService _orderService =getIt<OrderService>();
  Future<void> addOrder(Orders order,List<Tuple> list)async{
    await _orderService.addOrder(order,list);

    /*list.forEach((tuple) async{
      await FirebaseFirestore.instance.collection('products').doc(tuple.product.id).update({
        'stock':tuple.product.stock-tuple.quantity
        //burda bir de kaç adetsatıldığı
      });
    });*/
  }


}