import 'package:admin_app/features/chat/presentation/cubits/admin_chat_cubit/admin_chat_cubit.dart';
import 'package:admin_app/features/chat/presentation/view/admin_inbox_screen.dart';
import 'package:admin_app/features/dashboard/presentation/dashboard_cubit/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../products/presentation/view/product_list_screen.dart';
import '../../../orders/presentation/view/order_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Widget> _screens = const [
    ProductListScreen(),
    OrderListScreen(),
    AdminInboxScreen(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<AdminChatCubit>().getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final isDarkMode =
            state.themeMode == ThemeMode.dark ||
            (state.themeMode == ThemeMode.system &&
                Theme.of(context).brightness == Brightness.dark);

        return Scaffold(
          appBar: AppBar(
            leadingWidth: 0,
            leading: const SizedBox.shrink(),
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Iconsax.box_1,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kite Admin',
                      style: Theme.of(context).appBarTheme.titleTextStyle,
                    ),
                    Text(
                      'Admin Panel',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDarkMode ? Iconsax.sun_1_copy : Iconsax.moon_copy,
                  color: Theme.of(context).iconTheme.color,
                ),
                onPressed: () {
                  context.read<DashboardCubit>().toggleTheme(isDarkMode);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          body: IndexedStack(index: state.tabIndex, children: _screens),

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.tabIndex,
            onTap: (index) {
              context.read<DashboardCubit>().changeTab(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Iconsax.box_copy),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.shopping_cart_copy),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: BlocBuilder<AdminChatCubit, AdminChatState>(
                  builder: (context, chatState) {
                    int totalUnread = 0;
                    if (chatState is AdminChatLoaded) {
                      for (var user in chatState.users) {
                        totalUnread += (user['unreadCount'] as int? ?? 0);
                      }
                    }
                    return Badge(
                      isLabelVisible: totalUnread > 0,
                      label: Text('$totalUnread'),
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      child: const Icon(Iconsax.message_text_1_copy),
                    );
                  },
                ),
                label: 'Support',
              ),
            ],
          ),
        );
      },
    );
  }
}
