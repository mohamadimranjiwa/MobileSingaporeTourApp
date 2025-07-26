import 'package:flutter/material.dart';
import 'package:kuantan_tour_app/Views/bookingpage.dart';
import 'package:kuantan_tour_app/Views/formpage.dart';
import 'package:kuantan_tour_app/Views/homepage.dart';
import 'package:kuantan_tour_app/Views/myhomepage.dart';
import 'package:kuantan_tour_app/Views/packages.dart';
import 'package:kuantan_tour_app/Views/profilepage.dart';
import 'package:kuantan_tour_app/Views/ratingspage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const appTitle = 'VISIT SINGAPORE!';
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: Userui(title: appTitle),
    );
  }
}

class Userui extends StatefulWidget {
  const Userui({super.key, required this.title});
  final String title;
  @override
  State<Userui> createState() => _UseruiState();
}

class _UseruiState extends State<Userui> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static final List<Widget> _widgetOptions = <Widget>[
    const Text(
      'Singapore Attractions',
      style: optionStyle,
    ), // Display HomePage here
    const Text(
      'Book Our Packages',
      style: optionStyle,
    ),
    const Text(
      'Our Packages',
      style: optionStyle,
    ),
    const Text(
      'Ratings and Reviews',
      style: optionStyle,
    ),
    const Text(
      'Logout',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BookingPage()));
            },
            icon: const Icon(Icons.shopping_cart_sharp),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
            icon: const Icon(Icons.person),
          )
        ],
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'VISIT SINGAPORE!',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.deepPurple,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            ListTile(
              title: const Text("Singapore Attractions"),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            ListTile(
              title: const Text('Book Our Packages'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FormPage()));
              },
            ),
            ListTile(
              title: const Text('Our Packages'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Packages()));
              },
            ),
            ListTile(
              title: const Text('Ratings and Reviews'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RatingsPage()));
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              selected: _selectedIndex == 4,
              onTap: () async {
                _onItemTapped(4);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('id');

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(
                      title: 'VISIT SINGAPORE!',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
