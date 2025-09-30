import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/screens/snackbar_message.dart';

import 'core/menu_item.dart' as item;
import 'core/menu_item_widget.dart';
import 'core/user_header.dart';

class Jx2Drawer extends StatelessWidget {
  final List<item.MenuEntry> menuItems;
  final String backgroundImageUrl;
  final String perfilImageUrl;
  final String name;
  final String email;
  final int notificationCount;

  const Jx2Drawer({
    super.key,
    required this.menuItems,
    required this.backgroundImageUrl,
    required this.perfilImageUrl,
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
              backgroundImageUrl: backgroundImageUrl,
              perfilImageUrl: perfilImageUrl,
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
                onTap: () {
                  Navigator.of(context).pop();
                  (menuItem.route == null)
                      ? (menuItem.func == null)
                            ? snackMessage(
                                context,
                                "Atenção! Acesso negado a essa opção.",
                                () => {},
                                4,
                                SMType.warning,
                              )
                            : menuItem.func!(context)
                      : Navigator.of(context).pushNamed(menuItem.route!);
                },
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
