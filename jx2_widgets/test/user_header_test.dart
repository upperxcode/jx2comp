import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jx2_widgets/components/menu_drawer/core/user_header.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

const String mockPerfilImage = 'http://localhost:3000/profile.jpg';
const String mockBackgroundImage = 'http://localhost:3000/background.jpg';

void main() {
  testWidgets('UserHeader displays background image, profile image, name, email, and notification count', (WidgetTester tester) async {
    // Define the test key.
    const testKey = Key('userHeader');

    // Use mockNetworkImagesFor to mock network images
    await mockNetworkImages(() async {
      // Build the widget.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserHeader(
              key: testKey,
              backgroundImage: NetworkImage(mockBackgroundImage),
              perfilimage: NetworkImage(mockPerfilImage),
              name: 'John Doe',
              email: 'john.doe@example.com',
              notificationCount: 2,
            ),
          ),
        ),
      );

      // Wait for the images to load
      await tester.pumpAndSettle();

      // Verify if the background image is displayed.
      expect(find.byWidgetPredicate((widget) => widget is Image && widget.image is NetworkImage && (widget.image as NetworkImage).url == mockBackgroundImage), findsOneWidget);

      // Verify if the profile image is displayed.
      expect(find.byWidgetPredicate((widget) => widget is CircleAvatar && widget.backgroundImage is NetworkImage && (widget.backgroundImage as NetworkImage).url == mockPerfilImage), findsOneWidget);

      // Verify if the name is displayed.
      expect(find.text('John Doe'), findsOneWidget);

      // Verify if the email is displayed.
      expect(find.text('john.doe@example.com'), findsOneWidget);

      // Verify if the notification count is displayed.
      expect(find.text('2'), findsOneWidget);
    });
  });

  testWidgets('UserHeader does not display notification count when it is zero', (WidgetTester tester) async {
    // Define the test key.
    const testKey = Key('userHeader');

    // Use mockNetworkImagesFor to mock network images
    await mockNetworkImages(() async {
      // Build the widget.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UserHeader(
              key: testKey,
              backgroundImage: NetworkImage(mockBackgroundImage),
              perfilimage: NetworkImage(mockPerfilImage),
              name: 'John Doe',
              email: 'john.doe@example.com',
              notificationCount: 0,
            ),
          ),
        ),
      );

      // Wait for the images to load
      await tester.pumpAndSettle();

      // Verify if the notification count is not displayed.
      expect(find.text('0'), findsNothing);
    });
  });
}