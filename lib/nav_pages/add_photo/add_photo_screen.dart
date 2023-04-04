
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:social_network/storage/storage_connection.dart';
import 'package:social_network/pick_image.dart';
import 'package:social_network/errors_display/snackbar.dart';
import 'package:social_network/cubit/posts_cubit.dart';
import 'package:provider/provider.dart';
import 'package:social_network/providers/user_provider.dart';

class AddPhoto extends StatefulWidget {
  const AddPhoto({super.key});

  @override
  _AddPhotoState createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  late final user;
  Uint8List? _imageFile;
  bool _loading = false;
  final TextEditingController _captionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _imageFile = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _imageFile = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      _loading = true;
    });
    try {
      String res = await PostsCubit().uploadPost(
        _imageFile!,
        uid,
        username,
        profImage,
        _captionController.text,
      );
      if (res == "success") {
        setState(() {
          _loading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        _loading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  void initState(){
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false);
    user.fetchUser();
  }

  @override
  void dispose() {
    user.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _imageFile == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.add_a_photo_outlined,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Creating a post'),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () {
                    postImage(
                      user.uid,
                      user.username,
                      user.profilePic,
                    );
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.blue[500],
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                _loading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(top: 0),
                      ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(user.profilePic),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              user.username,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(_imageFile!),
                                fit: BoxFit.cover,
                                alignment: FractionalOffset.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextField(
                      controller: _captionController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none),
                    ),
                  ),
                ),
                const Divider(),
              ],
            ));
  }
}
