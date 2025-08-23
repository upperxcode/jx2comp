import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jx2_widgets/components/menu_drawer/core/menu_item.dart';


void main() {
  group('MenuItem', () {
    test('should create a MenuItem with default colors', () {
      final menuItem = MenuItem(
        title: 'Home',
        icon: Icons.home,
        route: '/home',
      );

      expect(menuItem.title, 'Home');
      expect(menuItem.icon, Icons.home);
      expect(menuItem.route, '/home');
      expect(menuItem.textColor, Colors.black);
      expect(menuItem.color, Colors.white24);
    });

    test('should create a MenuItem with specified colors', () {
      final menuItem = MenuItem(
        title: 'Profile',
        icon: Icons.person,
        route: '/profile',
        textColor: Colors.white,
        color: Colors.blue,
      );

      expect(menuItem.title, 'Profile');
      expect(menuItem.icon, Icons.person);
      expect(menuItem.route, '/profile');
      expect(menuItem.textColor, Colors.white);
      expect(menuItem.color, Colors.blue);
    });
  });

  group('MenuSection', () {
    test('should create a MenuSection with default colors', () {
      final menuSection = MenuSection(
        sectionTitle: 'Settings',
        items: [
          MenuItem(
            title: 'General Settings',
            icon: Icons.settings,
            route: '/settings/general',
          ),
          MenuItem(
            title: 'Privacy Settings',
            icon: Icons.lock,
            route: '/settings/privacy',
          ),
        ],
      );

      expect(menuSection.sectionTitle, 'Settings');
      expect(menuSection.items.length, 2);
      expect(menuSection.items[0].title, 'General Settings');
      expect(menuSection.items[1].title, 'Privacy Settings');
    });

    test('should create a MenuSection with specified colors', () {
      final menuSection = MenuSection(
        sectionTitle: 'Settings',
        items: [
          MenuItem(
            title: 'General Settings',
            icon: Icons.settings,
            route: '/settings/general',
          ),
          MenuItem(
            title: 'Privacy Settings',
            icon: Icons.lock,
            route: '/settings/privacy',
          ),
        ],
        textColor: Colors.white,
        color: Colors.blue,
      );

      expect(menuSection.sectionTitle, 'Settings');
      expect(menuSection.items.length, 2);
      expect(menuSection.items[0].title, 'General Settings');
      expect(menuSection.items[1].title, 'Privacy Settings');
      expect(menuSection.textColor, Colors.white);
      expect(menuSection.color, Colors.blue);
    });
  });
}