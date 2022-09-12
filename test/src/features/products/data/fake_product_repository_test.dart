import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_product_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
   FakeProductRepository makeProductsRepo() => FakeProductRepository(addDelay: false);
  group('FakeProductsRepository', () {
    test('getProducts List returns global list', () {
      final productsRepository = makeProductsRepo();
      expect(productsRepository.getProducts(), kTestProducts);
    });

    test('getProduct(1) returns first item on list', () {
      final productsRepository = makeProductsRepo();
      expect(productsRepository.getProduct('1'), kTestProducts[0]);
    });

    test('getProducts(100) returns null', () {
      final productsRepository = makeProductsRepo();
      expect(productsRepository.getProduct('100'), null);
    });

    test('fetchProductList returns global list', () async {
      final productsRepository = makeProductsRepo();
      expect(await productsRepository.fetchProductList(), kTestProducts);
    });

    test('watchProductList emits global list', () {
      final productsRepository = makeProductsRepo();
      expect(productsRepository.watchProductList(), emits(kTestProducts));
    });

    test('watchProduct(1) emits first item', () {
      final productsRepository = makeProductsRepo();
      expect(
        productsRepository.watchProduct('1'),
        emits(kTestProducts[0]),
      );
    });

    test('watchProduct(100) emits null item', () {
      final productsRepository = makeProductsRepo();
      expect(
        productsRepository.watchProduct('100'),
        emits(null),
      );
    });
  });
}