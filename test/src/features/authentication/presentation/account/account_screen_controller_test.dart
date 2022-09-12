@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';


void main() {
  group('AccountScreenController', () {
    test('initial state is AsyncValue.data(null)', () {
      final authRepository = MockAuthRepository();
      final controller =
          AccountScreenController(authRepository: authRepository);
      verifyNever(authRepository.signOut);
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test(
      'signOut success',
      () async {
        // setup
        final authRepository = MockAuthRepository();
        when(authRepository.signOut).thenAnswer((_) => Future.value());
        final controller =
            AccountScreenController(authRepository: authRepository);

        //expect later
        expectLater(
            controller.stream,
            emitsInOrder(const [
              AsyncLoading<void>(),
              AsyncData<void>(null),
            ]));
        // run
        await controller.signOut();
        
        // verify
        verify(() => authRepository.signOut()).called(1);
      },
    
    );

    test('signOut failure', () async {
      //setup
      final authRepository = MockAuthRepository();
      final exception = Exception('Connection Failed');
      when(authRepository.signOut).thenThrow(exception);
      final controller =
          AccountScreenController(authRepository: authRepository);

       //expect later
        expectLater(
            controller.stream,
            emitsInOrder( [
             const  AsyncLoading<void>(),
              predicate<AsyncValue<void>>(
                (value) {
                  expect(value.hasError, true);
                  return true;
                }
              ),
            ]));

      //run
      await controller.signOut();

      //verify
      verify(() => authRepository.signOut()).called(1);
    
    },);
  });
}
