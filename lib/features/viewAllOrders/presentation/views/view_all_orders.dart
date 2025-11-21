import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/models/order.dart';
import '../../../../core/utils/app_router.dart';
import '../../../checkout/presentation/manager/checkout_cubit.dart';
import '../../../profile/presentation/widgets/order_item.dart';
import 'package:intl/intl.dart';

class ViewAllOrders extends StatelessWidget {
  const ViewAllOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutCubit = context.read<CheckoutCubit>();

    return Scaffold(
      appBar: AppBar(
          title:  Text("All Orders",style: Theme.of(context).textTheme.displayMedium,),
      leading:IconButton(onPressed: (){
        AppRouter.router.go(AppRouter.kProfile);
      }, icon: Icon(Icons.arrow_back)) ,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("🏷 My Orders",style: Theme.of(context).textTheme.headlineMedium,),
                Expanded(
                  child: StreamBuilder<List<MyOrder>>(
                    stream: checkoutCubit.getUserOrdersStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("No Orders Yet"),
                        );
                      }

                      final orders = snapshot.data!;

                      return ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          final date = order.date.toDate();
                          final products = order.products;
                          print(products);

                          return InkWell(
                            onTap: () {
                              AppRouter.router.push(
                                AppRouter.kOrderDetails,
                                extra: order,
                              );
                            },
                            child: Column(
                              children: [
                                Divider(),
                                buildOrderItem(
                                  context: context,
                                  id: order.id,
                                  date:
                                  "${DateFormat('yyyy-MM-dd').format(date)} • ${products.length} items",
                                  price: "\$${order.totalPrice.toStringAsFixed(2)}",
                                  status: order.status.toString().split('.').last,
                                  color: order.status == Status.delivered
                                      ? const Color(0xFF087248)
                                      : order.status == Status.shipped
                                      ? Colors.blue
                                      : order.status == Status.processing
                                      ? Colors.orange
                                      : Colors.purple,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
