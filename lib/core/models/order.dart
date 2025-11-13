
enum PaymentMethod {cash, visa}
enum Status {delivered,canceled,shipped,processing}

class Order{
  final String id;
  final String userId;
  final List<String> productIds;
  final double totalPrice;
  final DateTime date;
  final PaymentMethod paymentMethod;
  final Status status;
  static int orderNumber = 0;

  Order({
    required this.id,
    required this.userId,
    required this.productIds,
    required this.totalPrice,
    required this.date,
    required this.status,
    required this.paymentMethod,
  }) {
    orderNumber++;
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      productIds: List<String>.from(json['productIds']),
      totalPrice: json['totalPrice'].toDouble(),
      date: DateTime.parse(json['date']),
      status: Status.values.firstWhere(
            (e) => e.toString().split('.').last == json['status'],
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
            (e) => e.toString().split('.').last == json['paymentMethod'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productIds': productIds,
      'totalPrice': totalPrice,
      'date': date.toIso8601String(),
      'status': status.toString().split('.').last,
      'paymentMethod': paymentMethod.toString().split('.').last,
    };
  }

}