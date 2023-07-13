import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

import 'add_post_screen.dart';
import 'feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  late PageController _pageController;
  List<Widget> homeScreenItems = [
    FeedScreen(),
    SearchScreen(),
    AddPostScreen(),
    Text('favourite'),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
  ];

  void _navigationTapped(int page){
    _pageController.jumpToPage(page);
  }
  void _onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
  void addData() async{
    UserProvider userProvider = Provider.of<UserProvider>(context , listen: false);
    await userProvider.refreshUser();
  }

  @override
  void initState() {
    super.initState();
    addData();
    _pageController = PageController();
  }


  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems ,
      ) ,
      bottomNavigationBar: BottomNavigationBar(
          onTap: _navigationTapped,
          type: BottomNavigationBarType.fixed,
          items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.home,
              color: _page==0? Colors.black : Colors.grey,
            ),
            label: '',
            backgroundColor: primaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: _page==1? Colors.black : Colors.grey
            ),
            label: '',
            backgroundColor: primaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_circle,
                color: _page==2? Colors.black : Colors.grey),
            label: '',
            backgroundColor: primaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite,
                color: _page==3? Colors.black : Colors.grey),
            label: '',
            backgroundColor: primaryColor),
        BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: _page==4? Colors.black : Colors.grey),
            label: '',
            backgroundColor: primaryColor),
      ]),
    );
  }
}
