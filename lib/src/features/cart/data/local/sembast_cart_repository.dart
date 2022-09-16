import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastCartRepository implements LocalCartRepository {
  SembastCartRepository(this.db);
  final Database db;
  final store = StoreRef.main();

  static Future<Database> createDatabase(String fileName) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$fileName');
    } else {
      return databaseFactoryWeb.openDatabase(fileName);
    }
  }

  static Future<SembastCartRepository> makeDefault() async {
    return SembastCartRepository(await createDatabase('default.db'));
  }

  static const cartItemsKey = 'cartItems';

  // * Read back from local storage with a future
  @override
  Future<Cart> fetchCart() async {
    final cartJson = await store.record(cartItemsKey).get(db) as String?;
    if (cartJson != null) {
      return Cart.fromJson(cartJson);
    } else {
      return const Cart();
    }
  }

  //! Store to local storage
  @override
  Future<void> setCart(Cart cart) {
    return store.record(cartItemsKey).put(db, cart.toJson());
  }

  //? Watch the local storage with a stream
  @override
  Stream<Cart> watchCart() {
    final record = store.record(cartItemsKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Cart.fromJson(snapshot.value);
      } else {
        return const Cart();
      }
    });
  }
}
