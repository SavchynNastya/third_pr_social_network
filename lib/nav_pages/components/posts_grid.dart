import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:social_network/nav_pages/components/post_preview.dart';
import 'package:social_network/models/post.dart';

class PostsGrid extends StatelessWidget {
  final postsSnapshot;

  PostsGrid({super.key, required this.postsSnapshot});

  // List<StaggeredGridTile> gridTiles = List.generate(
  //   15,
  //   (index) {
  //     if (index == 2 || index == 5 || index == 12) {
  //       return StaggeredGridTile.count(
  //         crossAxisCellCount: 1,
  //         mainAxisCellCount: 2,
  //         child: Container(
  //           color: Colors.grey[300],
  //         ),
  //       );
  //     } else {
  //       return StaggeredGridTile.count(
  //         crossAxisCellCount: 1,
  //         mainAxisCellCount: 1,
  //         child: Container(
  //           color: Colors.grey[300],
  //         ),
  //       );
  //     }
  //   },
  // );

  // // List<StaggeredGridTile> gridTemplate = [
  // //   StaggeredGridTile.count(
  // //     crossAxisCellCount: 1,
  // //     mainAxisCellCount: 1,
  // //     child: Container(
  // //       color: Colors.grey[300],
  // //     ),
  // //   ),
  // //   StaggeredGridTile.count(
  // //     crossAxisCellCount: 1,
  // //     mainAxisCellCount: 1,
  // //     child: Container(
  // //       color: Colors.grey[300],
  // //     ),
  // //   ),
  // //   StaggeredGridTile.count(
  // //     crossAxisCellCount: 1,
  // //     mainAxisCellCount: 2,
  // //     child: Container(
  // //       color: Colors.grey[300],
  // //     ),
  // //   ),
  // //   StaggeredGridTile.count(
  // //     crossAxisCellCount: 1,
  // //     mainAxisCellCount: 1,
  // //     child: Container(
  // //       color: Colors.grey[300],
  // //     ),
  // //   ),
  // //   StaggeredGridTile.count(
  // //     crossAxisCellCount: 1,
  // //     mainAxisCellCount: 1,
  // //     child: Container(
  // //       color: Colors.grey[300],
  // //     ),
  // //   ),
  // //   StaggeredGridTile.count(
  // //     crossAxisCellCount: 1,
  // //     mainAxisCellCount: 2,
  // //     child: Container(
  // //       color: Colors.grey[300],
  // //     ),
  // //   ),
  // //   StaggeredGridTile.count(
  // //     crossAxisCellCount: 1,
  // //     mainAxisCellCount: 1,
  // //     child: Container(
  // //       color: Colors.grey[300],
  // //     ),
  // //   ),
  // //   StaggeredGridTile.count(
  // //     crossAxisCellCount: 1,
  // //     mainAxisCellCount: 1,
  // //     child: Container(
  // //       color: Colors.grey[300],
  // //     ),
  // //   ),

  // //   StaggeredGridTile.count(
  // //     crossAxisCellCount: 1,
  // //     mainAxisCellCount: 1,
  // //     child: Container(
  // //       color: Colors.grey[300],
  // //     ),
  // //   ),
  // //   StaggeredGridTile.count(
  // //     crossAxisCellCount: 1,
  // //     mainAxisCellCount: 1,
  // //     child: Container(
  // //       color: Colors.grey[300],
  // //     ),
  // //   ),
  // // ];

  // @override
  // Widget build(BuildContext context) {
  //   return StaggeredGrid.count(
  //     axisDirection: AxisDirection.down,
  //     crossAxisCount: 3,
  //     mainAxisSpacing: 1,
  //     crossAxisSpacing: 1,
  //     children: gridTiles,
  //   );
  // }

  @override
  Widget build(BuildContext context){

    return StaggeredGridView.countBuilder(
      crossAxisCount: 3,
      itemCount: (postsSnapshot.data! as dynamic).docs.length,
      itemBuilder: (context, index){
        return PostPreview(
          post: Post.fromSnap((postsSnapshot.data! as dynamic).docs[index]),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.count(
          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
    );
  }
}
