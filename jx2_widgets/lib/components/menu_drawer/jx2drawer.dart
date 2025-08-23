import 'package:flutter/material.dart';
import 'core/menu_item.dart' as item;
import 'core/menu_item_widget.dart';
import 'core/user_header.dart';

class Jx2Drawer extends StatelessWidget {
  final List<item.MenuEntry> menuItems;
  final ImageProvider backgroundImage;
  final ImageProvider perfilimage;
  final String name;
  final String email;
  final int notificationCount;

  const Jx2Drawer({
    super.key,
    required this.menuItems,
    required this.backgroundImage,
    required this.perfilimage,
    required this.name,
    required this.email,
    required this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: menuItems.length + 1, // Add one for the header
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return UserHeader(
              backgroundImage: backgroundImage,
              perfilimage: perfilimage,
              name: name,
              email: email,
              notificationCount: notificationCount,
            );
          } else {
            final menuItem = menuItems[index - 1];
            if (menuItem is item.MenuSection) {
              return MenuSectionWidget(
                sectionTitle: menuItem.sectionTitle,
                items: menuItem.items,
                color: menuItem.color!,
                textColor: menuItem.textColor!,
              );
            } else if (menuItem is item.MenuItem) {
              return MenuItemWidget(
                title: menuItem.title,
                icon: menuItem.icon,
                color: menuItem.color!,
                textColor: menuItem.textColor!,
                onTap: () => Navigator.of(context).pushReplacementNamed(menuItem.route),
              );
            } else {
              return SizedBox.shrink(); // Return an empty widget if the type is not recognized
            }
          }
        },
      ),
    );
  }
}
