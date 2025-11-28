import 'package:admin_app/features/orders/presentation/order_cubit/order_cubit.dart';
import 'package:admin_app/features/orders/presentation/view/widgets/order_card.dart';
import 'package:admin_app/features/orders/presentation/view/widgets/order_stats_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state.status == OrderListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == OrderListStatus.failure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          }

          final filteredList = state.filteredOrders;

          return RefreshIndicator(
            onRefresh: () => context.read<OrderCubit>().fetchOrders(),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverToBoxAdapter(
                    child: OrderStatsGrid(counts: state.statusCounts),
                  ),
                ),
                if (state.selectedFilter != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: ActionChip(
                        avatar: const Icon(Iconsax.close_circle_copy, size: 16),
                        label: Text(
                          'Clear Filter (Showing ${state.selectedFilter!.name} only)',
                        ),
                        onPressed: () {
                          context.read<OrderCubit>().filterOrdersByStatus(
                            state.selectedFilter!,
                          );
                        },
                      ),
                    ),
                  ),
                if (filteredList.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        state.selectedFilter != null
                            ? 'No orders found matching this status.'
                            : 'No orders found yet.',
                      ),
                    ),
                  ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final order = filteredList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: OrderCard(order: order),
                      );
                    }, childCount: filteredList.length),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
