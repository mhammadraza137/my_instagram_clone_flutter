
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier {
  User? _user = const User(
      email: 'email',
      uid: 'uid',
      photoUrl: 'photoUrl',
      username: 'username',
      bio: 'bio',
      followers: [],
      following: []);
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async{
    User user =await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}