import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'about_us.dart';
import 'signin.dart';
import 'signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeBite',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _pages = [
    WelcomePage(),
    AboutPage(),
    SignInPage(),
    SignUpPage(),
  ];

  final List<String> _titles = ['Welcome', 'About us', 'Sign In', 'Sign Up'];

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
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          title: Text(
            _titles[_selectedIndex],
            style: TextStyle(color: Colors.white),
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
          elevation: 100,
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),

      drawer: Drawer(
        child: Container(
          color: const Color.fromARGB(255, 87, 111, 229),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'SafeBite',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 35,
                  ),
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 116, 19, 201),
                ),
              ),
              ListTile(
                title: Text('Welcome', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _onItemTapped(0);
                },
              ),
              ListTile(
                title: Text('About us', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _onItemTapped(1);
                },
              ),
              ListTile(
                title: Text('Sign In', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _onItemTapped(2);
                },
              ),
              ListTile(
                title: Text('Sign Up', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _onItemTapped(3);
                },
              ),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
