import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jx2_widgets/components/menu_drawer/core/menu_item_widget.dart';



void main() {
  testWidgets('MenuItemWidget displays title and icon', (WidgetTester tester) async {
    // Define the test key.
    const testKey = Key('menuItemWidget');

    // Build the widget.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MenuItemWidget(
            key: testKey,
            title: 'Test Title',
            icon: Icons.home,
            onTap: () {},
            color: Colors.blue,
            textColor: Colors.white,
          ),
        ),
      ),
    );

    // Verify if the title is displayed.
    expect(find.text('Test Title'), findsOneWidget);

    // Verify if the icon is displayed.
    expect(find.byIcon(Icons.home), findsOneWidget);

    // Verify if the tile color is applied.
    final listTile = tester.widget<ListTile>(find.byType(ListTile));
    expect(listTile.tileColor, Colors.blue);

    // Verify if the text color is applied.
    final color = listTile.textColor;
    expect(color, Colors.white);
  });

  testWidgets('MenuItemWidget calls onTap callback when tapped', (WidgetTester tester) async {
    bool wasTapped = false;

    // Build the widget.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MenuItemWidget(
            title: 'Test Title',
            icon: Icons.home,
            onTap: () {
              wasTapped = true;
            },
            color: Colors.blue,
            textColor: Colors.white,
          ),
        ),
      ),
    );

    // Tap the widget.
    await tester.tap(find.byType(ListTile));
    await tester.pump();

    // Verify if the onTap callback was called.
    expect(wasTapped, isTrue);
  });
}