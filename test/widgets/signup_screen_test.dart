import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:campushub/screens/signup_screen.dart';
import 'package:campushub/services/auth_service.dart';

void main() {
  // Test 1: Check that SignupScreen UI renders correctly
  testWidgets('SignupScreen renders correctly', (tester) async {
    final mockAuth = MockFirebaseAuth();

    final authService = AuthService(auth: mockAuth);

    await tester.pumpWidget(
      MaterialApp(
        home: SignupScreen(authService: authService),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that all required form labels exist in the UI
    expect(find.text('First Name'), findsOneWidget);
    expect(find.text('Last Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  // Test 2: Check user input interaction with form fields
  testWidgets('User enters text', (tester) async {
    final mockAuth = MockFirebaseAuth();

    final authService = AuthService(auth: mockAuth);

    await tester.pumpWidget(
      MaterialApp(
        home: SignupScreen(authService: authService),
      ),
    );

    await tester.pumpAndSettle();

    // Simulate user typing into form fields
    await tester.enterText(find.byType(TextField).at(0), 'John');
    await tester.enterText(find.byType(TextField).at(1), 'Doe');
    await tester.enterText(find.byType(TextField).at(2), 'john.doe@test.com');
    await tester.enterText(find.byType(TextField).at(3), '123456');
    
    // Verify input was entered correctly
    expect(find.text('John'), findsOneWidget);
    expect(find.text('john.doe@test.com'), findsOneWidget);
  });
}