import 'package:apakly/music/music_screen.dart';
import 'package:apakly/user/user_profile.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../marketplace/marketplace_screen.dart';
import 'components/upcoming.dart';
import '../music_player/music_player_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentPage = "Upcoming";

  List<String> pageKeys = ["Upcoming","Marketplace","Bibliothek","Profile"];

  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Upcoming": GlobalKey<NavigatorState>(),
    "Marketplace": GlobalKey<NavigatorState>(),
    "Bibliothek": GlobalKey<NavigatorState>(),
    "Profile": GlobalKey<NavigatorState>(),
  };

  int currentIndex = 0;

  void _selectTab(String tabItem, int index) {
    if(tabItem == currentPage ){
      _navigatorKeys[tabItem]?.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        currentPage = pageKeys[index];
        currentIndex = index;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MusicPlayerBuilder(),
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: backgroundColor,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedFontSize: fSize0,
              unselectedFontSize: fSize0,
              iconSize: 18,
              unselectedItemColor: Colors.white54,
              selectedItemColor: primaryColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.local_fire_department_outlined),
                  label: AppLocalizations.of(context)!.upcoming,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.storefront_outlined),
                  label: AppLocalizations.of(context)!.marketplace,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.music_note_outlined),
                  label: AppLocalizations.of(context)!.library,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.face_outlined),
                  label: AppLocalizations.of(context)!.profile,
                ),
              ],
              currentIndex: currentIndex,
              onTap: (int index){
                _selectTab(pageKeys[index], index);
                },
            )
          ],
        ),
        body: Stack(
          children: <Widget>[
            _buildOffstageNavigator("Upcoming"),
            _buildOffstageNavigator("Marketplace"),
            _buildOffstageNavigator("Bibliothek"),
            _buildOffstageNavigator("Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem){
    return Offstage(
      offstage: currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
      ),
    );
  }
}


class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;

  const TabNavigator({super.key, required this.navigatorKey, required this.tabItem});

  @override
  Widget build(BuildContext context) {
    Widget child;

    if(tabItem == "Marketplace"){
      child = const MarketplaceScreen();
    }
    else if(tabItem == "Bibliothek"){
      child = const MusicScreen();
    }
    else if(tabItem == "Profile"){
      child = const UserProfile();
    }else{
      child = const Upcoming();
    }
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings){
        return MaterialPageRoute(
            builder: (context) => child
        );
      },
    );
  }
}



