import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const productId = '1';

  group('updateItemQuantity', () {
    test('update quantity, success', () async {
      //set up
      const item = Item(productId: productId, quantity: 3);
      final cartService = MockCartService();
      when(() => cartService.setItem(item)).thenAnswer((_) => Future.value());
      final controller = ShoppingCartController(cartService: cartService);

      //expectLater
      expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            const AsyncData<void>(null),
          ]));

      //run & verify
      await controller.updateQuantity(productId, 3);
      verify(() => cartService.setItem(item)).called(1);
    });

     test('update quantity, failure', () async {
      //set up
      const item = Item(productId: productId, quantity: 3);
      final cartService = MockCartService();
      final exception = Exception('Connecction Failed');
      when(() => cartService.setItem(item)).thenThrow(exception);
      final controller = ShoppingCartController(cartService: cartService);

      //expectLater
      expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            isA<AsyncError>(),
          ]));

      //run & verify
      await controller.updateQuantity(productId, 3);
      verify(() => cartService.setItem(item)).called(1);
    });
  });

  group('removeItemById', (){
     test('remove item, success', () async {
      //set up
      final cartService = MockCartService();
      when(() => cartService.removeItemById(productId)).thenAnswer((_) => Future.value());
      final controller = ShoppingCartController(cartService: cartService);

      //expectLater
      expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            const AsyncData<void>(null),
          ]));

      //run & verify
      await controller.removeItemById(productId);
      verify(() => cartService.removeItemById(productId)).called(1);
    });

    test('remove item, failure', () async {
      //set up
     
      final cartService = MockCartService();
      final exception = Exception('Connecction Failed');
      when(() => cartService.removeItemById(productId)).thenThrow(exception);
      final controller = ShoppingCartController(cartService: cartService);

      //expectLater
      expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            isA<AsyncError>(),
          ]));

      //run & verify
      await controller.removeItemById(productId);
      verify(() => cartService.removeItemById(productId)).called(1);
    });
  });
}
