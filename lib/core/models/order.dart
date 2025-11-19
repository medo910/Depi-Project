import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/selectedProduct.dart';

enum PaymentMethod { cash, visa }

enum Status { delivered, canceled, shipped, processing }

class MyOrder {
  final String id;
  final String userId;
  final List<ProductSelected> productIds;
  final double totalPrice;
  final Timestamp date;
  final PaymentMethod paymentMethod;
  final Status status;
  final List<String> address;

  static int orderNumber = 0;

  MyOrder({
    required this.id,
    required this.userId,
    required this.productIds,
    required this.totalPrice,
    required this.date,
    required this.status,
    required this.paymentMethod,
    required this.address,
  }) {
    orderNumber++;
  }

  factory MyOrder.fromMap(Map<String, dynamic> map, {required String id}) {
    return MyOrder(
      id: id,
      userId: map['userId'],
      productIds: map['productIds'] != null
          ? List<ProductSelected>.from(
        map['productIds'].map((e) => ProductSelected.fromMap(e)),
      )
          : [],
      totalPrice: (map['totalPrice'] as num).toDouble(),
      date: map['date'] ?? Timestamp.now(),
      status: Status.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => Status.processing,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
            (e) => e.name == map['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      address: map['address'] != null
          ? List<String>.from(map['address'])
          : [],
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productIds': productIds.map((e) => e.toMap()).toList(),
      'totalPrice': totalPrice,
      'date': date,
      'status': status.toString().split('.').last,
      'paymentMethod': paymentMethod.toString().split('.').last,
      'address': address,
    };
  }

}
