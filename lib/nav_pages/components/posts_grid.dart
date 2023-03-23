import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PostsGrid extends StatelessWidget {
  PostsGrid({super.key});

  List<StaggeredGridTile> gridTiles = List.generate(
    15,
    (index) {
      if (index == 2 || index == 5 || index == 12) {
        return StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 2,
          child: Container(
            color: Colors.grey[300],
          ),
        );
      } else {
        return StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: Container(
            color: Colors.grey[300],
          ),
        );
      }
    },
  );

  // List<StaggeredGridTile> gridTemplate = [
  //   StaggeredGridTile.count(
  //     crossAxisCellCount: 1,
  //     mainAxisCellCount: 1,
  //     child: Container(
  //       color: Colors.grey[300],
  //     ),
  //   ),
  //   StaggeredGridTile.count(
  //     crossAxisCellCount: 1,
  //     mainAxisCellCount: 1,
  //     child: Container(
  //       color: Colors.grey[300],
  //     ),
  //   ),
  //   StaggeredGridTile.count(
  //     crossAxisCellCount: 1,
  //     mainAxisCellCount: 2,
  //     child: Container(
  //       color: Colors.grey[300],
  //     ),
  //   ),
  //   StaggeredGridTile.count(
  //     crossAxisCellCount: 1,
  //     mainAxisCellCount: 1,
  //     child: Container(
  //       color: Colors.grey[300],
  //     ),
  //   ),
  //   StaggeredGridTile.count(
  //     crossAxisCellCount: 1,
  //     mainAxisCellCount: 1,
  //     child: Container(
  //       color: Colors.grey[300],
  //     ),
  //   ),
  //   StaggeredGridTile.count(
  //     crossAxisCellCount: 1,
  //     mainAxisCellCount: 2,
  //     child: Container(
  //       color: Colors.grey[300],
  //     ),
  //   ),
  //   StaggeredGridTile.count(
  //     crossAxisCellCount: 1,
  //     mainAxisCellCount: 1,
  //     child: Container(
  //       color: Colors.grey[300],
  //     ),
  //   ),
  //   StaggeredGridTile.count(
  //     crossAxisCellCount: 1,
  //     mainAxisCellCount: 1,
  //     child: Container(
  //       color: Colors.grey[300],
  //     ),
  //   ),

  //   StaggeredGridTile.count(
  //     crossAxisCellCount: 1,
  //     mainAxisCellCount: 1,
  //     child: Container(
  //       color: Colors.grey[300],
  //     ),
  //   ),
  //   StaggeredGridTile.count(
  //     crossAxisCellCount: 1,
  //     mainAxisCellCount: 1,
  //     child: Container(
  //       color: Colors.grey[300],
  //     ),
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      axisDirection: AxisDirection.down,
      crossAxisCount: 3,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      children: gridTiles,
    );
  }
}
