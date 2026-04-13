import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'about_us.dart';
import 'signin.dart';
import 'signup.dart';
import 'dashboard.dart';
import 'theme.dart';
import 'background.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeBite',
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return AppBackground(child: child!);
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _isLoggedIn = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> get _pages => [
    _isLoggedIn ? const DashboardPage() : WelcomePage(),
    AboutPage(),
    SignInPage(),
    SignUpPage(),
  ];

  List<String> get _titles => [
    _isLoggedIn ? 'Dashboard' : 'Welcome',
    'About us',
    'Sign In',
    'Sign Up',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: AppBar(
          title: Text(
            _titles[_selectedIndex],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(color: Color(0xFFA855F7), blurRadius: 16),
                Shadow(color: Colors.white38, blurRadius: 8),
              ],
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              child: Image.asset('assets/images/icon.png'),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0F0A2A), Color(0xFF07091A)],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 44, 10, 99),
                      Color.fromARGB(255, 53, 32, 185),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  'SafeBite',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: Colors.white.withOpacity(0.8),
                        blurRadius: 16,
                      ),
                      const Shadow(color: Color(0xFFA855F7), blurRadius: 32),
                    ],
                  ),
                ),
              ),
              _drawerItem(_isLoggedIn ? 'Dashboard' : 'Welcome', 0),
              _drawerItem('About us', 1),
              _drawerItem('Sign In', 2),
              _drawerItem('Sign Up', 3),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  Widget _drawerItem(String label, int index) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          shadows: isSelected
              ? [
                  const Shadow(color: Color(0xFFA855F7), blurRadius: 12),
                  Shadow(color: Colors.white.withOpacity(0.5), blurRadius: 6),
                ]
              : null,
        ),
      ),
      tileColor: isSelected
          ? Colors.white.withOpacity(0.06)
          : Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () => _onItemTapped(index),
    );
  }
}
