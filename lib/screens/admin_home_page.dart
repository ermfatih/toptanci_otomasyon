import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptanci_otomasyon/core/services/auth_service.dart';
import 'package:toptanci_otomasyon/models/order.dart';
import 'package:toptanci_otomasyon/models/product.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/models/userModel.dart';
import 'package:toptanci_otomasyon/screens/orders_page.dart';
import 'package:toptanci_otomasyon/screens/products_page.dart';
import 'package:toptanci_otomasyon/screens/admin_chat_room.dart';
import 'package:toptanci_otomasyon/screens/settings_page.dart';
import 'package:toptanci_otomasyon/screens/update_page.dart';
import 'package:toptanci_otomasyon/view_models/admin_home_page_model.dart';
import 'package:toptanci_otomasyon/widgets/custom_text_button.dart';
import 'package:pie_chart/pie_chart.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);


  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  ScrollController scrollController=ScrollController();

  var model = getIt<AuthService2>();
  UserModel? user;
  void getUser() async {
    UserModel? user = await model.getUser(FirebaseAuth.instance.currentUser!.uid) as UserModel;
    setState(() {
      this.user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }
  @override
  Widget build(BuildContext context) {

    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    var model=getIt<AdminHomeModel>();
    return ChangeNotifierProvider(
      create: (context) => model,
      child: Consumer<AdminHomeModel>(
        builder: (context, value, child) => Scaffold(
          drawer: Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAccountsDrawerHeader(
                        currentAccountPicture:
                        (user?.image==null)?  Icon(Icons.add):CircleAvatar(backgroundImage: NetworkImage(user!.image!)),
                        accountEmail: Text(user?.email ?? 'Yükleniyor...'),
                        accountName: Text(user?.userName ?? 'Yükleniyor...')),
                CustomTextButton(
                  icon: Icons.production_quantity_limits_outlined,
                  text: 'Ürünler', onPressed: () async{await value.goToPage( const ProductsPage());},
                ),
                CustomTextButton(icon: Icons.access_alarm,text: 'Siparişler',onPressed: ()async {
                  await value.goToPage( OrdersPage());
                },) ,
                CustomTextButton(icon: Icons.settings,text: 'Ayarlar',onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>SettingsPage(user: user),));
                },),
                CustomTextButton(
                    text: 'Çıkış Yap',
                    icon: Icons.exit_to_app,
                    onPressed: () async{
                      await value.signOut();
                    },
                  ),
              ],
            ),
          ),
          appBar: buildAppBar(value),
          body:
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(width/60),
              child: Column(
                    children:[
                      ShowCiro(model: model),
                      const TextIconWidget(text: 'En Çok Satılanlar ',icon: Icons.money),
                      StreamBuilder<QuerySnapshot>(
                        stream: model.howMoneySold(),
                        builder: (context, orderProducts) {
                          if(orderProducts.hasError) return const Text('bir problem var');
                          if(!orderProducts.hasData) return const Center(child:  Text('yükleniyor...'));
                          List<Product> list=orderProducts.data!.docs.map((e) => Product.fromSnapshot(e)).toList();
                          Map<String,double>dataMap2={};
                          list.forEach((element) {
                            dataMap2[element.name]=element.howMoneySold.toDouble();
                          });
                          return PieChart(dataMap: dataMap2);
                        }
                      ),
                      const TextIconWidget(text: 'Stok 10 un altındaki ürünler  ',icon: Icons.add_alert_rounded),
                      SizedBox(
                        height: height/5,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: model.getProductsByStock(),
                          builder: (context, products) {
                            if(products.hasError) return const Text('bir problem var');
                            if(!products.hasData) return const Center(child:  Text('yükleniyor...'));
                            if(products.data!.docs.isEmpty) return Text('Stok 10 un altında bir ürün yok');
                            List<Product> list=products.data!.docs.map((e) => Product.fromSnapshot(e)).toList();
                            return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(product: list[index]),));
                                    },
                                    child: Card(
                                      color: Colors.white,
                                        child: SizedBox(width: height/5,child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(height: height/7.5,child:list[index].photoUrl==null? Icon(Icons.production_quantity_limits):Image.network(list[index].photoUrl!),),
                                            Text(list[index].name ?? '',style: TextStyle(color: Colors.black),)
                                          ],
                                        ),)),
                                  );

                                },);
                          }
                        ),
                      ),
                      const TextIconWidget(text: 'Yaklaşan Siparişler ', icon: Icons.ice_skating),
                      SizedBox(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: model.getOrders(),
                            builder: (context, snapshot) {
                              if(snapshot.hasError) return const Text('bir problem var');
                              if(!snapshot.hasData) return const Center(child:  Text('yükleniyor...'));
                              List<Orders> list=snapshot.data!.docs.map((e) => Orders.fromSnapshot(e)).toList();
                              return ListView.builder(
                                controller: scrollController,
                                shrinkWrap: true,
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  DateTime date = list[index].dateTime;
                                  String dateTime = '${date.day} / ${date.month} / ${date.year}';
                                  return StreamBuilder<DocumentSnapshot>(
                                    stream:model.getUsers(list[index].userId),
                                    builder: (context, user) {
                                      if(user.hasError) return const Text('bir problem var');
                                      if(!user.hasData) return const Center(child:  Text('yükleniyor...'));
                                      var userInfo=user.data;
                                      return Card(
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) =>const OrdersPage(),));
                                          },
                                          title: Text(userInfo!['userName']),
                                          subtitle: Text(dateTime),
                                        ),
                                      );
                                    }
                                  );
                                },);
                            }
                        )
                      ),
                    ],
                  )
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(AdminHomeModel value) {
    return AppBar(
            title:const Text('Admin ana sayfa'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                    onPressed: () {
                      value.goToPage(const AdminChatRoom());
                    },
                    icon: const Icon(Icons.message)),
              ),
            ],
          );
  }
}

