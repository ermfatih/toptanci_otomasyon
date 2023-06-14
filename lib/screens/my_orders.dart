import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toptanci_otomasyon/models/order.dart';
import 'package:toptanci_otomasyon/screens/orders_page.dart';
import 'package:toptanci_otomasyon/widgets/border_text.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({Key? key, required this.userId}) : super(key: key);
  final String userId;
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Siparişlerim')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').where('userId',isEqualTo: userId).snapshots(),
        builder: (context, orderList) {
          if (!orderList.hasData || orderList.data == null) return Container();
          List<Orders> list=orderList.data!.docs.map((e) => Orders.fromSnapshot(e)).toList().reversed.toList();
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              DateTime i=list[index].dateTime;
              String dateTime='${i.day} / ${i.month} / ${i.year}';
              return Container(
                margin:const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: list[index].isComplete== 0 ? Colors.green:Colors.white54,width: 3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Text(dateTime,style: TextStyle(fontSize: 22)),
                      Text('₺ '+list[index].siparisTutari.toString(),style: TextStyle(fontSize: 22)),
                    ],),
                    SizedBox(
                      height: height/3.5,
                      child: FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance.collection('orders').doc(list[index].id).collection('products').get(),
                        builder: (context, products) {
                          if (!products.hasData || products.data == null) return Container();
                          var productList=products.data!.docs;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                            return Card(
                              child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance.collection('products').doc(productList[index]['productId']).get(),
                                builder: (context, snapshot) {
                                  if (!products.hasData || products.data == null) return Container();
                                  var product=snapshot.data;
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: height/6,
                                        width: width/2.7,
                                        child: (product?['photoUrl']==null)?Icon(Icons.add) :Image.network(product!['photoUrl']),
                                      ),
                                      BorderText(text: product?['name'],height: 20,width: width/3,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          BorderText(text:product?['price'].toString() ,height: height/35,width: width/6,),
                                          BorderText(text:productList[index]['count'].toString(),height: height/35,width:width/6 ,),
                                        ],)
                                    ],
                                  );
                                }
                              ),
                            );
                          },);
                        }
                      ),
                    )

                  ],
                ),
              );
          },);
        }
      ),
    );
  }
}
// cart.data?.docs[index]['count'].toString()
//(product.data?['price'] ?? 1 * cart.data?.docs[index]['count'] ?? 1).toString()
