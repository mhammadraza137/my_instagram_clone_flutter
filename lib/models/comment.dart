
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String profileImg;
  final String username;
  final String uid;
  final String comment;
  final String commentId;
  final datePublished;

  Comment({
    required this.profileImg,
    required this.username,
    required this.uid,
    required this.comment,
    required this.commentId,
    required this.datePublished
  });
  Map<String , dynamic> toJson() {
    return {
      'profileImg' : profileImg,
      'username' : username,
      'uid' : uid,
      'comment' : comment,
      'commentId' : commentId,
      'datePublished' : datePublished
    };
  }
  static Comment fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String , dynamic>;
    return Comment(
        profileImg: snap['profileImg'],
        username: snap['username'],
        uid: snap['uid'],
        comment: snap['comment'],
        commentId: snap['commentId'],
        datePublished: snap['datePublished'],
    );
  }

}