import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campushub/screens/splash_screen.dart';

void main() {
  testWidgets('Splash shows main UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    // check app name
    expect(find.text('CampusHub'), findsOneWidget);

    // Check tagline appears
    expect(find.text('Buy, Sell, Connect on Campus'), findsOneWidget);

    // check button exists
    expect(find.text('Get Started'), findsOneWidget);
  });

}
