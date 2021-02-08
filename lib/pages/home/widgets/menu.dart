import 'package:flutter/material.dart';
import 'package:match_game/pages/home/widgets/menu_item.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(
              flex: 1,
            ),
            Divider(),
            MenuItem(routeName: '/settings', title: 'Settings')
          ],
        ),
      ),
    );
  }
}
