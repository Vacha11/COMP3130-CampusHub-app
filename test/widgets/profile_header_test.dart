import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campushub/widgets/profile/profile_header.dart';

void main() {

  testWidgets('ProfileHeader displays user information correctly', (WidgetTester tester) async {

    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileHeader(
            profileImage: null,
            profileImageUrl: null,
            username: 'John Doe',
            email: 'john@test.com',
            onEditPhoto: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    // Verify username and email render
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@test.com'), findsOneWidget);

    // Verify default profile icon appears
    expect(find.byIcon(Icons.person), findsOneWidget);

    // Verify edit icon appears
    expect(find.byIcon(Icons.edit), findsOneWidget);

    // Tap the profile image area
    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    // Verify callback triggered
    expect(tapped, true);
  });

  testWidgets('ProfileHeader shows edit icon', (WidgetTester tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileHeader(
            profileImage: null,
            profileImageUrl: null,
            username: 'Jane',
            email: 'jane@test.com',
            onEditPhoto: () {},
          ),
        ),
      ),
    );

    // Verify edit icon exists
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });
}