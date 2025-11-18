import 'package:depi_app/core/models/product.dart';
import 'package:depi_app/features/HomeScreen/presentation/home_screen.dart';
import 'package:depi_app/features/auth/presentation/views/login_view.dart';
import 'package:depi_app/features/auth/presentation/views/register_view.dart';
import 'package:depi_app/features/auth/presentation/views/reset_password_view.dart';
import 'package:depi_app/features/favorite_screen/FavoriteScreen.dart';
import 'package:depi_app/features/onboarding/presentation/onboarding_view.dart';
import 'package:depi_app/features/productDetails/presentation/product_details.dart';
import 'package:depi_app/features/chat/presentation/view/chat_screen.dart';
import 'package:depi_app/features/home/presentation/home_view.dart';
import 'package:depi_app/features/onboarding/presentation/onboarding_view.dart';
import 'package:depi_app/features/settings/presentation/edit_profile_view.dart';
import 'package:depi_app/features/settings/presentation/settings_view.dart';
import 'package:depi_app/features/splash/presentation/splash_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const kOnboardingView = '/onboardingView';
  static const kSplash = '/';
  static const kLogin = '/loginView';
  static const kRegister = '/registerView';
  static const kForgotPassword = '/forgotPasswordView';
  static const kResetPassword = '/resetPasswordView';
  static const kHome = '/homeScreen';
  static const kProductDetails = '/ProductDetails';
  static const kFavoriteScreen = '/favoriteScreen';
  static const kResetPassword = '/forgotPasswordView';
  static const kHome = '/home';
  static const kSettings = '/settings';
  static const kEditProfile = '/editProfile';
  static const kUserChat = '/userChat';
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
      GoRoute(
        path: kResetPassword,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      // GoRoute(
      //   path: kResetPassword,
      //   builder: (context, state) => const SplashView(),
      // ),
      GoRoute(path: kHome, builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: kFavoriteScreen,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: AppRouter.kProductDetails,
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetails(product: product);
        },
      GoRoute(path: kHome, builder: (context, state) => const HomeView()),

      GoRoute(
        path: kSettings,
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: kEditProfile,
        builder: (context, state) => const EditProfileView(),
      ),
      GoRoute(
        path: kUserChat,
        builder: (context, state) => const UserChatScreen(),
      ),
    ],
  );
}
