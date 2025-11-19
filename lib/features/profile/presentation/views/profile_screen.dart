import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/manager/app_settings_cubit.dart';
import '../../../../core/models/order.dart';
import '../../../../core/utils/app_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../../checkout/presentation/manager/checkout_cubit.dart';
import '../../manager/user_profile_cubit.dart';
import '../widgets/order_item.dart';
import '../widgets/stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String getFirstAndLastInitial(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return parts.first[0].toUpperCase() + parts.last[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    const String _fontFamily= 'Montserrat';

    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {

        if (state is UserProfileLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is UserProfileError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Failed to load user profile",
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        if (state is UserProfileLoaded) {
          final checkoutCubit = context.read<CheckoutCubit>();

          return Scaffold(
                backgroundColor:Theme.of(context).scaffoldBackgroundColor,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? const Color(0xFF272C27)
                            : const Color(0xFFC9E6CB),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               Text('Profile',
                             style: Theme.of(context).textTheme.displayMedium),
                             Icon(Icons.edit),
                            ],
                            ),

                            const SizedBox(height: 20,),

                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child: Text(
                                    getFirstAndLastInitial(state.name),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.name,
                                      style: Theme.of(context).textTheme.headlineSmall,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      state.email,
                                      style: Theme.of(context).textTheme.bodySmall
                                    ),
                                    Text(
                                      "Member since ${DateFormat('d MMMM yyyy', 'en_US').format(state.createdAt)}",
                                        style: Theme.of(context).textTheme.bodySmall
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            StreamBuilder<int>(
                              stream: checkoutCubit.getUserOrdersCountStream(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return buildStatCard(context, "0", "Orders");
                                return buildStatCard(context, snapshot.data.toString(), "Orders");
                              },
                            ),
                            buildStatCard(context, (state.favorite ?? []).length.toString(), "Favorites"),
                            buildStatCard(context, (state.cart ?? []).length.toString(), "In Cart"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          color:Theme.of(context).cardColor,
                          elevation: 0.5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children:  [
                                        Icon(Icons.shopping_bag_outlined),
                                        SizedBox(width: 5),
                                        Text("My Orders",
                                            style: Theme.of(context).textTheme.headlineSmall)
                                      ],
                                    ),
                                    InkWell(
                                      child: Row(
                                        children:  [
                                          Text("View All",
                                              style: Theme.of(context).textTheme.titleMedium),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 10,
                                          )
                                        ],
                                      ),
                                      onTap: (){},
                                    )
                                  ],
                                ),

                                StreamBuilder<List<MyOrder>>(
                                  stream: context.read<CheckoutCubit>().getUserOrdersStream(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: Text("No Orders Yet"));
                                    }

                                    final orders = snapshot.data!;

                                    if (orders.isEmpty) {
                                      return const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Text("No Orders Yet"),
                                        ),
                                      );
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: orders.length,
                                      itemBuilder: (context, index) {
                                        final order = orders[index];
                                        final date = order.date.toDate();
                                        final products = order.productIds;

                                        return Column(
                                          children: [
                                            const Divider(),
                                            buildOrderItem(
                                              context: context,
                                              id: order.id,
                                              date: "${DateFormat('yyyy-MM-dd').format(date)} • ${products.length} items",
                                              price: "\$${order.totalPrice.toStringAsFixed(2)}",
                                              status: order.status.toString().split('.').last,
                                              color: order.status == Status.delivered
                                                  ? Color(0xFF087248)
                                                  : order.status == Status.shipped
                                                  ? Colors.blue
                                                  : order.status == Status.processing
                                                  ? Colors.orange
                                                  : Colors.purple,
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),

                                // buildOrderItem(
                                //   context: context,
                                //   id: "#KT12345678",
                                //   date: "2024-01-15 • 2 items",
                                //   price: "\$89.99",
                                //   status: "Delivered",
                                //   color: Color(0xFF087248),
                                // ),
                                //
                                // const Divider(),
                                //
                                // buildOrderItem(
                                //   context: context,
                                //   id: "#KT87654321",
                                //   date: "2024-01-10 • 1 item",
                                //   price: "\$159.5",
                                //   status: "Shipped",
                                //   color: Colors.blue,
                                // ),
                                //
                                // const Divider(),
                                //
                                // buildOrderItem(
                                //   context: context,
                                //   id: "#KT11223344",
                                //   date: "2024-01-05 • 3 items",
                                //   price: "\$249.99",
                                //   status: "Processing",
                                //   color: Colors.orange,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Card(
                          color:Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            children: [
                               ListTile(
                                leading: Icon(Icons.settings_outlined),
                                title: Text("Settings",
                                    style: Theme.of(context).textTheme.headlineSmall),
                              ),

                              const Divider(),

                              ListTile(
                                leading: const Icon(Icons.language),
                                title:  Text("Language",
                                    style: Theme.of(context).textTheme.headlineSmall),
                                subtitle: const Text("English"),
                                trailing: InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? const Color(0xFF2D2D2D)
                                          : const Color(0xFFD6EFD8),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      "عر",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ),

                              const Divider(),

                              ListTile(
                                leading:
                                const Icon(Icons.dark_mode_outlined),
                                title:  Text("Dark Mode",
                                    style: Theme.of(context).textTheme.headlineSmall),
                                subtitle:
                                 Text("Toggle dark theme",style: Theme.of(context).textTheme.bodyMedium),
                                trailing: Transform.scale(
                                  scale: 0.7,
                                  child: Switch(
                                    value:  context.watch<AppSettingsCubit>().state.isDarkMode,
                                      onChanged: (value) {
                                        context.read<AppSettingsCubit>().toggleDarkMode(value);
                                      }

                                  ),
                                ),
                              ),

                              const Divider(),

                               ListTile(
                                leading: Icon(Icons.history),
                                title: Text("Order History",
                                    style: Theme.of(context).textTheme.headlineSmall),
                                subtitle:
                                Text("View all your past orders",style: Theme.of(context).textTheme.bodyMedium),
                                trailing: Icon(Icons.chevron_right),
                              ),

                              const Divider(),

                              ListTile(
                                leading: const Icon(Icons.star_border),
                                title:  Text("My Reviews",
                                    style: Theme.of(context).textTheme.headlineSmall),
                                subtitle:  Text(
                                    "Manage your ratings and reviews",style: Theme.of(context).textTheme.bodyMedium),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: (){
                                  AppRouter.router.push(AppRouter.kCart);
                                },
                              ),

                              const Divider(),

                              InkWell(
                                child:  ListTile(
                                  leading: Icon(Icons.support_agent),
                                  title: Text("Customer Support",
                                      style: Theme.of(context).textTheme.headlineSmall),
                                  subtitle: Text(
                                      "Contact our support team",style: Theme.of(context).textTheme.bodyMedium),
                                  trailing: Icon(Icons.chevron_right),
                                ),
                                onTap: () {
                                  AppRouter.router
                                      .go(AppRouter.kCustomerSupport);
                                },
                              ),

                              const Divider(),

                               ListTile(
                                leading: Icon(Icons.help_outline),
                                title: Text("Help & Support",
                                    style: Theme.of(context).textTheme.headlineSmall),
                                subtitle:
                                Text("FAQs and general assistance",style: Theme.of(context).textTheme.bodyMedium),
                                trailing: Icon(Icons.chevron_right),
                              ),

                              const Divider(),

                              ListTile(
                                    leading: const Icon(
                                        Icons.notifications_none),
                                    title:  Text("Notifications",
                                        style: Theme.of(context).textTheme.headlineSmall),
                                    subtitle: Text("Get updates about your orders",style: Theme.of(context).textTheme.bodyMedium),
                                    trailing: Transform.scale(
                                      scale: 0.7,
                                      child: Switch(
                                        value: true,
                                        onChanged: (v) {},
                                      ),
                                    ),
                                  ),

                              const Divider(),

                              ListTile(
                                leading: const Icon(Icons.logout,
                                    color: Colors.red),
                                title: const Text(
                                  "Logout",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFFAE3E3),
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: const EdgeInsets.all(15),
                                                child: const Icon(
                                                    Icons.logout,
                                                    size: 45,
                                                    color: Colors.red),
                                              ),
                                              const SizedBox(height: 20),
                                               Text("Logout",
                                                 style: Theme.of(context).textTheme.displayMedium,),
                                              const SizedBox(height: 10),
                                               Text(
                                                "Are you sure you want to logout?",
                                                textAlign: TextAlign.center,
                                                style:  Theme.of(context).textTheme.titleMedium,
                                              ),
                                              const SizedBox(height: 25),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child:  Text(
                                                            "Cancel",
                                                            style:  Theme.of(context).textTheme.titleSmall,)),
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.red),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        AppRouter.router.go(AppRouter.kLogin);
                                                      },
                                                      child:  Text("Logout",style:  TextStyle(fontFamily: _fontFamily,color: Colors.white,fontWeight: FontWeight.w600),),
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
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              );
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Something went wrong.\nPlease try again.",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<UserProfileCubit>().loadUserProfile();
                  },
                  child:  Text("Reload",style: Theme.of(context).textTheme.labelLarge,),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}




