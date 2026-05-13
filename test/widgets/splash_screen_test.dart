import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campushub/screens/splash_screen.dart';
import 'package:campushub/services/user_profile_service_interface.dart';

class FakeProfileService implements UserProfileServiceInterface {
  @override
  Future<String?> getProfileImageUrl(String uid) async => null;

  @override
  Future<void> saveProfileImageUrl(String uid, String url) async {}

  @override
  Future<String> uploadProfilePicture(file, uid) async => '';
}

void main() {
  testWidgets('Splash shows main UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(
       MaterialApp(
        home: SplashScreen(profileService: FakeProfileService()),
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
