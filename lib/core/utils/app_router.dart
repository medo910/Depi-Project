import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/features/auth/presentation/views/login_view.dart';
import 'package:depi_app/features/auth/presentation/views/register_view.dart';
import 'package:depi_app/features/auth/presentation/views/reset_password_view.dart';
import 'package:depi_app/features/cart/presentation/views/cart_screen.dart';
import 'package:depi_app/features/checkout/presentation/views/checkout_screen.dart';
import 'package:depi_app/features/customerSupport/presentation/views/customer_support_screen.dart';
import 'package:depi_app/features/onboarding/presentation/onboarding_view.dart';
import 'package:depi_app/features/orderSummary/presentation/order_summary.dart';
import 'package:depi_app/features/splash/presentation/splash_view.dart';
import 'package:go_router/go_router.dart';

import '../../features/profile/presentation/views/profile_screen.dart';
import '../models/order.dart';

abstract class AppRouter {
  static const kOnboardingView = '/onboardingView';
  static const kSplash = '/';
  static const kLogin = '/loginView';
  static const kRegister = '/registerView';
  static const kForgotPassword = '/forgotPasswordView';
  static const kResetPassword = '/resetPasswordView';
  static const kHome = '/home';
  static const kCart='/cart';
  static const kCustomerSupport='/customerSupport';
  static const kCheckout='/checkout';
  static const kProfile='/profile';
  static const kOrderSummary='/orderSummary';

  static final router = GoRouter(
    routes: [
      GoRoute(path: kSplash, builder: (context, state) => const SplashView()),
      GoRoute(
        path: kOnboardingView,
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(path: kLogin, builder: (context, state) => LoginView()),
      GoRoute(
        path: kRegister,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: kForgotPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      // GoRoute(
      //   path: kResetPassword,
      //   builder: (context, state) => const SplashView(),
      // ),
      GoRoute(path: kHome, builder: (context, state) => const SplashView()),
      GoRoute(path: kCart, builder: (context, state) => const CartScreen()),
      GoRoute(path: kCustomerSupport, builder: (context, state) => const CustomerSupportScreen()),
      GoRoute(path: kCheckout, builder: (context, state) =>  CheckoutScreen()),
      GoRoute(path: kProfile, builder: (context, state) => const ProfileScreen()),
      GoRoute(
        path: kOrderSummary,
        builder: (context, state) {
          final snapshot = state.extra as QueryDocumentSnapshot<Map<String, dynamic>>;

          final order = MyOrder.fromMap(
            snapshot.data(),
            id: snapshot.id,
          );

          return OrderSummary(order: order);
        },
      ),



    ],
  );
}
