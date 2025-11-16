import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/order.dart';
import 'package:depi_app/core/models/selectedProduct.dart';

class MyUser {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final List<String> address;
  final List<String> favorite;
  final List<ProductSelected> cart;
  final Timestamp date;
  final List<MyOrder> ordersId;

  MyUser({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.address = const [],
    this.favorite = const [],
    this.cart = const [],
    required this.date,
    this.ordersId = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'address': address,
      'favorite': favorite,
      'cart': cart.map((x) => x.toMap()).toList(),
      'date': date,
      'ordersId': ordersId.map((x) => x.toMap()).toList(),
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String?,
      address: map['address'] != null ? List<String>.from(map['address']) : [],
      favorite: map['favorite'] != null ? List<String>.from(map['favorite']) : [],
      cart: map['cart'] != null
          ? List<ProductSelected>.from(
              (map['cart'] as List).map((x) => ProductSelected.fromMap(x as Map<String, dynamic>)))
          : [],
      date: map['date'] as Timestamp? ?? Timestamp.now(),
      ordersId: map['ordersId'] != null
          ? List<MyOrder>.from(
              (map['ordersId'] as List).map((x) => MyOrder.fromMap(x as Map<String, dynamic>)))
          : [],
    );
  }
}
