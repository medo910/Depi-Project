import 'package:depi_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class MainNavigation extends StatefulWidget {
  final Widget child;
  const MainNavigation({required this.child, super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final List<String> _tabs = ['/home', '/favoriteScreen'];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final state = router.state;
    final currentPath = state.uri.path;
    final tabIndex = _tabs.indexWhere((path) => currentPath.startsWith(path));
    if (tabIndex >= 0 && tabIndex != _currentIndex) {
      _currentIndex = tabIndex;
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        backgroundColor: Colors.white,
        activeColor: AppColors.accent,
        color: Colors.white,
        shadowColor: Colors.black26,
        elevation: 5,
        initialActiveIndex: _currentIndex,

        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        items: const [
          TabItem(icon: Icons.home_filled, title: 'Home'),
          TabItem(icon: Icons.favorite, title: 'Favorites'),
        ],
        // cornerRadius: 16,
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
