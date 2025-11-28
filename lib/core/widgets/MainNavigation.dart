import 'package:depi_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import '../../features/profile/manager/user_profile_cubit.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;
  const MainNavigation({required this.child, super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final List<String> _tabs = ['/home', '/favoriteScreen', '/cart','/profile'];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final profileCubit=context.read<UserProfileCubit>();
    final state = router.state;
    final currentPath = state.uri.path;
    final tabIndex = _tabs.indexWhere((path) => currentPath.startsWith(path));
    if (tabIndex >= 0 && tabIndex != _currentIndex) {
      _currentIndex = tabIndex;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: ConvexAppBar(
        key: ValueKey(_currentIndex),
        style: TabStyle.react,
        // backgroundColor: Theme.of(context).cardColor,
        activeColor: Colors.black,
        color: Colors.white,
        shadowColor: Colors.black26,
        elevation: 5,
        initialActiveIndex: _currentIndex,

        gradient: LinearGradient(
          colors: [Theme.of(context).hintColor, Theme.of(context).primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        items: [
          const TabItem(
            icon: Icon(Icons.home_filled,color: Colors.white),
            title: 'Home',
          ),
          TabItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.favorite, color: Colors.white),
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: StreamBuilder<int>(
                        stream: profileCubit.getUserFavoriteCountStream(),
                        builder: (context, snapshot) {
                        return Text(
                          snapshot.data?.toString() ?? "0",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    ),
                  ),
                )
              ],
            ),
            title: 'Favorites',
          ),
          TabItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart, color: Colors.white),
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: StreamBuilder<int>(
                        stream: profileCubit.getUserCartCountStream(),
                        builder: (context, snapshot) {
                        return Text(
                          snapshot.data?.toString() ?? "0",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    ),
                  ),
                )
              ],
            ),
            title: 'Cart',
          ),
          const TabItem(
              icon: Icon(Icons.person, color: Colors.white),
              title: 'Profile'
          ),
        ],

        onTap: (index) {
          if (index != _currentIndex) {
            context.go(_tabs[index]);
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
