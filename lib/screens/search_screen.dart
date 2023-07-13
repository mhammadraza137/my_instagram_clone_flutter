import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          elevation: 0,
          title: TextFormField(
            controller: _searchController,
            decoration: const InputDecoration(labelText: 'Search for a user'),
            onFieldSubmitted: (value) {
              if(_searchController.text.isNotEmpty){
                setState(() {
                  isShowUsers = true;
                });
              }
              else{
                setState(() {
                  isShowUsers = false;
                });
              }
            },
          ),
        ),
        body:isShowUsers? FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo:  _searchController.text)
              .get(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String , dynamic>>> snapshot) {
            if(!snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(snapshot.connectionState==ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                itemCount:snapshot.data!.docs.length ,
                itemBuilder: (context, index) => InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(uid: snapshot.data!.docs[index]['uid'],),));
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!.docs[index]['photoUrl']),
                    ),
                    title: Text(snapshot.data!.docs[index]['username']),
                  ),
                ),
            );
          },
        ) : FutureBuilder(
            future: FirebaseFirestore.instance.collection('posts').get(),
            builder: (context,AsyncSnapshot<QuerySnapshot<Map<String , dynamic>>> snapshot) {
              if(!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return GridView.builder(
                  itemCount:snapshot.data!.docs.length ,
                  gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3) ,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Image.network(snapshot.data!.docs[index]['postUrl'],fit: BoxFit.cover,)
                    );
                  },);
            },),
      ),
    );
  }
}
