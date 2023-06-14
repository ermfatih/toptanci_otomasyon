import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toptanci_otomasyon/core/locator.dart';
import 'package:toptanci_otomasyon/models/cart_model.dart';
import 'package:toptanci_otomasyon/models/order.dart';
import 'package:toptanci_otomasyon/view_models/payment_view_model.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, required this.cart, required this.tutar}) : super(key: key);
  final List<Tuple> cart;
  final double tutar;
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController noteController=TextEditingController();
  bool _kapidaOdeme = true;
  bool _withBank = false;
  String _selectedItem = '';
  final List<String> _mounthItems = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var model = getIt<PaymentViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text('Ödeme Ekranı')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text('Adres',style: TextStyle(fontSize: 18)),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white54,width: 0.5)
              ),
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(7),
                height: height / 15,
                width: width,
                //color: Colors.transparent,
                child: Center(
                  child: FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
                    builder: (context, snapshot) {
                      return Text(snapshot.data?['address'] ?? '', maxLines: 3);
                    }
                  ),
                )),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child:  Text('Sipariş Notu',style: TextStyle(fontSize: 18),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 8,left: 8,right: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white54,width: 0.5)
                ),
                //color: Colors.grey,
                height: 100,
                width: 400,
                child: TextField(
                  maxLines: 5,

                  controller: noteController,
                  decoration: InputDecoration.collapsed(
                    //border: OutlineInputBorder(gapPadding: 5,borderRadius: BorderRadius.circular(12)),
                    //filled: true,

                    hintText: '   Siparis notunuz varsa giriniz',
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8,top: 8),
              child:  Text('Ürünler',style: TextStyle(fontSize: 18),),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 27),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                Text('Adet'),
                SizedBox(width: 15,),
                Text('Fiyat'),
              ]),
            ),
            Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.white54),
                borderRadius: BorderRadius.circular(12)
              ),
              height: height/5,
              child: ListView.builder(
                itemCount: widget.cart.length,
                itemBuilder: (context, index) {
                  var sum=widget.cart[index].product.price*widget.cart[index].quantity;
                  return Card(
                    child: ListTile(
                      title: Text(widget.cart[index].product.name),
                      trailing: SizedBox(
                        width: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(widget.cart[index].quantity.toString()),
                            SizedBox(width: 20,),
                            Text(sum.toString()+' ₺',style: TextStyle(fontSize: 13),)
                          ],
                        ),
                      ),
                      leading:(widget.cart[index].product.photoUrl==null ||widget.cart[index].product.photoUrl!.isEmpty )?Icon(Icons.add_alert): Image.network(widget.cart[index].product.photoUrl!),
                    ),
                  );
              },),
            ),
            Container(
              child: Column(
                children: [

                  CheckboxListTile(
                    selected: _kapidaOdeme,
                    activeColor: Colors.green,
                    secondary: Icon(Icons.money),
                    checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    checkColor: Colors.transparent,
                    side: BorderSide(color: Colors.grey),
                    title: Text('Nakit Ödeme'),
                    value: _kapidaOdeme,
                    onChanged: (value) {
                      setState(() {
                        _kapidaOdeme = value!;
                        _withBank = false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    checkColor: Colors.transparent,
                    selected: _withBank,
                    secondary: Icon(Icons.food_bank_outlined),
                    activeColor: Colors.green,
                    title: Text('Kart İle öde'),
                    subtitle: Text('coming soon...'),
                    value: _withBank,
                    onChanged: (value) {
                      setState(() {
                        _withBank = value!;
                        _kapidaOdeme = false;
                      });
                    },
                  ),
                  _kapidaOdeme
                      ? SizedBox.shrink()
                      : Container(
                          margin: EdgeInsets.all(40),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 13, right: 13, bottom: 13, top: 0),
                                child: SizedBox(
                                  height: 60,
                                  child: TextField(
                                      decoration: InputDecoration(
                                          labelText: 'Kart Numarası',
                                          border: OutlineInputBorder())),
                                  width: 385,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 13, right: 13, bottom: 13, top: 0),
                                child: SizedBox(
                                  height: 60,
                                  child: TextField(
                                      decoration: InputDecoration(
                                          labelText: 'Ad soyad',
                                          border: OutlineInputBorder())),
                                  width: 385,
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 13,
                                        right: 13,
                                        bottom: 13,
                                        top: 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              color: Colors.white30)),
                                      width: 80,
                                      height: 55,
                                      child: DropdownButton(
                                        menuMaxHeight: 150,
                                        isDense: true,
                                        icon: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(_selectedItem.isEmpty
                                                ? 'MM'
                                                : _selectedItem),
                                            Icon(
                                              Icons.navigate_next,
                                              size: 24,
                                            )
                                          ],
                                        ),
                                        dropdownColor: Colors.indigo,
                                        isExpanded: true,
                                        iconSize: 40,
                                        items: _mounthItems.map((String value) {
                                          return DropdownMenuItem(
                                              alignment: Alignment.center,
                                              value: value,
                                              child: Text(value));
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedItem = value.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 13,
                                        right: 13,
                                        bottom: 13,
                                        top: 0),
                                    child: SizedBox(
                                      height: 55,
                                      child: TextField(
                                          decoration: InputDecoration(
                                              labelText: 'YY',
                                              border: OutlineInputBorder())),
                                      width: 100,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: width / 120,
                                        right: 0,
                                        bottom: 13,
                                        top: 0),
                                    child: SizedBox(
                                      height: 55,
                                      child: TextField(
                                          decoration: InputDecoration(
                                              labelText: 'CVC',
                                              border: OutlineInputBorder())),
                                      width: 73,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            //Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Sipariş Tutarı  ₺ ${widget.tutar.toString()}'),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(120, 40),
                    primary: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )
                  ),
                    onPressed: () {
                      if(widget.tutar >= 500 ){
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.spaceEvenly,
                            title: Text('Siparişinizi onaylıyor musunuz?'),
                            actions: [
                              Consumer<CartModel>(builder: (context, value, child) => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo
                                ),
                                  onPressed: () async{
                                await model.addOrder(
                                    Orders(
                                        orderNote: noteController.text,
                                        siparisTutari: widget.tutar, dateTime: DateTime.now(), userId: FirebaseAuth.instance.currentUser!.uid,isComplete: 0),widget.cart);
                                //model.updateOrders(widget.cart.first.product,FirebaseAuth.instance.currentUser!.uid);
                                value.clearCart();
                                if(!mounted)return;
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }, child: Text('Tamam')),),
                              ElevatedButton(style: ElevatedButton.styleFrom(primary: Colors.indigo),
                                  onPressed: () {
                            Navigator.pop(context);
                              }, child: Text('İptal'))
                            ],
                          );
                        },);
                      }else{
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            content: Text('Minimum sipariş tutarı 500 tl olmalı'),
                          );
                        },);
                      }
                    },
                    child: Text('Sipariş Ver')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

