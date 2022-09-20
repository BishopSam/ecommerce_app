import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class ProductsRobot {
  ProductsRobot(this.tester);
  final WidgetTester tester;

  // tap a product card at a specifix index, defualts to tapping the first
  Future<void> selectProduct({int atIndex = 0}) async {
    final finder = find.byKey(ProductCard.productCardKey);
    await tester.tap(finder.at(atIndex));
    await tester.pumpAndSettle();
  }

  //expect to see all the product cards
  void expectFindAllProductCards() {
    final finder = find.byType(ProductCard);
    expect(finder, findsNWidgets(kTestProducts.length));
  }

    //expect to see n product cards
  void expectFindNProductCards(int count) {
    final finder = find.byType(ProductCard);
    expect(finder, findsNWidgets(count));
  }

  //increase product quantity on product page before adding to cart
  Future<void> setProductQuantity(int quantity) async {
    final finder = find.byIcon(Icons.add);
    expect(finder, findsOneWidget);
    for (var i = 1; i < quantity; i++) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }
}
