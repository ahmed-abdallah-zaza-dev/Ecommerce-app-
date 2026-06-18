import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_application_1/core/network/dio_client.dart';
import 'package:flutter_application_1/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/login_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/logout_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/get_token_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:flutter_application_1/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_application_1/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_application_1/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_application_1/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter_application_1/features/products/domain/usecases/get_products_use_case.dart';
import 'package:flutter_application_1/features/products/domain/usecases/get_product_details_use_case.dart';
import 'package:flutter_application_1/features/products/domain/usecases/search_products_use_case.dart';
import 'package:flutter_application_1/features/products/domain/usecases/get_products_by_category_use_case.dart';
import 'package:flutter_application_1/features/products/domain/repositories/product_repository.dart';
import 'package:flutter_application_1/features/products/data/repositories/product_repository_impl.dart';
import 'package:flutter_application_1/features/products/data/datasources/product_remote_data_source.dart';
import 'package:flutter_application_1/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/save_cart_use_case.dart';
import 'package:flutter_application_1/features/cart/domain/repositories/cart_repository.dart';
import 'package:flutter_application_1/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:flutter_application_1/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:flutter_application_1/features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'package:flutter_application_1/features/wishlist/domain/usecases/get_wishlist_use_case.dart';
import 'package:flutter_application_1/features/wishlist/domain/usecases/add_to_wishlist_use_case.dart';
import 'package:flutter_application_1/features/wishlist/domain/usecases/remove_from_wishlist_use_case.dart';
import 'package:flutter_application_1/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:flutter_application_1/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:flutter_application_1/features/wishlist/data/datasources/wishlist_local_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features
  // Auth
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getTokenUseCase: sl(),
      getCurrentUserUseCase: sl(),
      signUpUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetTokenUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => FirebaseAuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );

  sl.registerFactory(
    () => ProductBloc(
      getProductsUseCase: sl(),
      getProductDetailsUseCase: sl(),
      searchProductsUseCase: sl(),
      getProductsByCategoryUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsByCategoryUseCase(sl()));
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );

  // Cart
  sl.registerFactory(
    () => CartBloc(getCartUseCase: sl(), saveCartUseCase: sl()),
  );
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => SaveCartUseCase(sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(sl()),
  );

  // Wishlist
  sl.registerFactory(
    () => WishlistBloc(
      getWishlistUseCase: sl(),
      addToWishlistUseCase: sl(),
      removeFromWishlistUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetWishlistUseCase(sl()));
  sl.registerLazySingleton(() => AddToWishlistUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromWishlistUseCase(sl()));
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<WishlistLocalDataSource>(
    () => WishlistLocalDataSourceImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton(() => DioClient(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => firebase.FirebaseAuth.instance);
}
