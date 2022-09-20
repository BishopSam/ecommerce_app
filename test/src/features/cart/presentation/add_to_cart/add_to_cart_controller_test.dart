import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/presentation/add_to_cart/add_to_cart_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  group('add Item' , (){
    const productId = '1';

    test('added item with quantity 2, success', () async {
    //SETUP
    const quantity = 2;
    const item = Item(productId: productId, quantity: quantity);
    final cartService = MockCartService();
    when(() => cartService.addItem(item)).thenAnswer((_) => Future.value());
    final controller = AddToCartController(cartService: cartService);

    expect(controller.debugState, const AsyncData(1));

    controller.updateQuantity(quantity);

    expect(controller.debugState, const AsyncData(2));

    await controller.addItem(productId);
    verify(() => cartService.addItem(item)).called(1);

    expect(controller.debugState, const AsyncData(1));
    });

      test('item added with quantity = 2, failure', () async {
      const quantity = 2;
      const item = Item(productId: productId, quantity: quantity);
      final cartService = MockCartService();
      when(() => cartService.addItem(item))
          .thenThrow((_) => Exception('Connection failed'));
      final controller = AddToCartController(cartService: cartService);
      expect(
        controller.debugState,
        const AsyncData(1),
      );
      controller.updateQuantity(quantity);
      expect(
        controller.debugState,
        const AsyncData(2),
      );
      // * if desired, use expectLater and emitsInOrder here to check that
      // * addItems emits two values
      await controller.addItem(productId);
      verify(() => cartService.addItem(item)).called(1);
      // check that quantity goes back to 1 after adding an item
      expect(
        controller.debugState,
       isA<AsyncError>()
      );
    });
  });
}