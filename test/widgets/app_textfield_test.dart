import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campushub/widgets/common/app_text_fields.dart';


void main() {
 testWidgets('AppTextField renders and accepts input', (WidgetTester tester) async {
   final controller = TextEditingController();


   await tester.pumpWidget(
     MaterialApp(
       home: Scaffold(
         body: AppTextField(
           controller: controller,
           hint: 'Enter email',
         ),
       ),
     ),
   );


   // Verify field exists
   expect(find.byType(TextField), findsOneWidget);


   // Verify hint text exists
   expect(find.text('Enter email'), findsOneWidget);


   // Enter text
   await tester.enterText(find.byType(TextField), 'hello@test.com');
   expect(controller.text, 'hello@test.com');
 });
}

