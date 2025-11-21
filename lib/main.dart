// import 'package:depi_app/core/utils/app_router.dart';
// import 'package:depi_app/core/utils/auth_service.dart';
// import 'package:depi_app/features/auth/data/repos/auth_repository_impl.dart';
// import 'package:depi_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
// import 'package:depi_app/features/profile/presentation/views/profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'firebase_options.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const DepiApp());
// }
//
// class DepiApp extends StatelessWidget {
//   const DepiApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => AuthCubit(AuthRepositoryImpl(AuthService())),
//         ),
//       ],
//       child: MaterialApp.router(
//         routerConfig: AppRouter.router,
//         debugShowCheckedModeBanner: false,
//         title: 'Kite Shopping',
//         theme: ThemeData(primarySwatch: Colors.green),
//       ),
//
//
//     );
//   }
//
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       home: ProfileScreen(),
//     );
//   }
// }
//


import 'package:depi_app/core/cubit/FavoritesCubit/favorites_cubit.dart';
import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/utils/auth_service.dart';
import 'package:depi_app/features/auth/data/repos/auth_repository_impl.dart';
import 'package:depi_app/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:depi_app/features/checkout/presentation/manager/checkout_cubit.dart';
import 'package:depi_app/features/checkout/presentation/views/checkout_screen.dart';
import 'package:depi_app/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/manager/app_settings_cubit.dart';
import 'core/manager/app_settings_state.dart';
import 'core/theme/app_theme.dart';
import 'features/cart/presentation/manager/cart_cubit.dart';
import 'features/profile/manager/profile_cubit.dart';
import 'features/profile/manager/user_profile_cubit.dart';
import 'features/profile/presentation/views/profile_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const DepiApp());
}

class DepiApp extends StatelessWidget {
  const DepiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(AuthRepositoryImpl(AuthService())),),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(
          create: (context) => UserProfileCubit()..loadUserProfile(),
          child: ProfileScreen(),
        ),
        BlocProvider(create: (_) => AppSettingsCubit()),
        BlocProvider(create: (_)=> CartCubit()..loadCart()),
        BlocProvider(
          create: (context) => CheckoutCubit(
            cartCubit: context.read<CartCubit>(),
          ),
        ),
        BlocProvider<FavoritesCubit>(
          create: (context) {
            final user = FirebaseAuth.instance.currentUser;
            return FavoritesCubit(user!.uid)..loadFavorites();
          },
        ),

      ],
      child:BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            title: 'Kite Shopping',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppSettingsCubit(),
        ),
        BlocProvider(
          create: (_) => CartCubit()..loadCart(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (context) {
            return FavoritesCubit()..loadFavorites();
          },
        ),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const CheckoutScreen(),
          );
        },
      ),
    );
  }
}
