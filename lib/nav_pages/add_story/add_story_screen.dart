import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/pick_image.dart';
import 'package:social_network/nav_pages/add_story/components/camera_button.dart';
import 'package:social_network/errors_display/snackbar.dart';
import 'package:social_network/providers/user_provider.dart';
import 'package:social_network/providers/story_provider.dart';

class AddStory extends StatefulWidget {
  const AddStory({super.key});

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  late final user;
  Uint8List? _imageFile;

  void clearImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void postStory(String uid, String username, String profImage) async {
    try {
      String res = await StoriesProvider().uploadStory(
        _imageFile!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
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
    return GestureDetector(
      onVerticalDragUpdate: (details) async {
        if (details.delta.dy < 20) {
          Uint8List file = await pickImage(ImageSource.gallery);
          setState(() {
            _imageFile = file;
          });
        }
      },
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx < 0) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: const Text('Creating a story'),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: () {
                postStory(
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
            Expanded(
              child: Center(
                child: _imageFile != null
                    ? Image.memory(_imageFile!)
                    : const Text('No image selected.'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _imageFile == null
                    ? InstagramCameraButton(
                        onPressed: () async {
                          Uint8List file = await pickImage(ImageSource.camera);
                          setState(() {
                            _imageFile = file;
                          });
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          clearImage();
                        },
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
