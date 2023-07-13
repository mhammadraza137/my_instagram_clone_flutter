import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_Screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int postLength = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot<Map<String, dynamic>> postSnap = await FirebaseFirestore
          .instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLength = postSnap.docs.length;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
    setState(() {
      isLoading = false;
    });
  }

  showSignOutAlertDialogue(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Do you want to sign out?'),
        actions: [
          TextButton(onPressed: () async{
            Navigator.pop(context);
            await AuthMethods().signOut();
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
          },
              child: const Text('Yes')),
          TextButton(onPressed: (){
            Navigator.pop(context);
          },
              child: const Text('No'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.uid)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.white,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              else if(!snapshot.hasData || !snapshot.data!.exists){
                return Center(
                  child: Text('data doesnot exist'),
                );
              }
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: primaryColor,
                  elevation: 0,
                  title: Text(
                    snapshot.data!['username'],
                    style: const TextStyle(color: Colors.black),
                  ),
                  actions: [
                    widget.uid == FirebaseAuth.instance.currentUser!.uid
                        ? Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: PopupMenuButton(
                              onSelected: (value) {
                                if(value==1){
                                  showSignOutAlertDialogue(context);
                                }
                              },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem(
                                      padding: EdgeInsets.all(5),
                                      height: double.minPositive,
                                      value: 1,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.login,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            'Sign Out',
                                            style: TextStyle(fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                child: const Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                )))
                        : Container()
                  ],
                ),
                body: ListView(children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data!['photoUrl']),
                              radius: 40,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildStatWidget(postLength, 'Posts'),
                                  buildStatWidget(
                                      snapshot.data!['followers'].length,
                                      'Followers'),
                                  buildStatWidget(
                                      snapshot.data!['following'].length,
                                      'Following')
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(top: 15, left: 10),
                          child: Text(
                            snapshot.data!['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 10, top: 1),
                          child: Text(snapshot.data!['bio']),
                        ),
                        FirebaseAuth.instance.currentUser!.uid == widget.uid
                            ? FollowButton(
                                onPressed: () {},
                                backgroundColor: primaryColor,
                                borderColor: Colors.grey,
                                text: 'Edit Profile',
                                textColor: Colors.black)
                            : snapshot.data!['followers'].contains(
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? FollowButton(
                                    onPressed: () async {
                                      await FireStoreMethods().followUser(
                                          uid: FirebaseAuth
                                              .instance.currentUser!.uid,
                                          followUid: widget.uid);
                                      // setState(() {
                                      //   isFollowing = false;
                                      // });
                                    },
                                    backgroundColor: primaryColor,
                                    borderColor: Colors.grey,
                                    text: 'Unfollow',
                                    textColor: Colors.black,
                                  )
                                : FollowButton(
                                    onPressed: () async {
                                      await FireStoreMethods().followUser(
                                          uid: FirebaseAuth
                                              .instance.currentUser!.uid,
                                          followUid: widget.uid);
                                      // setState(() {
                                      //   isFollowing = true;
                                      // });
                                    },
                                    backgroundColor: blueColor,
                                    borderColor: blueColor,
                                    text: 'Follow',
                                    textColor: Colors.white),
                      ],
                    ),
                  ),
                  const Divider(),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap = snapshot.data!.docs[index];
                          return Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          );
                        },
                      );
                    },
                  )
                ]),
              );
            },
          );
  }

  Column buildStatWidget(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
        )
      ],
    );
  }
}
