import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/provider/text_field_focused_provider.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/my_filled_button.dart';
import 'package:instagram_clone/widgets/my_text_form_field.dart';
import 'package:provider/provider.dart';

class SignupMainScreen extends StatefulWidget {
  const SignupMainScreen({super.key});

  @override
  State<SignupMainScreen> createState() => _SignupMainScreenState();
}

class _SignupMainScreenState extends State<SignupMainScreen> {
  final TextEditingController _usernameTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _bioTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
  TextEditingController();
  Uint8List? _image;
  String res = 'error occurred.';

  @override
  void dispose() {
    super.dispose();
    _usernameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _bioTextEditingController.dispose();
    _emailTextEditingController.dispose();
  }

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    print('no image selected');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TextFieldFocusProvider>(
      builder: (context, textFieldFocus, child) => Scaffold(
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      'https://s3.amazonaws.com/37assets/svn/765-default-avatar.png'),
                                ),
                          Positioned(
                              bottom: 0,
                              right: -5,
                              child: IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25,
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              title: const Text('From camera'),
                                              trailing: const Icon(
                                                  Icons.camera_alt_outlined),
                                              onTap: () async {
                                                Uint8List image =
                                                    await pickImage(
                                                        ImageSource.camera);
                                                setState(() {
                                                  _image = image;
                                                });
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            SizedBox(
                                              height: 1,
                                              width: double.infinity,
                                              child: Container(
                                                color: Colors.grey.shade200,
                                              ),
                                            ),
                                            ListTile(
                                              title: const Text('From gallery'),
                                              trailing: const Icon(Icons
                                                  .browse_gallery_outlined),
                                              onTap: () async {
                                                Uint8List image =
                                                    await pickImage(
                                                        ImageSource.gallery);
                                                setState(() {
                                                  _image = image;
                                                });
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: blueColor,
                                  )))
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextFormField(
                    label: 'email',
                    onFocusChange: (value) {
                      textFieldFocus.emailFocus = value;
                    },
                    borderColor: textFieldFocus.emailFocus,
                    isPassword: false,
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailTextEditingController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextFormField(
                    label: 'username',
                    onFocusChange: (value) {
                      textFieldFocus.usernameFocus = value;
                    },
                    borderColor: textFieldFocus.usernameFocus,
                    isPassword: false,
                    textInputType: TextInputType.text,
                    textEditingController: _usernameTextEditingController,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextFormField(
                    label: 'password',
                    onFocusChange: (value) {
                      textFieldFocus.passwordFocus = value;
                    },
                    borderColor: textFieldFocus.passwordFocus,
                    isPassword: true,
                    textInputType: TextInputType.text,
                    textEditingController: _passwordTextEditingController,
                    onPressedPasswordToggle: () {
                      textFieldFocus.setPasswordToggle();
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MyTextFormField(
                    label: 'bio',
                    onFocusChange: (value) {
                      textFieldFocus.bioFocus = value;
                    },
                    borderColor: textFieldFocus.bioFocus,
                    isPassword: false,
                    textInputType: TextInputType.text,
                    textEditingController: _bioTextEditingController,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyFilledButton(
                    title: 'Sign up',
                    onPressed: () async {
                      if(_image != null)
                        {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(
                                color: blueColor,
                              ),
                            ),
                          );
                          res = await AuthMethods().signUpUser(
                              email: _emailTextEditingController.text,
                              username: _usernameTextEditingController.text,
                              password: _passwordTextEditingController.text,
                              bio: _bioTextEditingController.text,
                              file: _image!);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                          if(res=='success') {

                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen(),));
                          }

                        }
                      else
                        {
                          res = 'upload image';
                        }
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(res)));
                    },
                  )
                ],
              )),
        ),
      ),
    );
  }
}
