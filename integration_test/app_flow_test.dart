import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/core/di/injection_container.dart' as di;
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/features/products/domain/repositories/product_repository.dart';
import 'package:flutter_application_1/features/auth/domain/entities/user.dart';
import 'package:flutter_application_1/features/products/domain/entities/product.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/features/products/presentation/widgets/product_card.dart';

class FakeAuthRepository implements AuthRepository {
  String? cachedToken = 'cached_token_abc';
  User? currentUser = const User(
    id: 'uid_abc',
    email: 'integration@example.com',
    username: 'integration_tester',
    token: 'token_abc',
    fullName: 'Integration Tester',
  );

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    return Right(currentUser!);
  }

  @override
  Future<Either<Failure, User>> signUp(String email, String password) async {
    return Right(currentUser!);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    cachedToken = null;
    currentUser = null;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    return Right(cachedToken);
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    return Right(currentUser);
  }
}

class FakeProductRepository implements ProductRepository {
  final List<Product> mockProducts = [
    const Product(
      id: 1,
      title: 'Integration Product One',
      price: 15.0,
      description: 'First integration test product',
      category: 'beauty',
      thumbnail: 'https://dummyjson.com/image/1',
      images: ['https://dummyjson.com/image/1'],
      rating: 4.8,
      discountPercentage: 10.0,
      stock: 8,
      reviews: [],
    ),
  ];

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int skip = 0,
    int limit = 20,
  }) async {
    return Right(mockProducts);
  }

  @override
  Future<Either<Failure, Product>> getProductDetails(int id) async {
    return Right(mockProducts.first);
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    return Right(mockProducts);
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category) async {
    return Right(mockProducts);
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E Integration Test - E-Commerce App Flow', () {
    setUpAll(() async {
      // Allow overriding di registrations in test mode
      di.sl.allowReassignment = true;
    });

    testWidgets('Should log in and navigate to product details screen', (WidgetTester tester) async {
      // 1. Initialize dependencies using fakes
      await di.init();
      
      // Override registrations with Fakes to prevent Firebase Core connection crashes
      di.sl.registerLazySingleton<AuthRepository>(() => FakeAuthRepository());
      di.sl.registerLazySingleton<ProductRepository>(() => FakeProductRepository());

      // 2. Load the App
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // App starts at Splash, checks auth status, and because we mock startup status, 
      // let's simulate unauthenticated first by logging out/clearing cached token if needed.
      // Actually, since FakeAuthRepository starts with cachedToken, it will login automatically!
      // But we want to test the Login Screen flow, so let's override with an unauthenticated status.
      final fakeAuth = FakeAuthRepository();
      fakeAuth.cachedToken = null;
      fakeAuth.currentUser = null;
      di.sl.registerLazySingleton<AuthRepository>(() => fakeAuth);

      // Re-run pump to reflect unauthenticated state redirection to Login
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // 3. Verify we are on the Login screen
      expect(find.text('Welcome Back'), findsOneWidget);

      // 4. Input credentials
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'integration@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      // 5. Submit Login Form
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      
      // Simulate AuthBloc login process completing
      // Re-assign fake repository back to normal authenticated status
      fakeAuth.cachedToken = 'cached_token_abc';
      fakeAuth.currentUser = const User(
        id: 'uid_abc',
        email: 'integration@example.com',
        username: 'integration_tester',
        token: 'token_abc',
      );
      
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // 6. Verify navigation lands on Product List (Home Screen)
      expect(find.text('Discover'), findsOneWidget);
      expect(find.byType(ProductCard), findsOneWidget);
      expect(find.text('Integration Product One'), findsOneWidget);

      // 7. Tap on Product Card to navigate to details
      final productCard = find.byType(ProductCard).first;
      await tester.tap(productCard);
      await tester.pumpAndSettle();

      // 8. Verify details screen renders description correctly
      expect(find.text('Product Details'), findsOneWidget);
      expect(find.text('First integration test product'), findsOneWidget);
    });
  });
}
