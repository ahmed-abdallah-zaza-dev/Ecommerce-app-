import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import '../../domain/usecases/get_product_details_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../../domain/usecases/search_products_use_case.dart';
import '../../domain/usecases/get_products_by_category_use_case.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final SearchProductsUseCase searchProductsUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  ProductBloc({
    required this.getProductsUseCase,
    required this.getProductDetailsUseCase,
    required this.searchProductsUseCase,
    required this.getProductsByCategoryUseCase,
  }) : super(ProductInitial()) {
    on<LoadProductsRequested>(_onLoadProductsRequested);
    on<LoadProductDetailsRequested>(_onLoadProductDetailsRequested);
    on<SearchProductsRequested>(_onSearchProductsRequested);
    on<LoadMoreProductsRequested>(_onLoadMoreProductsRequested);
    on<FilterProductsRequested>(_onFilterProductsRequested);
  }

  Future<void> _onLoadProductsRequested(
    LoadProductsRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await getProductsUseCase(const PaginationParams(skip: 0));
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(
        ProductsLoaded(products: products, hasReachedMax: products.length < 20),
      ),
    );
  }

  Future<void> _onLoadProductDetailsRequested(
    LoadProductDetailsRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    final result = await getProductDetailsUseCase(SingleParam(event.id));
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (product) => emit(ProductDetailsLoaded(product)),
    );
  }

  Future<void> _onSearchProductsRequested(
    SearchProductsRequested event,
    Emitter<ProductState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(LoadProductsRequested());
      return;
    }

    emit(ProductLoading());
    final result = await searchProductsUseCase(SingleParam(event.query));
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) =>
          emit(ProductsLoaded(products: products, hasReachedMax: true)),
    );
  }

  Future<void> _onLoadMoreProductsRequested(
    LoadMoreProductsRequested event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      if (currentState.hasReachedMax) return;

      final result = await getProductsUseCase(
        PaginationParams(skip: currentState.products.length),
      );
      result.fold((failure) => emit(ProductError(failure.message)), (
        newProducts,
      ) {
        if (newProducts.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(
            currentState.copyWith(
              products: List.of(currentState.products)..addAll(newProducts),
              hasReachedMax: newProducts.length < 20,
            ),
          );
        }
      });
    }
  }

  Future<void> _onFilterProductsRequested(
    FilterProductsRequested event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    if (event.category == 'All') {
      add(LoadProductsRequested());
      return;
    }
    final result = await getProductsByCategoryUseCase(SingleParam(event.category));
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) =>
          emit(ProductsLoaded(products: products, hasReachedMax: true)),
    );
  }
}
