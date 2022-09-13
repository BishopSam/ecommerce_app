 import 'package:flutter_test/flutter_test.dart';

import 'robot.dart';

void main() {
  testWidgets('sign-in and sign-out flow', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    r.expectFindAllProductCards();
    await r.openPopUpMenu();
    await r.auth.openEmailandPasswordSignInScreen();
    await r.auth.signInWithEmailandPassword();
    r.expectFindAllProductCards();
    await r.openPopUpMenu();
    await r.auth.openAccountScreen();
    await r.auth.tapLogOutButton();
    r.auth.expectLogoutDialogFound();
    await r.auth.tapDiaLogLogoutButton();
    r.expectFindAllProductCards();
  });  
}