class ShowCiro extends StatelessWidget {
  const ShowCiro({
    Key? key,
    required this.model,
  }) : super(key: key);

  final AdminHomeModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextIconWidget(text: 'Satışlar ',icon: Icons.donut_large_outlined),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: model.sumOrdersDay(),
              builder: (context, snapshot) {
                double day=0;
                snapshot.data?.docs.forEach((element) {
                  day+=element['siparisTutari'];
                });
                return Column(
                  children: [
                    Text('Günlük'),
                    Container(height: 50,width: 100,color: Colors.white12,child: Center(child: Text('₺ '+day.toString())),),
                  ],
                );
              }
            ),
            StreamBuilder<QuerySnapshot>(
              stream: model.sumOrdersWeek(),
              builder: (context, snapshot) {
                double week=0;
                snapshot.data?.docs.forEach((element) {
                  week+=element['siparisTutari'];
                });
                return Column(
                  children: [
                    Text('Haftalık'),
                    Container(height: 50,width: 100,color: Colors.white12,child: Center(child: Text('₺ '+week.toString())))
                  ],
                );
              }
            ),
            StreamBuilder<QuerySnapshot>(
              stream: model.sumOrdersMount(),
              builder: (context, snapshot) {
                double mount=0;
                snapshot.data?.docs.forEach((element) {
                  mount+=element['siparisTutari'];
                });
                return Column(
                  children: [
                    Text('Aylık'),
                    Container(height: 50,width: 100,color: Colors.white12,child: Center(child: Text('₺ '+mount.toString()))),
                  ],
                );
              }
            ),
          ],
        ),
      ],
    );
  }
}

class TextIconWidget extends StatelessWidget {
  const TextIconWidget({Key? key, required this.text, required this.icon,}) : super(key: key);
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: height/90,bottom: height/90),
      child: Row(
        children: [
          Text(text,style: TextStyle(fontSize: height/40,fontWeight: FontWeight.w500, ),),
          Icon(icon)
        ],
      ),
    );
  }
}
/*StreamBuilder<QuerySnapshot>(
                        stream: model.getOrders(),
                        builder: (context, snapshot) {
                          if(snapshot.hasError) return const Text('bir problem var');
                          if(!snapshot.hasData) return const Center(child:  Text('yükleniyor...'));
                          List<Orders> list=snapshot.data!.docs.map((e) => Orders.fromSnapshot(e)).toList();
                          return ListView.builder(
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('Siparişi Gonderenin ismi'),
                              subtitle: Text(list[index].dateTime.day.toString()+'tarih'),
                            );
                          },);
                        }
                      )*/
/*,*/
/*  Future<bool> backButton({required BuildContext context}) async{
    return (await showDialog(context: context, builder: (context) =>AlertDialog(
      buttonPadding: EdgeInsets.all(50),
      title:const Text('Çıkış yapmak istediğinize emin misiniz'),
      actions: [
        ElevatedButton(onPressed: () {
          Navigator.pop(context);
        }, child:const Text('Hayır')),
        ElevatedButton(onPressed: () async{
          //burdan çıkış işlemi
        }, child:const Text('Evet'))
      ],),)) ?? false;
  }*/





