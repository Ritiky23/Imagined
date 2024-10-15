import 'package:flutter/material.dart';
import 'WeightListScreen.dart'; // Import your WeightListScreen
import 'SettingsScreen.dart';   // Import your SettingsScreen
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    WeightListScreen(), // Add your Weight List screen here
    SettingsScreen(),   // Add your Settings screen here
  ];

  void _onItemTapped(int index) {
    
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1584A3), // Sky blue background color for the bottom navigation bar
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),  // Top left rounded corner
            topRight: Radius.circular(20), // Top right rounded corner
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Add shadow effect
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent, // Background already applied through Container
          elevation: 0, // Remove elevation (shadow)
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Weights',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white, // White color for selected items
          unselectedItemColor: Colors.white.withOpacity(0.7), // White with opacity for unselected items
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed, // To keep the labels visible
        ),
      ),
    );
  }
}
