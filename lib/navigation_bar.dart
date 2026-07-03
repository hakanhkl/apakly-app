import 'package:apakly/auth_globals.dart';
import 'package:apakly/constants.dart';
import 'package:apakly/home/homescreen.dart';
import 'package:apakly/login/login_screen.dart';
import 'package:apakly/user/user_profile.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
              accountName: Text(
                  "${userFirstName!} ${userLastName!}",
                  style: const TextStyle(color: textColor)
              ),
              accountEmail: Text(
                  userEmail!,
                style: const TextStyle(
                  color: textColor,
                  fontSize: fSize1,
                ),
              ),
            decoration: const BoxDecoration(
              color: primaryColor,
            ),
          ),
          ListTile(
              leading: const Icon(
                Icons.account_circle,
                color: textColor,
              ),
              title: const Text(
                  'Account',
                  style: TextStyle(color: textColor)),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.timer,
              color: textColor,
            ),
            title: const Text(
                'My Reminders',
              style: TextStyle(
                color: textColor,
                fontSize: fSize1,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
              leading: const Icon(
                Icons.wallet_membership,
                color: textColor,
              ),
              title: const Text(
                  'Payment Settings',
                style: TextStyle(
                  color: textColor,
                  fontSize: fSize1,
                ),
              ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
              leading: const Icon(
                Icons.doorbell,
                color: textColor,
              ),
              title: const Text(
                  'Notifications',
                style: TextStyle(
                  color: textColor,
                  fontSize: fSize1,
                ),
              ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
              leading: const Icon(
                Icons.help,
                color: textColor,
              ),
              title: const Text(
                  'Help',
                style: TextStyle(
                  color: textColor,
                  fontSize: fSize1,
                ),
              ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },

          ),
          ListTile(
              leading: const Icon(
                Icons.logout,
                color: textColor,
              ),
              title: const Text(
                  'Logout',
                style: TextStyle(
                  color: textColor,
                  fontSize: fSize1,
                ),
              ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
