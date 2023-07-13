import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/utils/global_variables.dart' as my;
import 'package:provider/provider.dart';

class ResponsiveLayoutScreen extends StatefulWidget {
  final Widget mobileScreenLayout;
  final Widget webScreenLayout;
  const ResponsiveLayoutScreen({Key? key,required this.mobileScreenLayout , required this.webScreenLayout}) : super(key: key);

  @override
  State<ResponsiveLayoutScreen> createState() => _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {


  @override
  Widget build(BuildContext context) {
    return  LayoutBuilder(
        builder: (context, constraints) {
          if(constraints.maxWidth > my.webScreenSize)
            {
              return widget.webScreenLayout;
            }
          return widget.mobileScreenLayout;
        } ,);
  }

  @override
  void initState() {
    super.initState();
    // addData();
  }
  // void addData() async{
  //   UserProvider userProvider = Provider.of<UserProvider>(context , listen: false);
  //   await userProvider.refreshUser();
  // }
}
