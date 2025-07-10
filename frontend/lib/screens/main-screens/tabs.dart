import 'package:flutter/material.dart';
import 'package:tatar_shower/theme/colors.dart';
import 'package:tatar_shower/theme/images.dart';
import 'package:tatar_shower/screens/main-screens/main_screen.dart';
import 'package:tatar_shower/screens/main-screens/settings-screens/settings_screen.dart';
import 'package:tatar_shower/screens/main-screens/timer-screens/set_timer_screen.dart';

class Tabs extends StatefulWidget {
  const Tabs();

  @override
  State<Tabs> createState() => _MainWithTabs();
}

class _MainWithTabs extends State<Tabs> {
  int _currentIndex = 0;
  static final List<Widget> _screens = [
    MainScreen(),
    SetTimerScreen(),
    SettingsScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: appColors.black, width: 0.5)),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: _currentIndex,
            onTap: _onTap,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: appColors.black,
            unselectedItemColor: appColors.black,
            items: [
              BottomNavigationBarItem(
                icon: ImageIcon(lightBottomCalendar, size: 40),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(lightBottomClock, size: 40),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: ImageIcon(lightBottomSettings, size: 40),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
