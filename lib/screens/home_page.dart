import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptanci_otomasyon/screens/chat_room.dart';
import 'package:toptanci_otomasyon/core/services/auth_service.dart';
import 'package:toptanci_otomasyon/models/cart_model.dart';
import 'package:toptanci_otomasyon/models/product.dart';
import 'package:toptanci_otomasyon/screens/cart_page.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/screens/my_orders.dart';
import 'package:toptanci_otomasyon/screens/orders_page.dart';
import 'package:toptanci_otomasyon/screens/settings_page.dart';
import 'package:toptanci_otomasyon/models/userModel.dart';
import 'package:toptanci_otomasyon/view_models/home_page_model.dart';
import 'package:toptanci_otomasyon/widgets/custom_text_button.dart';
import 'package:toptanci_otomasyon/widgets/twice_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var model2 = getIt<AuthService2>();
  UserModel? user2;
  void getUser() async {
    UserModel? user2 = await model2.getUser(FirebaseAuth.instance.currentUser!.uid) as UserModel;
    setState(() {
      this.user2 = user2;
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
    var model = getIt<HomePageModel>();
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(),
          actions: [
            Consumer<CartModel>(
              builder: (context, value, child) {
                var cartItems = value.cart;
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: cartItems.isNotEmpty
                        ? Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Text(value.cart.length.toString()),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CartPage(),
                                        ));
                                  },
                                  icon: const Icon(
                                      Icons.add_shopping_cart_outlined))
                            ],
                          )
                        : const SizedBox.shrink());
              },
            ),
          ],
        ),
        drawer: Drawer(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: InkWell(
                onTap: () {
                },
                child: (user2?.image==null) ?const Icon(Icons.manage_accounts_sharp):CircleAvatar(
                  backgroundImage: NetworkImage(user2!.image!),),
              ),
              accountEmail: Text(user2?.email ?? 'yükleniyor...'),
              accountName: Text(user2?.userName ?? 'yükleniyor...'),
            ),

            CustomTextButton(icon: Icons.settings,text: 'Ayarlar',onPressed: () {model.navigatorService.navigateTo(SettingsPage(
              user: user2,
            ));},),
            CustomTextButton(icon: Icons.add_shopping_cart_rounded,text: 'Sepetim',onPressed: () {model.navigatorService.navigateTo(const CartPage());},),
            CustomTextButton(icon: Icons.message, text: 'Destek', onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) =>const ChatRoom(),));
              },
            ),
            CustomTextButton(icon: Icons.shopping_cart, text: 'Siparişlerim', onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => MyOrdersPage(userId: FirebaseAuth.instance.currentUser!.uid),));
            },
            ),
            CustomTextButton(icon:Icons.exit_to_app ,text: 'Çıkış Yap',onPressed: ()async {await model.signOut();},),
          ],
        )),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('products').where('stock',isGreaterThan: 0).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Text('bir problem var');
              if (!snapshot.hasData) {
                return const Center(child: Text('yükleniyor...'));
              }
              List<Product> list=snapshot.data!.docs.map((e) => Product.fromSnapshot(e)).toList();
              return GridView.builder(
                itemCount: list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 0,),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))),
                          context: context, builder: (context) {
                            return Consumer<CartModel>(
                              builder: (context, value, child) {
                              int productCount=value.howManyInCart(list[index]);
                                return Container(
                                  height: 600,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(onPressed: () {
                                        Navigator.pop(context);

                                      }, icon: Icon(Icons.arrow_drop_down,size: 35,)),
                                      Container(
                                        decoration:BoxDecoration(color: Colors.teal,border: Border.all(color: Colors.white70,width: 3),borderRadius: BorderRadius.circular(10)),
                                          width: 370,child:(list[index].photoUrl==null || list[index].photoUrl!.isEmpty)? Icon(Icons.add):Image.network(height:100 ,width: 80,list[index].photoUrl!)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ProductInfo(text: 'Ürün Adı:  ${list[index].name}'),
                                          ProductInfo(text: 'Fiyat:  ${list[index].price.toString()}'),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ProductInfo(text: 'Kategori  ${list[index].category.first}'),
                                          ProductInfo(text: 'Birim Fiyat:  ${list[index].price/(list[index].koliAdet)} TL'),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ProductInfo(text: 'Koli Adet  ${list[index].koliAdet}'),
                                          ProductInfo(text: 'Stok:  ${list[index].stock}'),
                                        ],
                                      ),
                                      ProductInfo(text: '${list[index].description}',width: 365,height:50),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          productCount==0 ?ElevatedButton.icon(
                                            icon: Icon(Icons.shopping_cart_outlined),
                                            style:ElevatedButton.styleFrom(
                                                primary: Colors.indigo,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                minimumSize: Size(100, 50)
                                            ),
                                                onPressed: () {
                                                  value.addProduct(list[index]);
                                                },
                                                label: Text('SEPETE EKLE',)):SizedBox.shrink(),
                                          productCount>0?Container(
                                            child: TwiceWidget(
                                              onPressedA: () {
                                                value.incQuantity(list[index]);
                                              },
                                              onPressedB: () {
                                                value.decQuantity(list[index]);
                                                if (value.howManyInCart(
                                                    list[index]) < 1) {
                                                  value.removeProduct(list[index]);
                                                }
                                              },
                                              text: value.howManyInCart(list[index]).toString(),
                                            ),
                                          ):SizedBox.shrink(),
                                        ],
                                      ),


                                      //productCount>0? ElevatedButton(onPressed: () {}, child: Text('Sepete Git')):SizedBox.shrink()
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: list[index].price>400? Border.all(color: Colors.red,width: 6):null,
                            //border: list[index].price>400? Border.all(color: Colors.red,width: 6):null,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),

                          ),

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                            SizedBox(
                              height: height/13,
                                width: width/4,
                                child: (list[index].photoUrl==null || list[index].photoUrl!.isEmpty)? Icon(Icons.add) : Image.network(list[index].photoUrl!)),

                            Text(list[index].name,style: TextStyle(color: Colors.black)),
                            Text('₺ '+list[index].price.toString(),style: TextStyle(color: Colors.black)),
                          ]),
                        ),
                      ),
                    ),
                  );
                },
              );
            }));
  }
}

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    Key? key, required this.text, this.width, this.height,

  }) : super(key: key);

  final String text;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: (height==null) ? 50:height,
      width: (width==null) ? 180:width,
      //margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1,color: Colors.white70)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text((text.length<100) ?text:'${text.substring(0,100)} ...'),
    ),
        ));
  }
}

