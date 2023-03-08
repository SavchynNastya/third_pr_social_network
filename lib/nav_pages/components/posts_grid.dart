import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PostsGrid extends StatelessWidget {
  const PostsGrid ({super.key});

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      axisDirection: AxisDirection.right,
      crossAxisCount: 4,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1, 
          mainAxisCellCount: 1, 
          child: Container(
            color: Colors.grey[300],
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: Container(
            color: Colors.grey[300],
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: Container(
            color: Colors.grey[300],
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: Container(
            color: Colors.grey[300],
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: Container(
            color: Colors.grey[300],
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: Container(
            color: Colors.grey[300],
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: Container(
            color: Colors.grey[300],
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: Container(
            color: Colors.grey[300],
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: Container(
            color: Colors.grey[300],
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: Container(
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}