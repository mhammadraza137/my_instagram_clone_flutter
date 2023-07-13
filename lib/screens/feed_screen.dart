import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        elevation: 0,
        title: const Image(image:  AssetImage('assets/images/instagram_text.png'),height: 45,),
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.messenger_outline,color: Colors.black,))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot<Map<String , dynamic>>> snapshot)  {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
          child: CircularProgressIndicator(),
      );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => PostCard(snap : snapshot.data!.docs[index].data()),);

          }
      ),
    );
  }
}
