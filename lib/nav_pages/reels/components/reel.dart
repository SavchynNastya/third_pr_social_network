import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class Reel extends StatefulWidget {
  final String username;
  final String videoUrl;

  const Reel({super.key, required this.username, required this.videoUrl});

  @override
  State<Reel> createState() => _ReelState();
}

class _ReelState extends State<Reel>{

  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  double _aspectRatio = 16 / 9;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      allowedScreenSleep: false,
      allowFullScreen: true,
      aspectRatio: _aspectRatio,
      autoInitialize: true,
      showOptions: false,
      showControls: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      height: screenSize.height - 60,
      child: Stack(
        children: [
          Chewie(controller: _chewieController),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 124, 124, 124),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            widget.username,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side:
                                const BorderSide(width: 1, color: Colors.white),
                            padding: const EdgeInsets.only(left: 7, right: 7),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Follow',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.favorite_outline,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '54',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '10',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.navigation_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ],
      )
      // Row(
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(10),
      //       child: 
      //         Row(children: [
      //         Container(
      //           width: 40,
      //           height: 40,
      //           decoration: const BoxDecoration(
      //             shape: BoxShape.circle,
      //             color: Color.fromARGB(255, 124, 124, 124),
      //           ),
      //         ),
      //         const SizedBox(
      //           width: 10,
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.only(right: 20),
      //           child: Text(username, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      //         ),
      //         OutlinedButton(
      //           style: OutlinedButton.styleFrom(
      //             backgroundColor: Colors.transparent, 
      //             side: const BorderSide(width: 1, color: Colors.white),
      //             padding: const EdgeInsets.only(left: 7, right: 7),
      //           ),
      //           onPressed: () {},
      //           child: const Text(
      //             'Follow',
      //             style: TextStyle(fontSize: 16, color: Colors.white),
      //           ),
      //         ),
      //       ],),
      //     ),
      //     Column(
      //       crossAxisAlignment: CrossAxisAlignment.end,
      //       mainAxisAlignment: MainAxisAlignment.end,
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.all(10),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: const [
      //               Icon(Icons.favorite_outline, color: Colors.white,),
      //               SizedBox(height: 5,),
      //               Text('54', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),),
      //             ],
      //           ),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.all(10),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: const [
      //               Icon(Icons.mode_comment_outlined, color: Colors.white,),
      //               SizedBox(height: 5,),
      //               Text('10', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white),),
      //             ],
      //           ),
      //         ),
      //         const Padding(
      //           padding: EdgeInsets.all(10),
      //           child: Icon(Icons.navigation_outlined, color: Colors.white,),
      //         ),
      //       ],
      //     )
      //   ],
      // ),
    );
  }
}