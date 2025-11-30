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
    const String _fontFamily = 'Montserrat';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Orders",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        leading: IconButton(
          onPressed: () {
            AppRouter.router.go(AppRouter.kProfile);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: Theme.of(context).cardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "🏷 My Orders",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Expanded(
                  child: StreamBuilder<List<MyOrder>>(
                    stream: checkoutCubit.getUserOrdersStream(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "No Orders Yet",
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }

                      final orders = snapshot.data!;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          final date = order.date.toDate();
                          final products = order.products;

                          return Column(
                            children: [
                              const SizedBox(height: 8),
                              InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  AppRouter.router.push(
                                    AppRouter.kOrderDetails,
                                    extra: order,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 2),
                                        color: Colors.black.withOpacity(0.05),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // delete button
                                      (order.status == Status.processing ||
                                              order.status == Status.pending)
                                          ? IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            20,
                                                          ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                                  color: Color(
                                                                    0xFFFAE3E3,
                                                                  ),
                                                                  shape:
                                                                      BoxShape
                                                                          .circle,
                                                                ),
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  15,
                                                                ),
                                                            child: const Icon(
                                                              Icons
                                                                  .delete_forever,
                                                              size: 45,
                                                              color:
                                                                  Colors
                                                                      .redAccent,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),

                                                          Text(
                                                            "Delete Order",
                                                            style:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .displayMedium,
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            "Are you sure you want to delete your order?",
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                            style:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .textTheme
                                                                    .titleMedium,
                                                          ),
                                                          const SizedBox(
                                                            height: 25,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: TextButton(
                                                                  onPressed:
                                                                      () => Navigator.pop(
                                                                        context,
                                                                      ),
                                                                  child: Text(
                                                                    "Cancel",
                                                                    style:
                                                                        Theme.of(
                                                                          context,
                                                                        ).textTheme.titleSmall,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red,
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.pop(
                                                                      context,
                                                                    );
                                                                    checkoutCubit
                                                                        .updateOrderStatus(
                                                                          order
                                                                              .id,
                                                                          Status
                                                                              .canceled,
                                                                        );
                                                                  },
                                                                  child: Text(
                                                                    "Delete",
                                                                    style: TextStyle(
                                                                      fontFamily:
                                                                          _fontFamily,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.delete_forever,
                                              color: Colors.redAccent,
                                            ),
                                          )
                                          : const SizedBox(),

                                      const SizedBox(width: 8),

                                      // main details
                                      Expanded(
                                        child: buildOrderItem(
                                          context: context,
                                          id: order.id,
                                          date:
                                              "${DateFormat('yyyy-MM-dd').format(date)} • ${products.length} items",
                                          price:
                                              "\$${order.totalPrice.toStringAsFixed(2)}",
                                          status:
                                              order.status
                                                  .toString()
                                                  .split('.')
                                                  .last,
                                          color:
                                              order.status == Status.delivered
                                                  ? const Color(0xFF087248)
                                                  : order.status ==
                                                      Status.shipped
                                                  ? Colors.blue
                                                  : order.status ==
                                                      Status.processing
                                                  ? Colors.orange
                                                  : order.status ==
                                                      Status.pending
                                                  ? Colors.grey
                                                  : order.status ==
                                                      Status.canceled
                                                  ? Colors.red
                                                  : Colors.purple,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
