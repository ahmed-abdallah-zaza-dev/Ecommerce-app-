import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/core/di/injection_container.dart' as di;
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application_1/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_application_1/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_application_1/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_application_1/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:flutter_application_1/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:flutter_application_1/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter_application_1/core/router/router_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/core/widgets/error_view.dart';
import 'dart:developer' as dev;

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const AppInitWrapper());
}

class AppInitWrapper extends StatefulWidget {
  const AppInitWrapper({super.key});

  @override
  State<AppInitWrapper> createState() => _AppInitWrapperState();
}

class _AppInitWrapperState extends State<AppInitWrapper> {
  bool _initialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      dev.log('Starting Initialization...');

      dev.log('Initializing Firebase...');
      await Firebase.initializeApp();
      dev.log('Firebase initialized.');

      dev.log('Initializing Dependency Injection...');
      await di.init();
      dev.log('DI initialized.');

      setState(() {
        _initialized = true;
      });
    } catch (e, stackTrace) {
      dev.log('Initialization error: $e', stackTrace: stackTrace);
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: ErrorView(
            message: _error!,
            onRetry: () {
              setState(() {
                _error = null;
                _initialized = false;
              });
              _initialize();
            },
          ),
        ),
      );
    }

    if (!_initialized) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 24),
                Text(
                  'جاري التحميل...',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider(create: (_) => di.sl<ProductBloc>()),
        BlocProvider(
          create: (_) => di.sl<CartBloc>()..add(LoadCartRequested()),
        ),
        BlocProvider(
          create: (_) => di.sl<WishlistBloc>()..add(LoadWishlistRequested()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter E-Commerce',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ar')],
      ),
    );
  }
}
