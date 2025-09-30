import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jx2_widgets/components/menu_drawer/jx2drawer.dart';
import 'package:jx2_widgets/components/menu_drawer/core/menu_item.dart';
import 'package:jx2_widgets/example/app_constants.dart';

const String mockPerfilImage = 'http://localhost:3000/profile.jpg';
const String mockBackgroundImage = 'http://localhost:3000/background.jpg';

void main() {
  testWidgets('Jx2Drawer displays user header and menu items', (WidgetTester tester) async {
    // Define the test key.
    const testKey = Key('jx2drawer');

    // Define the menu items.
    final menuItems = [
      MenuItem(title: 'Home', icon: Icons.home, route: homeRoute),
      MenuItem(title: 'Profile', icon: Icons.person, route: profileRoute),
    ];

    // Build the widget.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Test App')),
          drawer: Jx2Drawer(
            key: testKey,
            menuItems: menuItems,
            backgroundImageUrl: mockBackgroundImage,
            perfilImageUrl: mockPerfilImage,
            name: 'John Doe',
            email: 'john.doe@example.com',
            notificationCount: 2,
          ),
        ),
      ),
    );

    // Open the drawer.
    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    // Verify if the user header is displayed.
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john.doe@example.com'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    // Verify if the menu items are displayed.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('Jx2Drawer does not display notification count when it is zero', (
    WidgetTester tester,
  ) async {
    // Define the test key.
    const testKey = Key('jx2drawer');

    // Define the menu items.
    final menuItems = [
      MenuItem(title: 'Home', icon: Icons.home, route: homeRoute),
      MenuItem(title: 'Profile', icon: Icons.person, route: profileRoute),
    ];

    // Build the widget.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Test App')),
          drawer: Jx2Drawer(
            key: testKey,
            menuItems: menuItems,
            backgroundImageUrl: mockBackgroundImage,
            perfilImageUrl: mockPerfilImage,
            name: 'John Doe',
            email: 'john.doe@example.com',
            notificationCount: 0,
          ),
        ),
      ),
    );

    // Open the drawer.
    final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    // Verify if the notification count is not displayed.
    expect(find.text('0'), findsNothing);

    // Verify if the menu items are displayed.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
