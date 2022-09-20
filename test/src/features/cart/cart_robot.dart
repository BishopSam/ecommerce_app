import 'package:ecommerce_app/src/common_widgets/item_quantity_selector.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_item.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/shopping_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class CartRobot {
  CartRobot(this.tester);
  final WidgetTester tester;

  //locate add to cart button and tap
  Future<void> addToCart() async {
    final listFinder = find.byType(Scrollable);
    final itemFinder = find.byType(PrimaryButton);

    // Scroll until the item to be found appears.
    await tester.scrollUntilVisible(
      itemFinder,
      500.0,
      scrollable: listFinder,
    );
    expect(itemFinder, findsOneWidget);
    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    await tester.tap(itemFinder);
    await tester.pumpAndSettle();
  }

  // shopping cart
  Future<void> openCart() async {
    final finder = find.byKey(ShoppingCartIcon.shoppingCartIconKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  //expect to see disabled button with "out of stock"
  void expectProductIsOutOfStock() async {
    final finder = find.text('Out of Stock');
    expect(finder, findsOneWidget);
  }

  //locate the plus icon and tap on it for quantity times
  Future<void> incrementCartItemQuantity(
      {required int quantity, required int atIndex}) async {
    final finder = find.byKey(ItemQuantitySelector.incrementKey(atIndex));
    expect(finder, findsOneWidget);
    for (var i = 0; i < quantity; i++) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }

  //locate the minus icon and tap on it for quantity times
  Future<void> decrementCartItemQuantity(
      {required int quantity, required int atIndex}) async {
    final finder = find.byKey(ItemQuantitySelector.decrementKey(atIndex));
    expect(finder, findsOneWidget);
    for (var i = 0; i < quantity; i++) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }

  //locate delete icon and tap on it
  Future<void> deleteCartItem({required int atIndex}) async {
    final finder = find.byKey(ShoppingCartItemContents.deleteKey(atIndex));
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  //see loading state
  void expectShoppingCartIsLoading() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }

  //empty cart screen
  void expectShoppingCartIsEmpty() {
    final finder = find.text('Your shopping cart is empty');
    expect(finder, findsOneWidget);
  }

  //same with above
  void expectFindZeroCartItems() {
    final finder = find.byType(ShoppingCartItem);
    expect(finder, findsNothing);
  }

  //expect to see n number of cart items on screen
  void expectFindNCartItems(int count) {
    final finder = find.byType(ShoppingCartItem);
    expect(finder, findsNWidgets(count));
  }

  //find the number of items on the cart item
  Text getItemQuantityWidget({int? atIndex}) {
    final finder = find.byKey(ItemQuantitySelector.quantityKey(atIndex));
    expect(finder, findsOneWidget);
    return finder.evaluate().single.widget as Text;
  }

  void expectItemQuantity({required int quantity, int? atIndex}) {
    final text = getItemQuantityWidget(atIndex: atIndex);
    expect(text.data, '$quantity');
  }

  // the total text on the cart checkout builder
  void expectShoppingCartTotalIs(String text) {
    final finder = find.text(text);
    expect(finder, findsOneWidget);
  }
}
