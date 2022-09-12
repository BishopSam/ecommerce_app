@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_signin_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '1234';

  group('submit', () {
    test(
      '''
Given formType is signIn
When signInWithEmailAndPassword succeeds
Then return true
And state is AsyncData
  ''',
      () async {
        // set up
        final authRepository = MockAuthRepository();
        when(() => authRepository.signInWithEmailandPassword(
            testEmail, testPassword)).thenAnswer((_) => Future.value());

        final controller = EmailSignInController(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn);

        // expect later
        expectLater(
            controller.stream,
            emitsInOrder([
              EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: const AsyncLoading<void>()),
              EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: const AsyncData<void>(null)),
            ]));

        // run
        final result = await controller.submit(testEmail, testPassword);
        // verify
        expect(result, true);
      },
    );

    test(
      '''
Given formType is signIn
When signInWithEmailAndPassword fails
Then return true
And state is AsyncError
  ''',
      () async {
        // set up
        final authRepository = MockAuthRepository();
        final exception = Exception('Connection Failed');
        when(() => authRepository.signInWithEmailandPassword(
            testEmail, testPassword)).thenThrow(exception);

        final controller = EmailSignInController(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.signIn);

        // expect later
        expectLater(
            controller.stream,
            emitsInOrder([
              EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.signIn,
                  value: const AsyncLoading<void>()),
              predicate<EmailPasswordSignInState>((state) {
                expect(state.formType, EmailPasswordSignInFormType.signIn);
                expect(state.value.hasError, true);
                return true;
              })
            ]));

        // run
        final result = await controller.submit(testEmail, testPassword);
        // verify
        expect(result, false);
      },
     
    );

    test(
      '''
Given formType is register
When createUserWithEmailAndPassword succeeds
Then return true
And state is AsyncData
  ''',
      () async {
        // set up
        final authRepository = MockAuthRepository();

        when(() => authRepository.createUserWithEmailandPassword(
            testEmail, testPassword)).thenAnswer((_) => Future.value());

        final controller = EmailSignInController(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.register);

        // expect later
        expectLater(
            controller.stream,
            emitsInOrder([
              EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: const AsyncLoading<void>()),
              EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: const AsyncData<void>(null)),
            ]));

        // run
        final result = await controller.submit(testEmail, testPassword);
        // verify
        expect(result, true);
      },
     
    );

    test(
      '''
Given formType is register
When createUserWithEmailAndPassword fails
Then return false
And state is AsyncError
  ''',
      () async {
        // set up
        final authRepository = MockAuthRepository();
        final exception = Exception('Connection Failed');
        when(() => authRepository.createUserWithEmailandPassword(
            testEmail, testPassword)).thenThrow(exception);

        final controller = EmailSignInController(
            authRepository: authRepository,
            formType: EmailPasswordSignInFormType.register);

        // expect later
        expectLater(
            controller.stream,
            emitsInOrder([
              EmailPasswordSignInState(
                  formType: EmailPasswordSignInFormType.register,
                  value: const AsyncLoading<void>()),
              predicate<EmailPasswordSignInState>((state) {
                expect(state.formType, EmailPasswordSignInFormType.register);
                expect(state.value.hasError, true);
                return true;
              })
            ]));

        // run
        final result = await controller.submit(testEmail, testPassword);
        // verify
        expect(result, false);
      },
     
    );
  });

  group('updateformtype', () {
    test(
        '''
Given the formtype is signIn
When called with register
Then stat.formtype is register
''',
        () {
      //set up
      final authRepository = MockAuthRepository();
      final controller = EmailSignInController(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.signIn,
      );

      //run
      controller.updateFormtType(EmailPasswordSignInFormType.register);

      //verify
      expect(
          controller.debugState,
          EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncData<void>(null)));
    });

    test(
        '''
Given the formtype is register
When called with signin
Then stat.formtype is signin
''',
        () {
      //set up
      final authRepository = MockAuthRepository();
      final controller = EmailSignInController(
        authRepository: authRepository,
        formType: EmailPasswordSignInFormType.register,
      );

      //run
      controller.updateFormtType(EmailPasswordSignInFormType.signIn);

      //verify
      expect(
          controller.debugState,
          EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncData<void>(null)));
    });
  });
}
