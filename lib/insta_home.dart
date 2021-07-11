import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:job_seekar_app/account_setting.dart';
import 'package:job_seekar_app/app_setting.dart';
import 'package:job_seekar_app/search_screen.dart';
import 'package:motion_tab_bar/MotionTabController.dart';

import 'insta_body.dart';

class InstaHome extends StatefulWidget {
  @override
  _InstaHomeState createState() => _InstaHomeState();

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
}

class _InstaHomeState extends State<InstaHome> with TickerProviderStateMixin {
  MotionTabController _tabController;
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // _tabController = new MotionTabController(initialIndex: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    // _tabController.dispose();
  }

  // int _currentIndex = 0;
  final List<Widget> _children = [InstaBody(), AccountSetting(), AppSetting()];

  AppBar topBar(BuildContext context) {
    return new AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1.0,
        // leading: new Icon(Icons.camera_alt),
        title: SizedBox(
            height: 35.0,
            child: Text(
              "Paper Job",
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Billabong', fontSize: 24.0),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: _currentIndex != 1 ? topBar(context) :null,
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              Container(
                child: InstaBody(),
              ),
              Container(
                child: SearchScreen(),
              ),
              Container(child: AccountSetting()),
              Container(
                child: AppSetting(),
              ),
            ],
          ),
        ), // new
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            _currentIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text('Home'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.search),
                title: Text('Search'),
                activeColor: Colors.purpleAccent),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
                activeColor: Colors.pink),
            BottomNavyBarItem(
                icon: Icon(Icons.settings),
                title: Text('Settings'),
                activeColor: Colors.blue),
          ],
        )
        // MotionTabBar(
        //   labels: ["Account", "Home", "Setting"],
        //   initialSelectedTab: "Home",
        //   tabIconColor: Colors.green,
        //   tabSelectedColor: Colors.red,
        //   onTabItemSelected: (int value) {
        //     print(value);
        //     setState(() {
        //       _tabController.index = value;
        //     });
        //   },
        //   icons: [Icons.person, Icons.home, Icons.settings],
        //   textStyle: TextStyle(color: Colors.red),
        );
    // body: MotionTabBarView(
    //   controller: _tabController,
    //   children: <Widget>[

    //   ],
    // ));

    //   BottomNavigationBar(
    //       onTap: onTabTapped, // new
    //       currentIndex: _currentIndex, // new
    //       items: [
    //         BottomNavigationBarItem(
    //           icon: new Icon(Icons.home),
    //           title: new Text('Home'),
    //         ),
    //         BottomNavigationBarItem(
    //             icon: Icon(Icons.person), title: Text('Profile')),
    //         BottomNavigationBarItem(
    //           icon: new Icon(Icons.settings),
    //           title: new Text('Setting'),
    //         ),
    //       ]),
    // );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
