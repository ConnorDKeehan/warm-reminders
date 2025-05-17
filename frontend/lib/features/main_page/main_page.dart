import 'package:flutter/material.dart';
import 'package:warmreminders/features/remembers_page/remembers_page.dart';
import 'package:warmreminders/features/reminders_page/reminders_page.dart';
import 'package:warmreminders/features/schedules_page/schedules_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    RemembersPage(),
    RemindersPage(),
    SchedulesPage()

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Color(0xFF0a0a0a),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today_outlined),
            label: 'Remembers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Schedules',
          ),
        ],
      ),
    ));
  }
}
