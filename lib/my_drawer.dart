import 'package:flutter/material.dart';
import 'display_menu.dart';
import 'my_drawertile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: SizedBox(
              height: 142,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "assets/images/menus/logo.png",
              ),
            ),
          ),
          MyDrawerTile(
            text: "H O M E",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),
          MyDrawerTile(
            text: "M E N U",
            icon: Icons.person,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayMenuPage()));
            },
          ),
          MyDrawerTile(
            text: "F A V O U R I T E S",
            icon: Icons.favorite,
            onTap: () {
              //Navigator.pop(context);
              //Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          MyDrawerTile(
            text: "N O T I F I C A T I O N S",
            icon: Icons.notification_important,
            onTap: () {
              //Navigator.pop(context);
              //Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          MyDrawerTile(
            text: "S E T T I N G S",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              //Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          const Spacer(),
          MyDrawerTile(
            text: "L O G O U T",
            icon: Icons.logout,
            onTap: () {},
            //onTap: () => logout(context),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
