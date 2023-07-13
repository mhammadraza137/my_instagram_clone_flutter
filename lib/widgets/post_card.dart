import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../screens/comment_screen.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;


  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10
      ),
      child: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profileImg']),
                ),
                Expanded(
                    child: Padding(padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.snap['username'],style: const TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    )
                ),
                SizedBox(
                  child:widget.snap['uid'] == user.uid ? IconButton(
                      onPressed: (){
                        showDialog(context: context, builder: (context) => SimpleDialog(
                          children: [
                            SimpleDialogOption(
                              child: const Text('Delete'),
                              onPressed: () async{
                                String res = await FireStoreMethods().deletePost(widget.snap['postId']);
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                                if(res=='success'){
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post deleted successfully')));
                                }else {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(res)));
                                }
                              },
                            )
                          ],
                        ) ,);
                      },
                      icon:const Icon(Icons.more_vert)) : Container()
                )
              ],
            ),
          ),
          // Image Section
          GestureDetector(
            onDoubleTap: () async{
               await FireStoreMethods().likePost(
                   widget.snap['postId'],
                   user.uid,
                   widget.snap['likes']
               );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [ SizedBox(
                height: MediaQuery.of(context).size.height*0.35,
                width: double.infinity,
                child: Image(image: NetworkImage(widget.snap['postUrl']),
                  fit: BoxFit.cover,
                ),
              ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: isLikeAnimating? 1:0,
                  child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: (){
                        setState(() {
                          isLikeAnimating = false;
                        });
                    },
                      child: const Icon(Icons.favorite , color: Colors.white, size: 120,),
                  ),
                )
              ]
            ),
          ),
          // Like comment section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async{
                      await FireStoreMethods().likePost(
                          widget.snap['postId'],
                          user.uid,
                          widget.snap['likes']);
                    },
                    icon:widget.snap['likes'].contains(user.uid)? const Icon(Icons.favorite,color: Colors.red,) :
                        const Icon(Icons.favorite_outline)
                ),
              ),
              IconButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CommentScreen(snap: widget.snap),));
              },
                  icon: const Icon(Icons.comment_outlined)),
              IconButton(onPressed: (){},
                  icon: const Icon(Icons.send)),
              Expanded(child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(onPressed: (){}, icon: const Icon(Icons.bookmark_border))))
            ],
          ),
          // description and number of comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${widget.snap['likes'].length} likes',style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w800),),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black)
                          ),
                          TextSpan(
                            text: ' ${widget.snap['description']}',
                            style: const TextStyle(color: Colors.black)
                          )
                        ]
                      )),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CommentScreen(snap: widget.snap),));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').snapshots(),
                      builder: (context,AsyncSnapshot<QuerySnapshot<Map<String , dynamic>>> snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Text('Comments loading',
                            style: TextStyle(
                                color: Colors.black38
                            ),
                          );
                        }
                        return Text('View all ${snapshot.data!.docs.length} comments',
                          style: const TextStyle(
                              color: Colors.black38
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(color: Colors.black38),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
