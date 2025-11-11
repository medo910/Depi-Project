import 'package:depi_app/features/auth/presentation/views/login_view.dart';
import 'package:depi_app/features/auth/presentation/views/register_view.dart';
import 'package:depi_app/features/auth/presentation/views/reset_password_view.dart';
import 'package:depi_app/features/onboarding/presentation/onboarding_view.dart';
import 'package:depi_app/features/productDetails/presentation/product_details.dart';
import 'package:depi_app/features/splash/presentation/splash_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const kOnboardingView = '/onboardingView';
  static const kSplash = '/';
  static const kLogin = '/loginView';
  static const kRegister = '/registerView';
  static const kForgotPassword = '/forgotPasswordView';
  static const kResetPassword = '/resetPasswordView';
  static const kHome = '/home';

  static const kProductDetails = '/ProductDetails';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: kSplash,
        builder: (context, state) => const ProductDetails(),
      ),
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
    ],
  );
}
