import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  testWidgets('Cancel logout', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreen();
    await r.tapLogOutButton();
    r.expectLogoutDialogFound();
    await r.tapCancelButton();
    r.expectLogoutDialogNotFound();
  });

   testWidgets('logout success', (tester) async {
    final r = AuthRobot(tester);
    await r.pumpAccountScreen();
    await r.tapLogOutButton();
    r.expectLogoutDialogFound();
    await r.tapDiaLogLogoutButton();
    r.expectLogoutDialogNotFound();
    r.expectErrorDialogNotFound();
  });

     testWidgets('confirm logout, failure', (tester) async {
    final r = AuthRobot(tester);
    final authRepository = MockAuthRepository();
    final exception =Exception('Connection Failed');
    when(authRepository.signOut).thenThrow(exception);
    when(authRepository.authStateChanges).thenAnswer((_) => Stream.value(
      const AppUser(uid: '123', email: 'test@test.com')
    ));
    await r.pumpAccountScreen(authRepository: authRepository);
    await r.tapLogOutButton();
    r.expectLogoutDialogFound();
    await r.tapDiaLogLogoutButton();
    r.expectErrorDialogFound();
  });
}
