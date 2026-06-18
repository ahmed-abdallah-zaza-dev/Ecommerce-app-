import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/core/errors/failures.dart';
import 'package:flutter_application_1/features/products/domain/entities/product.dart';
import 'package:flutter_application_1/features/products/data/models/product_model.dart';
import 'package:flutter_application_1/features/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'package:flutter_application_1/features/wishlist/domain/repositories/wishlist_repository.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource localDataSource;

  WishlistRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Product>>> getWishlist() async {
    try {
      final products = await localDataSource.getWishlist();
      return Right(products);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToWishlist(Product product) async {
    try {
      final productModel = ProductModel(
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        thumbnail: product.thumbnail,
        images: product.images,
        rating: product.rating,
        discountPercentage: product.discountPercentage,
        brand: product.brand,
        stock: product.stock,
        reviews: product.reviews
            .map(
              (e) => ReviewModel(
                rating: e.rating,
                comment: e.comment,
                date: e.date,
                reviewerName: e.reviewerName,
                reviewerEmail: e.reviewerEmail,
              ),
            )
            .toList(),
      );
      await localDataSource.addToWishlist(productModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(int productId) async {
    try {
      await localDataSource.removeFromWishlist(productId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
