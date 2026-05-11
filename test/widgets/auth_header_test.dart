import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campushub/widgets/auth/auth_header.dart';

void main() {

  // Test: AuthHeader renders branding correctly
  testWidgets('AuthHeader displays logo and branding text',
      (WidgetTester tester) async {

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AuthHeader(),
        ),
      ),
    );

    // Check logo image appears
    expect(find.byType(Image), findsOneWidget);

    // Check app name appears
    expect(find.text('CampusHub'), findsOneWidget);

    // Check tagline appears
    expect(find.text('Buy, Sell, Connect on Campus'), findsOneWidget);
  });
}