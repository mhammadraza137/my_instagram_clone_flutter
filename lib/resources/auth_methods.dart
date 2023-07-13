import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
    User user = _auth.currentUser!;
     DocumentSnapshot snapshot = await _firestore.collection('users').doc(user.uid).get();
     // if(snapshot.data() != null){
    print('snapshot : $snapshot');

       return model.User.fromSnap(snapshot);
     // }
     // return const model.User(email: 'email', uid: 'uid', photoUrl: 'photoUrl', username: 'username', bio: 'bio', followers: [], following: []);

  }

 Future<String> signUpUser({
    required String email,
    required String username,
    required String password,
    required String bio,
    required Uint8List file,
  }) async{
   String status = 'some error occurred';
    try{
      if(email.isNotEmpty && username.isNotEmpty && password.isNotEmpty && bio.isNotEmpty && file!=null){
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        
        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        model.User user =  model.User(
          email: email,
          username: username,
          bio: bio,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          followers: [],
          following: []
        );
       await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
       status = 'success';
      }else{
        status = 'please fill all the fields.';
      }
    } on FirebaseAuthException catch(e){
      if(e.code == 'invalid-email'){
        status = 'Email is badly formated';
      }else if(e.code=='weak-password'){
        status = 'password should be at least 6 characters.';
      }else if(e.code == 'email-already-in-use'){
        status = 'This email already exists';
      }
      status = e.toString();
    }
   print(status);
   return status;
  }
  Future<String> loginUser({
    required String email,
    required String password
}) async{
   String status = 'some error occurred';
   try{
     if(email.isNotEmpty && password.isNotEmpty){
       await _auth.signInWithEmailAndPassword(email: email, password: password);
       status = 'success';
     }
     else{
       status = 'please fill all fields';
     }
   } catch (e){
     status = e.toString();
   }
   return status;
  }
  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }
}
