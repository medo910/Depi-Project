import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/order.dart';


class OrderDetailsScreen extends StatelessWidget {
  final MyOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final products = order.products;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Order Details",style: Theme.of(context).textTheme.headlineLarge,),
      ),
      body: ListView.builder(
        itemCount: products.length + 1,
        itemBuilder: (context, index) {
          if (index < products.length) {
            final p = products[index];
            return Card(
              color: Theme.of(context).cardColor,
              child: ListTile(
                leading: Image.network(p.photoURL, width: 50, height: 50),
                title: Text(p.name),
                subtitle: Text("Qty: ${p.productDetails['quantity']}"),
                trailing: Text("\$${p.price.toStringAsFixed(2)}"),
              ),
            );
          } else {

            final formattedDate = DateFormat('d MMM yyyy').format(order.date.toDate());
            return Card(
              color: Theme.of(context).cardColor,
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order Summary" ,style: Theme.of(context).textTheme.headlineLarge,),
                    Divider(),
                    Text(
                      "💰 Total: \$${order.totalPrice.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Divider(),
                    const SizedBox(height: 8),
                    Text(
                      "💳 Payment Method: ${order.paymentMethodFriendly}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Divider(),
                    const SizedBox(height: 8),
                    Text(
                      "📅 Date: $formattedDate",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Divider(),

                    Text(
                      "👤 Full Name: ${order.address[0]}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Divider(),
                    Text(
                      "📞 Phone Number: ${order.address[1]}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Divider(),
                    Text(
                      "📍 Address: ${order.address[2]}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Divider(),
                    Text(
                      "🏙️ City: ${order.address[3]}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),

    );
  }
}
