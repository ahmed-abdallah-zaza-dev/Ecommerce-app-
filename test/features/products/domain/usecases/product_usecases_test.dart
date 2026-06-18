import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/features/products/domain/entities/product.dart';
import 'package:flutter_application_1/features/products/domain/repositories/product_repository.dart';
import 'package:flutter_application_1/features/products/domain/usecases/get_products_use_case.dart';
import 'package:flutter_application_1/features/products/domain/usecases/get_products_by_category_use_case.dart';

class FakeProductRepository implements ProductRepository {
  final List<Product> mockProducts = [
    const Product(
      id: 1,
      title: 'Product One',
      price: 10.0,
      description: 'First test product',
      category: 'beauty',
      thumbnail: '',
      images: [],
      rating: 4.5,
      discountPercentage: 10.0,
      stock: 5,
      reviews: [],
    ),
    const Product(
      id: 2,
      title: 'Product Two',
      price: 20.0,
      description: 'Second test product',
      category: 'furniture',
      thumbnail: '',
      images: [],
      rating: 3.8,
      discountPercentage: 5.0,
      stock: 10,
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
    try {
      final product = mockProducts.firstWhere((p) => p.id == id);
      return Right(product);
    } catch (_) {
      return const Left(ServerFailure('Product not found'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    final filtered = mockProducts.where((p) => p.title.toLowerCase().contains(query.toLowerCase())).toList();
    return Right(filtered);
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category) async {
    final filtered = mockProducts.where((p) => p.category.toLowerCase() == category.toLowerCase()).toList();
    return Right(filtered);
  }
}

void main() {
  late FakeProductRepository fakeRepository;
  late GetProductsUseCase getProductsUseCase;
  late GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  setUp(() {
    fakeRepository = FakeProductRepository();
    getProductsUseCase = GetProductsUseCase(fakeRepository);
    getProductsByCategoryUseCase = GetProductsByCategoryUseCase(fakeRepository);
  });

  group('Product UseCases Tests', () {
    test('GetProductsUseCase should return all products', () async {
      final result = await getProductsUseCase(const PaginationParams());

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('should succeed'),
        (products) {
          expect(products.length, equals(2));
          expect(products[0].title, equals('Product One'));
        },
      );
    });

    test('GetProductsByCategoryUseCase should return filtered products', () async {
      final result = await getProductsByCategoryUseCase(const SingleParam('beauty'));

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('should succeed'),
        (products) {
          expect(products.length, equals(1));
          expect(products[0].category, equals('beauty'));
        },
      );
    });

    test('GetProductsByCategoryUseCase should return empty list if category does not match', () async {
      final result = await getProductsByCategoryUseCase(const SingleParam('unknown'));

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('should succeed'),
        (products) {
          expect(products.isEmpty, isTrue);
        },
      );
    });
  });
}
