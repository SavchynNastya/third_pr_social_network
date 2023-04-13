import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/nav_pages/feed/components/open_comments.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../../cubit/reels_cubit.dart';
import '../../../errors_display/snackbar.dart';
import '../../../models/reel.dart';

class Reel extends StatefulWidget {
  final ReelItem reel;

  const Reel({super.key, required this.reel});

  @override
  State<Reel> createState() => _ReelState();
}

class _ReelState extends State<Reel>{
  bool _loading = false;
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  final double _aspectRatio = 9 / 16;

  late StreamSubscription<List<dynamic>> _commentsSubscription;

  List comments = [];

  void deleteReel() async {
    setState(() {
      _loading = true;
    });
    try {
      String res = await ReelCubit().deleteReel(widget.reel.reelId);
      if (res == "success") {
        setState(() {
          _loading = false;
        });
        showSnackBar(
          context,
          'Reel has been successfully deleted.',
        );
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
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.reel.reelUrl);
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
    _commentsSubscription = context
        .read<ReelCubit>()
        .fetchReelComments(widget.reel.reelId)
        .listen((comments) {
      setState(() {
        this.comments = comments;
      });
    });
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
    return SizedBox(
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
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(widget.reel.profImage),
                            )
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            widget.reel.username,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        // OutlinedButton(
                        //   style: OutlinedButton.styleFrom(
                        //     backgroundColor: Colors.transparent,
                        //     side:
                        //         const BorderSide(width: 1, color: Colors.white),
                        //     padding: const EdgeInsets.only(left: 7, right: 7),
                        //   ),
                        //   onPressed: () {},
                        //   child: const Text(
                        //     'Follow',
                        //     style: TextStyle(fontSize: 16, color: Colors.white),
                        //   ),
                        // ),
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
                          children: [
                            IconButton(
                              // icon: Icon(Icons.favorite_outline),
                              icon: widget.reel.likes.contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? Icon(Icons.favorite, color: Colors.red[900])
                                  : const Icon(Icons.favorite_outline),
                              onPressed: () => context.read<ReelCubit>().likeReel(widget.reel.reelId),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${widget.reel.likes.length}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            IconButton(
                              onPressed: (){
                                Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => OpenComments(postId: widget.reel.reelId, isReel: true,))
                                );
                              },
                              icon: const Icon(Icons.mode_comment_outlined),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${widget.reel.comments.length}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Icon(
                              Icons.navigation_outlined,
                              color: Colors.white,
                            ),
                            IconButton(
                              onPressed: deleteReel,
                              icon: const Icon(Icons.delete_outline_rounded),
                            )
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(10),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       IconButton(
                      //         onPressed: (){
                      //           Navigator.push(context, 
                      //             MaterialPageRoute(builder: (context) => OpenComments(postId: widget.reel.reelId))
                      //           );
                      //         },
                      //         icon: Icon(Icons.mode_comment_outlined),
                      //       ),
                      //       SizedBox(
                      //         height: 5,
                      //       ),
                      //       Text(
                      //         '${widget.reel.comments.length}',
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w400,
                      //             color: Colors.white),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.all(10),
                      //   child: Icon(
                      //     Icons.navigation_outlined,
                      //     color: Colors.white,
                      //   ),
                      // ),
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