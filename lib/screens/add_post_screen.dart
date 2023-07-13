import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../utils/colors.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;


  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  pickImage(ImageSource source) async{
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if(file!=null){
      return file.readAsBytes();
    }
    else{
      print('no image selected');
    }
  }
  postImage(
      String uid,
      String username,
      String profileImg
      ) async{
    setState(() {
      _isLoading = true;
    });
    try{
      String res = await FireStoreMethods().uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profileImg);
      if(res=='success')
        {
          setState(() {
            _descriptionController.clear();
            _isLoading = false;
          });
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Posted')));
          clearImage();
        }
      else{
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  void clearImage(){
    setState(() {
      _file = null;
    });
  }

  _selectImage(BuildContext context){
    return showDialog(context: context, builder: (context) => SimpleDialog(
      title: const Text('Create a post'),
      children: [
        SimpleDialogOption(
          padding: const EdgeInsets.all(20),
          child: const Text('Take a photo'),
          onPressed: () async{
            Navigator.of(context).pop();
            Uint8List file = await pickImage(ImageSource.camera);
            setState(() {
              _file = file;
            });
          },
        ),
        SimpleDialogOption(
          padding: const EdgeInsets.all(20),
          child: const Text('Choose from gallery'),
          onPressed: () async{
            Navigator.of(context).pop();
            Uint8List file = await pickImage(ImageSource.gallery);
            setState(() {
              _file = file;
            });
          },
        ),
        SimpleDialogOption(
          padding: const EdgeInsets.all(20),
          child: const Text('Cancel'),
          onPressed: (){
            Navigator.of(context).pop();
          },
        )
      ],
    ),);
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file==null?  Center(
      child: IconButton(
          onPressed: () {
            _selectImage(context);
          },
          icon: Icon(Icons.upload)),
    ) :
    Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
            onPressed: clearImage,
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: const Text(
          'Post to',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              postImage(user.uid, user.username, user.photoUrl);
            },
            child: const Text(
              'Post',
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          _isLoading? const LinearProgressIndicator() : const Padding(padding: EdgeInsets.only(top: 0)),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.photoUrl,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Write a caption...',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                width: 45,
                height: 45,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(_file!),
                    fit: BoxFit.fill,
                      alignment: FractionalOffset.topCenter
                    ),
                  ),
                ),
              ),
              Divider()
            ],
          )
        ],
      ),
    );
  }
}
