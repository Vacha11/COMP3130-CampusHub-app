import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campushub/widgets/common/confirmation_dialog.dart';


void main() {
 testWidgets('ConfirmationDialog shows content and returns true on confirm',
     (WidgetTester tester) async {
   bool? result;


   await tester.pumpWidget(
     MaterialApp(
       home: Builder(
         builder: (context) {
           return Scaffold(
             body: Center(
               child: ElevatedButton(
                 child: const Text('Open Dialog'),
                 onPressed: () async {
                   result = await showDialog<bool>(
                     context: context,
                     builder: (_) => const ConfirmationDialog(
                       title: 'Delete Item',
                       content: 'Are you sure you want to delete this?',
                       confirmText: 'Delete',
                     ),
                   );
                 },
               ),
             ),
           );
         },
       ),
     ),
   );


   // Open dialog
   await tester.tap(find.text('Open Dialog'));
   await tester.pumpAndSettle();


   // Verify UI renders correctly
   expect(find.text('Delete Item'), findsOneWidget);
   expect(find.text('Are you sure you want to delete this?'), findsOneWidget);
   expect(find.text('Cancel'), findsOneWidget);
   expect(find.text('Delete'), findsOneWidget);


   // Tap confirm button
   await tester.tap(find.text('Delete'));
   await tester.pumpAndSettle();


   // Check returned value
   expect(result, true);
 });


 testWidgets('ConfirmationDialog returns false when cancelled',
     (WidgetTester tester) async {
   bool? result;


   await tester.pumpWidget(
     MaterialApp(
       home: Builder(
         builder: (context) {
           return Scaffold(
             body: Center(
               child: ElevatedButton(
                 child: const Text('Open Dialog'),
                 onPressed: () async {
                   result = await showDialog<bool>(
                     context: context,
                     builder: (_) => const ConfirmationDialog(
                       title: 'Delete Item',
                       content: 'Are you sure you want to delete this?',
                       confirmText: 'Delete',
                     ),
                   );
                 },
               ),
             ),
           );
         },
       ),
     ),
   );


   // Open dialog
   await tester.tap(find.text('Open Dialog'));
   await tester.pumpAndSettle();


   // Tap cancel
   await tester.tap(find.text('Cancel'));
   await tester.pumpAndSettle();


   // Check returned value
   expect(result, false);
 });
}

