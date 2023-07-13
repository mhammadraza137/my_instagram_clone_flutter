
import 'package:flutter/material.dart';

class TextFieldFocusProvider extends ChangeNotifier {
  bool _emailFocus = false;
  bool _passwordFocus = false;
  bool _passwordToggle = true;
  bool _usernameFocus = false;
  bool _bioFocus = false;

  bool get bioFocus{
    return _bioFocus;
  }
  set bioFocus(bool value) {
    _bioFocus = value;
    notifyListeners();
  }

  bool get usernameFocus{
    return _usernameFocus;
  }
  set usernameFocus(bool value){
    _usernameFocus = value;
    notifyListeners();
  }

  bool get emailFocus {
    return _emailFocus;
  }
  set emailFocus(bool value) {
    _emailFocus = value;
    notifyListeners();
  }
  bool get passwordFocus {
    return _passwordFocus;
  }
  set passwordFocus(bool value) {
    _passwordFocus = value;
    notifyListeners();
  }
  bool get passwordToggle {
    return _passwordToggle;
  }
  void setPasswordToggle(){
    _passwordToggle = !_passwordToggle;
    notifyListeners();
  }
}