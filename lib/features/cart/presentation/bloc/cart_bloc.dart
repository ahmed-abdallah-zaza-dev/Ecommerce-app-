import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/core/usecases/base_use_case.dart';
import 'package:flutter_application_1/features/cart/domain/entities/cart_item.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:flutter_application_1/features/cart/domain/usecases/save_cart_use_case.dart';
import 'package:flutter_application_1/features/cart/presentation/bloc/cart_event.dart';
import 'package:flutter_application_1/features/cart/presentation/bloc/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final SaveCartUseCase saveCartUseCase;

  CartBloc({required this.getCartUseCase, required this.saveCartUseCase})
    : super(CartInitial()) {
    on<LoadCartRequested>(_onLoadCartRequested);
    on<AddProductToCartRequested>(_onAddProductToCartRequested);
    on<RemoveProductFromCartRequested>(_onRemoveProductFromCartRequested);
    on<UpdateQuantityRequested>(_onUpdateQuantityRequested);
    on<ClearCartRequested>(_onClearCartRequested);
  }

  Future<void> _onLoadCartRequested(
    LoadCartRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    final result = await getCartUseCase(const NoParams());
    result.fold(
      (failure) => emit(CartError(failure.message)),
      (items) => emit(CartLoaded(items)),
    );
  }

  Future<void> _onAddProductToCartRequested(
    AddProductToCartRequested event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentItems = List<CartItem>.from((state as CartLoaded).items);
      final index = currentItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );

      if (index != -1) {
        currentItems[index] = currentItems[index].copyWith(
          quantity: currentItems[index].quantity + 1,
        );
      } else {
        currentItems.add(CartItem(product: event.product, quantity: 1));
      }

      await saveCartUseCase(SingleParam(currentItems));
      emit(CartLoaded(currentItems));
    }
  }

  Future<void> _onRemoveProductFromCartRequested(
    RemoveProductFromCartRequested event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentItems = List<CartItem>.from((state as CartLoaded).items);
      currentItems.removeWhere((item) => item.product.id == event.productId);

      await saveCartUseCase(SingleParam(currentItems));
      emit(CartLoaded(currentItems));
    }
  }

  Future<void> _onUpdateQuantityRequested(
    UpdateQuantityRequested event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      final currentItems = List<CartItem>.from((state as CartLoaded).items);
      final index = currentItems.indexWhere(
        (item) => item.product.id == event.productId,
      );

      if (index != -1) {
        if (event.quantity > 0) {
          currentItems[index] = currentItems[index].copyWith(
            quantity: event.quantity,
          );
        } else {
          currentItems.removeAt(index);
        }
        await saveCartUseCase(SingleParam(currentItems));
        emit(CartLoaded(currentItems));
      }
    }
  }

  Future<void> _onClearCartRequested(
    ClearCartRequested event,
    Emitter<CartState> emit,
  ) async {
    await saveCartUseCase(const SingleParam([]));
    emit(const CartLoaded([]));
  }
}
