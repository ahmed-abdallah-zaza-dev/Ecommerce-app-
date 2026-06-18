import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/core/widgets/empty_state.dart';

void main() {
  testWidgets('EmptyState displays title and message', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyState(
            title: 'Test Title',
            message: 'Test Message',
            icon: Icons.favorite,
          ),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Message'), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
