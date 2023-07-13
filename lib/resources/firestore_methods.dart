
import 'dart:typed_data';
import 'package:instagram_clone/models/comment.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class FireStoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
      String description,
      Uint8List file,
      String uid,
      String username,
      String profileImg,
      ) async{
    String res = 'some error occurred';
    try{
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          profileImg: profileImg,
          likes: []);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    }catch(e){
      res = e.toString();
    }
    return res;
  }
  Future<void> likePost(String postId , String uid , List likes) async{
    try{
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes' : FieldValue.arrayRemove([uid])
        });
      }
      else{
        await _firestore.collection('posts').doc(postId).update({
          'likes' : FieldValue.arrayUnion([uid])
        });
      }
    }catch(e){
      print(e.toString());
    }
  }
  Future<String> postComment(String postId , String commentTxt , String uid , String username , String profileImg) async{
    String res = 'some error occurred';
    try{
      if(commentTxt.isNotEmpty){
        String commentId = const Uuid().v1();
        Comment comment = Comment(
            profileImg: profileImg,
            username: username,
            uid: uid,
            comment: commentTxt,
            commentId: commentId,
            datePublished: DateTime.now());
       await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set(comment.toJson());
       res = 'success';
      }
      else {
        res = 'Comment cannot be empty';
      }

    }catch(e){
      print(e.toString());
      res = e.toString();
    }
    return res;
  }
  Future<String> deletePost(String postId) async{
    String res = 'some error occurred';
    try{
    await _firestore.collection('posts').doc(postId).delete();
    res = 'success';
  }
    catch(e){
    res = e.toString();
    }
    return res;
  }
  Future<void> followUser( {required String uid , required String followUid}) async{
    try{
      DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
      List following = (snapshot.data()! as dynamic)['following'];
      if(following.contains(followUid)){
        await _firestore.collection('users').doc(followUid).update({
          'followers' : FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayRemove([followUid])
        });
      }
      else {
        await _firestore.collection('users').doc(followUid).update({
          'followers' : FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'following' : FieldValue.arrayUnion([followUid])
        });
      }

    }catch(e){
      print(e.toString());
    }
  }
}
