import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShoppingCartController extends StateNotifier<AsyncValue<void>> {
  ShoppingCartController({required this.cartService})
      : super(const AsyncData(null));
  final CartService cartService;

  Future<void> updateQuantity(ProductID productID, int quantity) async {
    state = const AsyncLoading();
    final updated = Item(productId: productID, quantity: quantity);
    state = await AsyncValue.guard(() => cartService.setItem(updated));
  }

  Future<void> removeItemById(ProductID productID) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => cartService.removeItemById(productID));
  }
}

final shoppingCartScreenControllerProvider =
    StateNotifierProvider<ShoppingCartController, AsyncValue>((ref) {
  return ShoppingCartController(cartService: ref.watch(cartServiceProvider));
});
