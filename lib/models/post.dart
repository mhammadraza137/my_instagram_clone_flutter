
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/user.dart';

class Post{
  final String description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profileImg;
  final List likes;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profileImg,
    required this.likes
});
  Map<String , dynamic> toJson() {
    return{
      'description' : description,
      'uid' : uid,
      'username' : username,
      'postId' : postId,
      'datePublished' : datePublished,
      'postUrl' : postUrl,
      'profileImg' : profileImg,
      'likes' : likes
    };
  }
  static Post fromSnap(DocumentSnapshot snapshot){
    var snap = snapshot.data() as Map<String , dynamic>;
    return Post(
        description: snap['description'],
        uid: snap['uid'],
        username: snap['username'],
        postId: snap['postId'],
        datePublished: snap['datePublished'],
        postUrl: snap['postUrl'],
        profileImg: snap['profileImg'],
        likes: snap['likes']);
  }
}