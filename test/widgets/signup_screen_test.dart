import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:campushub/screens/signup_screen.dart';
import 'package:campushub/services/auth_service.dart';

void main() {
  testWidgets('SignupScreen renders correctly', (tester) async {
    final mockAuth = MockFirebaseAuth();

    final authService = AuthService(auth: mockAuth);

    await tester.pumpWidget(
      MaterialApp(
        home: SignupScreen(authService: authService),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('User enters text', (tester) async {
    final mockAuth = MockFirebaseAuth();

    final authService = AuthService(auth: mockAuth);

    await tester.pumpWidget(
      MaterialApp(
        home: SignupScreen(authService: authService),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'John');
    await tester.enterText(find.byType(TextField).at(1), 'Doe');
    await tester.enterText(find.byType(TextField).at(2), 'john.doe@test.com');
    await tester.enterText(find.byType(TextField).at(3), '123456');

    expect(find.text('John'), findsOneWidget);
  });
}