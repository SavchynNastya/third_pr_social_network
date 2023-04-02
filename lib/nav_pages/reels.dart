import 'package:flutter/material.dart';
import 'package:social_network/nav_pages/components/reel.dart';
import 'package:social_network/errors_display/snackbar.dart';
import 'dart:typed_data';
import 'package:social_network/pick_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network/models/reel.dart';
import 'package:social_network/models/reels_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Reels extends StatefulWidget{
  final List usernames;
  Reels({super.key, required this.usernames});


  @override
  State<Reels> createState() => _ReelsState();

}

class _ReelsState extends State<Reels>{
  List videoUrls = [];

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  dynamic parseJson(String responseBody){
    final jsonBody = json.decode(responseBody);
    final List<dynamic> videos = jsonBody['videos'];
    return videos
          .map((video) => '${video['video_files'][0]['link']}')
          .toList();
  }

  Future<void> fetchVideos() async {
    final response = await http.get(
        Uri.parse('https://api.pexels.com/videos/search?query=spring&per_page=3&page=1'),
                  headers: {'Authorization': '563492ad6f9170000100000102da905b8a4c42738c484891922b2be4'}); 
    if (response.statusCode == 200) {
      setState(() {
        videoUrls = parseJson(response.body);
      });
      print(videoUrls);
    } else {
      print('Failed to fetch videos');
    }
  }

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
                  // Navigator.pop(context);
                  // Uint8List file = await pickVideo(ImageSource.camera);
                  // setState(() {
                  //   _file = file;
                  // });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  // Navigator.of(context).pop();
                  // Uint8List file = await pickVideo(ImageSource.gallery);
                  // setState(() {
                  //   _file = file;
                  // });
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
      String res = await ReelsModel().uploadReel(
        _file!,
        uid,
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
    print(videoUrls.length);
    final List<Widget> reels = List.generate(videoUrls.length, (index) {
      return Reel(username: widget.usernames[index], videoUrl: videoUrls[index]);
    });
    print(reels);

    return reels.isEmpty ?
    Center(
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
            child: Text(
              'Add',
              style: TextStyle(color: Color.fromARGB(255, 60, 57, 221)),
            ),
          )
        ],
      ),
    )
    :
    Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reels', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              // Icon(Icons.camera_alt_outlined, color: Colors.white,),
              IconButton(
                onPressed: () => _selectVideo(context),
                icon: Icon(Icons.camera_alt_outlined, color: Colors.white,),
              )
            ],
          ),
        ),
      ),
      body: PageView(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        padEnds: false,
        children: reels,
      ),
    );
  }
}