import 'package:flutter/material.dart';
import 'package:sqlite/JsonAPI/homepage.dart';
import 'package:sqlite/JsonAPI/postpage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    PostPage(),
    Placeholder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      backgroundColor: Colors.transparent,
      bottomNavigationBar: 
          BottomNavigationBar(
            elevation: 0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                  backgroundColor: Colors.transparent),
              BottomNavigationBarItem(
                icon: Icon(Icons.post_add),
                label: "Posts",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.abc_sharp),
                label: "Paceholder",
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
            onTap: _onItemTapped,
          ),
    );
  }
}