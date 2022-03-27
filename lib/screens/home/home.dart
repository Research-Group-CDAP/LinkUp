import "package:flutter/material.dart";
import 'package:linkup/components/side_navbar.dart';
import 'package:linkup/constants.dart';
import 'package:linkup/screens/bookmark_jobs/bookmark_jobs_screen.dart';
import 'package:linkup/screens/jobs/jobs_screen.dart';
import 'package:linkup/screens/news_feed/news_feed_screen.dart';
import 'package:linkup/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _tabName = "Jobs";
  static const List<Widget> _widgetList = <Widget>[
    JobsScreen(),
    ProfileScreen(),
    NewsFeedScreen(),
    BookMarkedJobsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        setState(() {
          _tabName = "Jobs";
        });
        break;
      case 1:
        setState(() {
          _tabName = "Profile";
        });
        break;
      case 2:
        setState(() {
          _tabName = "News Feed";
        });
        break;
      case 3:
        setState(() {
          _tabName = "Bookmarks";
        });
        break;
      default:
        setState(() {
          _tabName = "LinkUp";
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tabName,
          style: const TextStyle(
            fontFamily: "SF-Pro",
          ),
        ),
        backgroundColor: colorDarkMidGround,
        elevation: 0.0,
      ),
      backgroundColor: colorDarkBackground,
      drawer: const SideNavbar(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colorDarkMidGround,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.badge, color: Colors.white)
                : const Icon(Icons.badge_outlined),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? const Icon(Icons.book, color: Colors.white)
                : const Icon(Icons.book_outlined, color: Colors.white),
            label: 'Applications',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? const Icon(Icons.feed, color: Colors.white)
                : const Icon(Icons.feed_outlined, color: Colors.white),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? const Icon(Icons.bookmark, color: Colors.white)
                : const Icon(Icons.bookmark_outline, color: Colors.white),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 4
                ? const Icon(Icons.person, color: Colors.white)
                : const Icon(Icons.person_outline, color: Colors.white),
            label: 'Profile',
          ),
        ],
      ),
      body: _widgetList.elementAt(_selectedIndex),
    );
  }
}
