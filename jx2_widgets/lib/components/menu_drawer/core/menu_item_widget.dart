import 'package:flutter/material.dart';
import 'package:jx2_widgets/components/screens/snackbar_message.dart';
import 'package:jx_utils/logs/log.dart';
import 'menu_item.dart';

class MenuItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  const MenuItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
      tileColor: color,
      textColor: textColor,
    );
  }
}

class MenuSectionWidget extends StatelessWidget {
  final String sectionTitle;
  final List<MenuItem> items;
  final Color color;
  final Color textColor;

  const MenuSectionWidget({
    super.key,
    required this.sectionTitle,
    required this.items,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(sectionTitle, style: TextStyle(fontWeight: FontWeight.bold)),
          tileColor: color,
          textColor: textColor,
        ),
        for (var item in items)
          MenuItemWidget(
            title: item.title,
            icon: item.icon,
            color: item.color!,
            textColor: item.textColor!,
            onTap: () {
              Navigator.of(context).pop();
              (item.route == null)
                  ? (item.func == null)
                        ? snackMessage(
                            context,
                            "Atenção! Acesso negado a essa opção.",
                            () => {},
                            4,
                            SMType.warning,
                          )
                        : item.func!(context)
                  : Navigator.of(context).pushNamed(item.route!);
            },
          ),
      ],
    );
  }
}
