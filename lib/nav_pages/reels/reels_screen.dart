import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_network/nav_pages/reels/components/reel.dart';
import 'package:social_network/errors_display/snackbar.dart';
import 'package:social_network/pick_image.dart';
import 'package:image_picker/image_picker.dart';

import '../../cubit/reel_state.dart';
import '../../cubit/reels_cubit.dart';
import '../../providers/user_provider.dart';

class Reels extends StatefulWidget {
  const Reels({super.key});

  @override
  State<Reels> createState() => _ReelsState();
}

class _ReelsState extends State<Reels> {
  late final UserProvider user;
  List videoUrls = [];

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false);
    user.fetchUser();
    // fetchVideos();
  }

  // dynamic parseJson(String responseBody){
  //   final jsonBody = json.decode(responseBody);
  //   final List<dynamic> videos = jsonBody['videos'];
  //   return videos
  //         .map((video) => '${video['video_files'][0]['link']}')
  //         .toList();
  // }

  // Future<void> fetchVideos() async {
  //   final response = await http.get(
  //       Uri.parse('https://api.pexels.com/videos/search?query=spring&per_page=3&page=1'),
  //                 headers: {'Authorization': '563492ad6f9170000100000102da905b8a4c42738c484891922b2be4'});
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       videoUrls = parseJson(response.body);
  //     });
  //     print(videoUrls);
  //   } else {
  //     print('Failed to fetch videos');
  //   }
  // }

  final PageController _pageController = PageController();

  Uint8List? _file;
  bool _loading = false;

  _selectVideo(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Reel'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Film a video'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickVideo(ImageSource.camera);
                  // File file = File.fromRawPath(bytes);
                  setState(() {
                    _file = file;
                  });
                  postVideo(user.uid, user.username, user.profilePic);
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickVideo(ImageSource.gallery);
                  // File file = File.fromRawPath(bytes);
                  setState(() {
                    _file = file;
                  });
                  postVideo(user.uid, user.username, user.profilePic);
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

  void clearVideo() {
    setState(() {
      _file = null;
    });
  }

  void postVideo(String uid, String username, String profImage) async {
    setState(() {
      _loading = true;
    });
    try {
      String res = await ReelCubit().addReel(
        _file!,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          _loading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearVideo();
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
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reels',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => _selectVideo(context),
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
      // body: PageView(
      //   scrollDirection: Axis.vertical,
      //   controller: _pageController,
      //   padEnds: false,
      //   children: reels,
      // ),
      body: StreamBuilder<ReelState>(
        stream: context.read<ReelCubit>().getReelsStreamByUserId(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData && snapshot.data is ReelLoaded) {
            final reels = (snapshot.data as ReelLoaded).reels;
            if (reels == null || reels.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No reels yet',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                      onPressed: () => _selectVideo(context),
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Color.fromARGB(255, 60, 57, 221)),
                      ),
                    )
                  ],
                ),
              );
            }
            final reelsCards = reels.map((item) => Reel(reel: item)).toList();
            return PageView(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              padEnds: false,
              children: reelsCards,
            );
          } else if (snapshot.hasData && snapshot.data is ReelError) {
            return Center(child: Text((snapshot.data as ReelError).message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
