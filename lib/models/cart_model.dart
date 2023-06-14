import 'package:flutter/material.dart';
import 'package:toptanci_otomasyon/models/product.dart';

class CartModel extends ChangeNotifier{
  List<Tuple> cart=[];
  void addProduct(Product product){
    for(Tuple tuple in cart){
      if(tuple.product.id==product.id){
        tuple.quantity++;
        notifyListeners();
        return;
      }
    }
    cart.add(Tuple(product, 1));
    notifyListeners();
  }

  void removeProduct(Product product) {
    for (Tuple tuple in cart) {
      if (tuple.product.id == product.id ) {
        cart.remove(tuple);
        break;
      }
    }
    notifyListeners();
  }
  void incQuantity(Product product) {
    for (Tuple tuple in cart) {
      if (tuple.product.id == product.id) {
        tuple.quantity++;
        notifyListeners();
        return;
      }
    }
  }
  void decQuantity(Product product) {
    for (Tuple tuple in cart) {
      if (tuple.product.id == product.id ) {
        tuple.quantity--;
        notifyListeners();
        return;
      }
    }
  }
  int howManyInCart(Product product) {
    int sum = 0;
    for (Tuple tuple in cart) {
      if (tuple.product.id == product.id) {
        sum += tuple.quantity;
      }
    }
    return sum;
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }/*
  double howMuchInCart(){
    double sum = 0;
    for (var element in cart) {
      sum += (element.quantity * element.product.price);
    }
    notifyListeners();
    return sum;
  }*/
}

class Tuple {

  final Product product;
  int quantity;
  Tuple(this.product, this.quantity);
}
