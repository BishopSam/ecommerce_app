import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';
import '../../auth_robot.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';

  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  group('sign in', () {
    testWidgets('''
Given formType is Sign in
When tap on the signin button
Then signinwithemailandpassword is not called
''', (tester) async {
      final r = AuthRobot(tester);
      await r.pumpEmailandPasswordSignInContents(
          authRepository: authRepository,
          formType: EmailPasswordSignInFormType.signIn);
      await r.tapSigninSubmitButton();
      verifyNever(() => authRepository.signInWithEmailandPassword(
            any(),
            any(),
          ));
    });

    testWidgets('''
Given formType is Sign in
When entervalid email and password
And tap on the signin button
Then signinwithemailandpassword is called
And onsgnedIn callback is called
And error alert is not shown
''', (tester) async {
      var didSignIn = false;
      final r = AuthRobot(tester);
      when(() => authRepository.signInWithEmailandPassword(
          testEmail, testPassword)).thenAnswer((_) => Future.value());
      await r.pumpEmailandPasswordSignInContents(
          authRepository: authRepository,
          onSignedIn: () => didSignIn = true,
          formType: EmailPasswordSignInFormType.signIn);
      await r.enterEmailandPassword(email: testEmail, password: testPassword);
      await r.tapSigninSubmitButton();
      verify(() => authRepository.signInWithEmailandPassword(
            testEmail,
            testPassword,
          )).called(1);
      r.expectErrorDialogNotFound();
      expect(didSignIn, true);
    });
  });
}