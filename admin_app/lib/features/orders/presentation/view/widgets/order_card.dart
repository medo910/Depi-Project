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
<<<<<<< HEAD
=======
    final size = MediaQuery.sizeOf(context);

>>>>>>> temp-fix
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
<<<<<<< HEAD
          padding: const EdgeInsets.all(12.0),
=======
          padding: EdgeInsets.all(size.width * 0.03),
>>>>>>> temp-fix
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
<<<<<<< HEAD
                  Text(
                    order.id,
                    style: textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
=======
                  Expanded(
                    child: Text(
                      order.id,
                      style: textTheme.titleSmall?.copyWith(
                        fontSize: size.width * 0.035,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
>>>>>>> temp-fix
                  ),
                  OrderStatusBadge(status: order.status),
                ],
              ),
<<<<<<< HEAD
              const SizedBox(height: 4),
              Text(
                dateFormatter.format(order.date.toDate()),
                style: textTheme.bodySmall,
              ),
              const Divider(height: 20),
=======
              SizedBox(height: size.height * 0.005),
              Text(
                dateFormatter.format(order.date.toDate()),
                style: textTheme.bodySmall?.copyWith(
                  fontSize: size.width * 0.03,
                ),
              ),
              Divider(height: size.height * 0.025),

>>>>>>> temp-fix
              _buildInfoRow(
                context,
                Iconsax.user_copy,
                'Customer:',
<<<<<<< HEAD
                order.customerName ?? 'N/A',
=======
                order.customerName,
                size,
>>>>>>> temp-fix
              ),
              _buildInfoRow(
                context,
                Iconsax.call_copy,
                'Phone:',
<<<<<<< HEAD
                order.customerPhone ?? 'Not Found',
=======
                order.customerPhone,
                size,
>>>>>>> temp-fix
                isLtr: true,
              ),
              _buildInfoRow(
                context,
                Iconsax.location_copy,
                'Address:',
<<<<<<< HEAD
                order.customerAddress ?? 'N/A',
=======
                order.customerAddress,
                size,
>>>>>>> temp-fix
              ),
              _buildInfoRow(
                context,
                Iconsax.money_recive_copy,
                'Total:',
                currencyFormatter.format(order.totalPrice),
<<<<<<< HEAD
                isPrimary: true,
              ),

              const SizedBox(height: 12),
              _buildActionButtons(context),
=======
                size,
                isPrimary: true,
              ),

              SizedBox(height: size.height * 0.015),
              _buildActionButtons(context, size),
>>>>>>> temp-fix
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
<<<<<<< HEAD
    String value, {
=======
    String value,
    Size size, {
>>>>>>> temp-fix
    bool isLtr = false,
    bool isPrimary = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
<<<<<<< HEAD
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: textTheme.bodySmall?.color),
          const SizedBox(width: 6),
          Text(label, style: textTheme.bodySmall),
=======
      padding: EdgeInsets.only(bottom: size.height * 0.008),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: size.width * 0.035,
            color: textTheme.bodySmall?.color,
          ),
          SizedBox(width: size.width * 0.015),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(fontSize: size.width * 0.032),
          ),
>>>>>>> temp-fix
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
<<<<<<< HEAD
=======
                fontSize: size.width * 0.035,
>>>>>>> temp-fix
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

<<<<<<< HEAD
  Widget _buildActionButtons(BuildContext context) {
=======
  Widget _buildActionButtons(BuildContext context, Size size) {
>>>>>>> temp-fix
    final cubit = context.read<OrderCubit>();
    List<Widget> buttons = [];

    switch (order.status) {
      case OrderStatus.pending:
        buttons.add(
          _buildButton(
            context,
            'Start Processing',
            () => cubit.updateOrderStatus(order.id, OrderStatus.processing),
<<<<<<< HEAD
=======
            size,
>>>>>>> temp-fix
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
<<<<<<< HEAD
=======
            size,
>>>>>>> temp-fix
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
<<<<<<< HEAD
=======
            size,
>>>>>>> temp-fix
            isPrimary: true,
          ),
        );
        break;
<<<<<<< HEAD
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
=======
      default:
        break;
    }

    if (order.status != OrderStatus.delivered &&
        order.status != OrderStatus.canceled) {
      if (buttons.isNotEmpty) {
        buttons.add(SizedBox(width: size.width * 0.025));
>>>>>>> temp-fix
      }
      buttons.add(
        _buildButton(
          context,
          'Cancel Order',
          () => cubit.updateOrderStatus(order.id, OrderStatus.canceled),
<<<<<<< HEAD
=======
          size,
>>>>>>> temp-fix
          isPrimary: false,
        ),
      );
    }

    return Row(children: buttons);
  }

  Widget _buildButton(
    BuildContext context,
    String label,
<<<<<<< HEAD
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
=======
    VoidCallback onPressed,
    Size size, {
    bool isPrimary = true,
  }) {
    return Expanded(
      child: SizedBox(
        height: size.height * 0.05,
        child:
            isPrimary
                ? ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    label,
                    style: TextStyle(fontSize: size.width * 0.032),
                  ),
                )
                : OutlinedButton(
                  onPressed: onPressed,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withOpacity(0.4),
                    ),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(fontSize: size.width * 0.032),
                  ),
                ),
      ),
>>>>>>> temp-fix
    );
  }
}
