import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductsRequested extends ProductEvent {}

class LoadProductDetailsRequested extends ProductEvent {
  final int id;

  const LoadProductDetailsRequested(this.id);

  @override
  List<Object?> get props => [id];
}

class SearchProductsRequested extends ProductEvent {
  final String query;

  const SearchProductsRequested(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreProductsRequested extends ProductEvent {}

class FilterProductsRequested extends ProductEvent {
  final String category;

  const FilterProductsRequested(this.category);

  @override
  List<Object?> get props => [category];
}
