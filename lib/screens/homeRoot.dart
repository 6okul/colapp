import 'package:colapp/screens/account/accountScreen.dart';
import 'package:colapp/screens/find/findScreen.dart';
import 'package:colapp/screens/home/homeScreen.dart';
import 'package:colapp/screens/project/add/createProject.dart';
import 'package:flutter/material.dart';

class HomeRoot extends StatefulWidget {
  @override
  _HomeRootState createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              padding: EdgeInsets.only(right: 20),
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateProjectScreen()));
              }),
          IconButton(
              padding: EdgeInsets.only(right: 20),
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FindScreen()));
              })
        ],
        automaticallyImplyLeading: false,
        title: Image(
          image: AssetImage("assets/logo.png"),
          height: 50,
        ),
      ),
      body: Container(
        child: IndexedStack(
          index: _selectedIndex,
          children: [HomeScreen(), AccountScreen()],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        type: BottomNavigationBarType.shifting,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: "Explore",
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Account",
              backgroundColor: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
