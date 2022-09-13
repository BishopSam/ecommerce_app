import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class AuthRobot{
  AuthRobot(this.tester);
  final WidgetTester tester;


  Future<void> openEmailandPasswordSignInScreen() async {
    final finder = find.byKey(MoreMenuButton.signInKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> openAccountScreen() async{
    final finder = find.byKey(MoreMenuButton.accountKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> pumpEmailandPasswordSignInContents(
  {
 required FakeAuthRepository authRepository,
  required EmailPasswordSignInFormType formType,
  VoidCallback? onSignedIn 
  } 
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository)
        ],
        child: MaterialApp(
        home: Scaffold(
          body:  EmailPasswordSignInContents(
            formType: formType,
            onSignedIn: onSignedIn,
          ),
        ),
      ))
    );
  }

  Future<void> signInWithEmailandPassword()async{
    await enterEmailandPassword(email: 'test@test.com', password: 'test1234');
    await tapSigninSubmitButton();

  }

  Future<void> enterEmailandPassword({required String email, required String password}) async {
    final emailField = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);

    final passwordField = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);
  }

  Future<void> tapSigninSubmitButton() async {
    final primaryButton = find.byType(PrimaryButton);
    expect(primaryButton, findsOneWidget);

    await tester.tap(primaryButton);
    await tester.pumpAndSettle();
  }

  Future<void> pumpAccountScreen({FakeAuthRepository? authRepository}) async {
    await tester.pumpWidget(
       ProviderScope(
      overrides: [
        if(authRepository !=null)
        authRepositoryProvider.overrideWithValue(authRepository)
      ],
      child: const MaterialApp(
        home: AccountScreen(),
      ),
    ));
  }

  Future<void> tapLogOutButton() async {
     final logoutButton = find.text('Logout');
    expect(logoutButton, findsOneWidget);

    await tester.tap(logoutButton);
    await tester.pump();
  }

  void expectLogoutDialogFound() {
      final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);

    await tester.pump();
  }

  void expectLogoutDialogNotFound() {
      final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsNothing);
  }

   Future<void> tapDiaLogLogoutButton() async {
     final logoutButton = find.byKey(kDefaultDialogKey);
    expect(logoutButton, findsOneWidget);

    await tester.tap(logoutButton);
    await tester.pump();
  }

  void expectErrorDialogFound(){
    final dialogTitle = find.text('Error');
    expect(dialogTitle, findsOneWidget);
  }

   void expectErrorDialogNotFound(){
    final dialogTitle = find.text('Error');
    expect(dialogTitle, findsNothing);
  }

  void expectCircularPorgressIndicatorFound(){
    final cPIndicator = find.byType(CircularProgressIndicator);
    expect(cPIndicator, findsOneWidget);

  }
}