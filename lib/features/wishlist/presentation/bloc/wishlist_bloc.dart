import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/features/wishlist/domain/usecases/get_wishlist_use_case.dart';
import 'package:flutter_application_1/features/wishlist/domain/usecases/add_to_wishlist_use_case.dart';
import 'package:flutter_application_1/features/wishlist/domain/usecases/remove_from_wishlist_use_case.dart';
import 'package:flutter_application_1/features/wishlist/presentation/bloc/wishlist_event.dart';
import 'package:flutter_application_1/features/wishlist/presentation/bloc/wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetWishlistUseCase getWishlistUseCase;
  final AddToWishlistUseCase addToWishlistUseCase;
  final RemoveFromWishlistUseCase removeFromWishlistUseCase;

  WishlistBloc({
    required this.getWishlistUseCase,
    required this.addToWishlistUseCase,
    required this.removeFromWishlistUseCase,
  }) : super(WishlistInitial()) {
    on<LoadWishlistRequested>(_onLoadWishlistRequested);
    on<AddToWishlistRequested>(_onAddToWishlistRequested);
    on<RemoveFromWishlistRequested>(_onRemoveFromWishlistRequested);
  }

  Future<void> _onLoadWishlistRequested(
    LoadWishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoading());
    final result = await getWishlistUseCase(const NoParams());
    result.fold(
      (failure) => emit(WishlistError(failure.message)),
      (products) => emit(WishlistLoaded(products)),
    );
  }

  Future<void> _onAddToWishlistRequested(
    AddToWishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    final result = await addToWishlistUseCase(SingleParam(event.product));
    result.fold(
      (failure) => emit(WishlistError(failure.message)),
      (_) => add(LoadWishlistRequested()),
    );
  }

  Future<void> _onRemoveFromWishlistRequested(
    RemoveFromWishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    final result = await removeFromWishlistUseCase(
      SingleParam(event.productId),
    );
    result.fold(
      (failure) => emit(WishlistError(failure.message)),
      (_) => add(LoadWishlistRequested()),
    );
  }
}
