import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application_1/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:flutter_application_1/features/auth/presentation/screens/splash_screen.dart';
import 'package:flutter_application_1/features/products/presentation/screens/product_list_screen.dart';
import 'package:flutter_application_1/features/products/presentation/screens/product_details_screen.dart';
import 'package:flutter_application_1/features/cart/presentation/screens/cart_screen.dart';
import 'package:flutter_application_1/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter_application_1/features/wishlist/presentation/screens/wishlist_screen.dart';
import 'package:flutter_application_1/features/profile/presentation/screens/order_history_screen.dart';
import 'package:flutter_application_1/features/profile/presentation/screens/addresses_screen.dart';
import 'package:flutter_application_1/features/profile/presentation/screens/settings_screens.dart';
import 'package:flutter_application_1/features/payments/presentation/screens/online_payment_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final bool loggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation == '/splash';

      if (authState is Unauthenticated) {
        return loggingIn ? null : '/login';
      }

      if (authState is Authenticated) {
        if (loggingIn) return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductListScreen(),
        routes: [
          GoRoute(
            path: 'product/:id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return ProductDetailsScreen(productId: id);
            },
          ),
          GoRoute(
            path: 'cart',
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: 'wishlist',
            builder: (context, state) => const WishlistScreen(),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'orders',
                builder: (context, state) => const OrderHistoryScreen(),
              ),
              GoRoute(
                path: 'addresses',
                builder: (context, state) => const AddressesScreen(),
              ),
              GoRoute(
                path: 'settings',
                builder: (context, state) =>
                    const ProfileSettingsScreen(title: 'Settings'),
              ),
              GoRoute(
                path: 'security',
                builder: (context, state) => const SecurityScreen(),
              ),
              GoRoute(
                path: 'help',
                builder: (context, state) => const HelpCenterScreen(),
              ),
              GoRoute(
                path: 'payment-online',
                builder: (context, state) => const OnlinePaymentScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
