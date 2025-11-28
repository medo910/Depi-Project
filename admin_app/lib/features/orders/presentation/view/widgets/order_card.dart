import 'package:admin_app/features/orders/domain/models/my_order_model.dart';
import 'package:admin_app/features/orders/presentation/order_cubit/order_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'order_status_badge.dart';
import 'order_details_sheet.dart';

class OrderCard extends StatelessWidget {
  final MyOrder order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: 'EGP ',
    );
    final dateFormatter = DateFormat('yyyy/MM/dd - hh:mm a');

    return Card(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (ctx) => OrderDetailsSheet(order: order),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.id,
                    style: textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  OrderStatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                dateFormatter.format(order.date.toDate()),
                style: textTheme.bodySmall,
              ),
              const Divider(height: 20),
              _buildInfoRow(
                context,
                Iconsax.user_copy,
                'Customer:',
                order.customerName ?? 'N/A',
              ),
              _buildInfoRow(
                context,
                Iconsax.call_copy,
                'Phone:',
                order.customerPhone ?? 'Not Found',
                isLtr: true,
              ),
              _buildInfoRow(
                context,
                Iconsax.location_copy,
                'Address:',
                order.customerAddress ?? 'N/A',
              ),
              _buildInfoRow(
                context,
                Iconsax.money_recive_copy,
                'Total:',
                currencyFormatter.format(order.totalPrice),
                isPrimary: true,
              ),

              const SizedBox(height: 12),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool isLtr = false,
    bool isPrimary = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: textTheme.bodySmall?.color),
          const SizedBox(width: 6),
          Text(label, style: textTheme.bodySmall),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isPrimary ? Theme.of(context).primaryColor : null,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    List<Widget> buttons = [];

    switch (order.status) {
      case OrderStatus.pending:
        buttons.add(
          _buildButton(
            context,
            'Start Processing',
            () => cubit.updateOrderStatus(order.id, OrderStatus.processing),
            isPrimary: true,
          ),
        );
        break;
      case OrderStatus.processing:
        buttons.add(
          _buildButton(
            context,
            'Mark as Shipped',
            () => cubit.updateOrderStatus(order.id, OrderStatus.shipped),
            isPrimary: true,
          ),
        );
        break;
      case OrderStatus.shipped:
        buttons.add(
          _buildButton(
            context,
            'Mark as Delivered',
            () => cubit.updateOrderStatus(order.id, OrderStatus.delivered),
            isPrimary: true,
          ),
        );
        break;
      case OrderStatus.delivered:
      case OrderStatus.canceled:
        // لا يوجد أزرار للحالات المنتهية
        return const SizedBox.shrink();
    }

    // زرار الإلغاء (متاح طول ما الأوردر مش ملغي أو متسلم)
    if (order.status != OrderStatus.delivered &&
        order.status != OrderStatus.canceled) {
      if (buttons.isNotEmpty) {
        buttons.add(const SizedBox(width: 10));
      }
      buttons.add(
        _buildButton(
          context,
          'Cancel Order',
          () => cubit.updateOrderStatus(order.id, OrderStatus.canceled),
          isPrimary: false,
        ),
      );
    }

    return Row(children: buttons);
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    VoidCallback onPressed, {
    bool isPrimary = true,
  }) {
    return Expanded(
      child:
          isPrimary
              ? ElevatedButton(onPressed: onPressed, child: Text(label))
              : OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.4),
                  ),
                ),
                child: Text(label),
              ),
    );
  }
}
