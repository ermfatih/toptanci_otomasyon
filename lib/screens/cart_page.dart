import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptanci_otomasyon/models/cart_model.dart';
import 'package:toptanci_otomasyon/screens/payment_page.dart';
import 'package:toptanci_otomasyon/widgets/twice_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController dateController=TextEditingController();
  TextEditingController noteController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Sepetim'),
            actions: [
              Consumer<CartModel>(builder: (context, value, child) {
                var cartItems = value.cart;
                return cartItems.isNotEmpty ?IconButton(onPressed: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(title: Text('sepeti silmek istediğinize emin misiniz'),
                    actions: [
                      ElevatedButton(onPressed: () {
                        value.clearCart();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }, child: Text('Evet')
                      ),
                      ElevatedButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text('Hayır'))
                    ],
                  );
                },);

              }, icon:const Icon(Icons.delete)):SizedBox.shrink();}
              )
            ],
          ),
          body:Column(
            children: [
              Expanded(
                child: Consumer<CartModel>(
                  builder: (context, value, child) {
                    return ListView.builder(
                      itemCount: value.cart.length,
                      itemBuilder: (context, index) {
                        var sum=value.cart[index].product.price*value.cart[index].quantity;
                        return Card(
                          child: ListTile(
                            title: Text(value.cart[index].product.name),
                            leading:( value.cart[index].product.photoUrl==null|| value.cart[index].product.photoUrl!.isEmpty)?Icon(Icons.add, size: 50,):Image.network(value.cart[index].product.photoUrl!),
                            subtitle: Text(sum.toString()),
                            trailing: Padding(
                              padding: const EdgeInsets.only(),
                              child: Container(
                                width: 180,
                                padding: EdgeInsets.zero,
                                child: TwiceWidget(
                                  onPressedA: () {
                                    value.incQuantity(value.cart[index].product);
                                  },
                                  text: value.howManyInCart(value.cart[index].product)
                                      .toString(),
                                  onPressedB: () {
                                    value.decQuantity(value.cart[index].product);
                                    if(value.howManyInCart(value.cart[index].product)<1){
                                      value.removeProduct(value.cart[index].product);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },);
                  },
                ),
              ),

              Consumer<CartModel>(builder: (context, cart, child) {
                List<Tuple> list=cart.cart;
                double sum = 0;
                for (var element in list) {
                  sum += (element.quantity * element.product.price);
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: cart.cart.isEmpty ? SizedBox.shrink(): Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('₺ ${sum.toString()}',style: TextStyle(fontSize: 25,color: Colors.white70)),
                      ElevatedButton(style: ElevatedButton.styleFrom(
                        primary: Colors.indigo,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        minimumSize: Size(100, 50)
                      ),onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(cart: list,tutar: sum),));
                      }, child: Text('Ödemeye Geçin')),
                    ],
                  ),
                );
              },)
            ],
          ),
        );
  }
}


