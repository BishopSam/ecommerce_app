import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_product_repository.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/product_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'authentication/auth_robot.dart';
import 'goldens/golden_robot.dart';

class Robot {
  Robot(this.tester)
      : auth = AuthRobot(tester),
        golden = GoldenRobot(tester);
  final WidgetTester tester;
  final AuthRobot auth;
  final GoldenRobot golden;

  Future<void> pumpMyApp() async {
    final authRepository = FakeAuthRepository(addDelay: false);
    final productsRepository = FakeProductRepository(addDelay: false);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        productsRepositoryProvider.overrideWithValue(productsRepository),
        authRepositoryProvider.overrideWithValue(authRepository)
      ],
      child: const MyApp(),
    ));

    await tester.pumpAndSettle();
  }

  Future<void> openPopUpMenu() async {
    final finder = find.byType(MoreMenuButton);
    final matches = finder.evaluate();

    if (matches.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }

  void expectFindAllProductCards() {
    final productCard = find.byType(ProductCard);
    expect(productCard, findsNWidgets(kTestProducts.length));
  }
}
