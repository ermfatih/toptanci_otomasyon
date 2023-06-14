import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/models/order.dart';
import 'package:toptanci_otomasyon/view_models/order_view_model.dart';
import 'package:toptanci_otomasyon/widgets/border_text.dart';
import 'package:toptanci_otomasyon/widgets/custom_alert_dialog.dart';
import 'package:toptanci_otomasyon/widgets/custom_elevated_button.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var model = getIt<OrderViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Siparişler'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(stream: model.getOrders(),
                builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) return Container();
              List<Orders> orderList = snapshot.data!.docs
                  .map((e) => Orders.fromSnapshot(e))
                  .toList();
              return ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  DateTime date = orderList[index].dateTime;
                  String dateTime = '${date.day} / ${date.month} / ${date.year}';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12, right: 6, left: 6),
                    child: FutureBuilder<DocumentSnapshot>(
                        future: model.getUser(orderList[index].userId),
                        builder: (context, user) {
                          if (!user.hasData || user.data == null) return const Center(child: CircularProgressIndicator(),);
                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15))),
                                isScrollControlled: true,
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SizedBox(
                                      height: 600,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                    color: Colors.white30,
                                                  )),
                                                  height: 150,
                                                  child: (user.data!['image'].toString().isEmpty) ? Icon(Icons.add):
                                                  SizedBox(
                                                    width: width/3,
                                                      child: Image.network(user.data?['image']))),
                                              Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  BorderText(
                                                    text: user.data?['userName'],
                                                    width: width / 1.75,
                                                    height: height / 18,
                                                  ),
                                                  BorderText(
                                                      text: user.data?['businessName'],
                                                      width: width / 1.75,
                                                      height: height / 18),
                                                  BorderText(
                                                      text: user.data?['telNo'],
                                                      width: width / 1.75,
                                                      height: height / 18),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 200,
                                            child: FutureBuilder<QuerySnapshot>(
                                                future:model.getCartItem(orderList[index].id),
                                                builder: (context, cart) {
                                                  var cartList = cart.data?.docs;
                                                  return ListView.builder(scrollDirection: Axis.horizontal, itemCount: cartList?.length ?? 0,
                                                    itemBuilder: (context, index) {
                                                      return Container(margin: const EdgeInsets.all(6),
                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                                                        width: 150,
                                                        child:
                                                        FutureBuilder<DocumentSnapshot>(
                                                            future: model.getProduct(cartList?[index]['productId']),
                                                            builder: (context, product) {
                                                              return Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Container(
                                                                    height: height / 6,
                                                                    child:product.data?['photoUrl']==null? Icon(Icons.add_alert): Image.network(product.data!['photoUrl']),
                                                                  ),
                                                                  BorderText(
                                                                    text: product.data?['name'],
                                                                    textColor: Colors.black,
                                                                    height: 20,
                                                                    width: width / 2.8,
                                                                  ),
                                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      (cartList?[index]['count']==null) ? CircularProgressIndicator():BorderText(text: cartList![index]['count'].toString()+' A', textColor: Colors.black,
                                                                        height: height /35, width: width / 6,
                                                                      ),
                                                                      BorderText(
                                                                        text: (product.data?['price'] ?? 1 * cartList?[index]['count'] ?? 1).toString(),
                                                                        textColor: Colors.black, height: height / 35, width: width/6,
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              );
                                                            }),
                                                      );
                                                    },
                                                  );
                                                }),
                                          ),
                                          BorderText(text: user.data!['address'],),
                                          BorderText(text: orderList[index].orderNote),
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              BorderText(text: dateTime, width: width / 2.3,),
                                              BorderText(text: '₺ ' + orderList[index].siparisTutari.toString(), width: width / 2.3,
                                              )
                                            ],
                                          ),
                                          CustomElevatedButton(
                                            text: 'Teslim Et',
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CustomAlertDialog(
                                                      onPressedA: () async{
                                                          await FirebaseFirestore.instance.collection('orders').doc(orderList[index].id).update({'isComplete': 1});
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                      },
                                                      onPressedB: () {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: orderList[index].isComplete == 0
                                        ? Colors.green
                                        : Colors.white54,
                                    width: 3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 100,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 3,
                                                  color: Colors.white30),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      user.data!['image'])),
                                              borderRadius: const BorderRadius.all(Radius.circular(0))),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: BorderText(
                                              width: 200,
                                              height: 40,
                                              text:
                                                  user.data?['userName'] ?? '',
                                            ),
                                          ),
                                          BorderText(
                                            width: 200,
                                            height: 40,
                                            text: dateTime,
                                          ),
                                          BorderText(
                                            width: 200,
                                            height: 40,
                                            text: '₺ ${orderList[index].siparisTutari}',
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                },
              );
            },
          ))
        ],
      ),
    );
  }
}


