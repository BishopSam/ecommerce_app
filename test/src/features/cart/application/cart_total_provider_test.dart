import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('carTotalProvider', () {
    ProviderContainer makeProviderContainer(
        {required AsyncValue<Cart> cart,
        required AsyncValue<List<Product>> productList}) {
      final container = ProviderContainer(overrides: [
        cartProvider.overrideWithValue(cart),
        productsListStreamProvider.overrideWithValue(productList)
      ]);
      addTearDown(container.dispose);
      return container;
    }

    test('cart loading', () {
      final container = makeProviderContainer(
          cart: const AsyncLoading(),
          productList: const AsyncData(kTestProducts));

      final cartTotal = container.read(cartTotalProvider);

      expect(cartTotal, 0);
    });

    test('empty cart', () {
      final container = makeProviderContainer(
          cart: const AsyncData(Cart()),
          productList: const AsyncData(kTestProducts));

      final cartTotal = container.read(cartTotalProvider);

      expect(cartTotal, 0);
    });

    test('one cart item', () {
      final container = makeProviderContainer(
          cart: const AsyncData(Cart({'1': 5})),
          productList: const AsyncData(kTestProducts));

      final cartTotal = container.read(cartTotalProvider);

      expect(cartTotal, 75);
    });

    test('two cart items', () {
      final container = makeProviderContainer(
          cart: const AsyncData(Cart({'1': 5, '2': 3})),
          productList: const AsyncData(kTestProducts));

      final cartTotal = container.read(cartTotalProvider);

      expect(cartTotal, 114);
    });

    test('invalid cart item', () {
      final container = makeProviderContainer(
          cart: const AsyncData(Cart({'100': 5})),
          productList: const AsyncData(kTestProducts));

      expect(() => container.read(cartTotalProvider), throwsStateError);
    });
  });
}
