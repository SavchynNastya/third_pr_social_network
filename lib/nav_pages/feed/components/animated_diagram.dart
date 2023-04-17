import 'package:flutter/material.dart';

class AnimatedDiagram extends StatefulWidget {
  const AnimatedDiagram({
    super.key,
    required this.values,
    required this.maxValue,
    required this.height,
    required this.width,
    required this.duration,
    required this.baseColor,
    required this.highlightColor,
  });

  final List<double> values;
  final double maxValue;
  final double height;
  final double width;
  final Duration duration;
  final Color baseColor;
  final Color highlightColor;

  @override
  State<AnimatedDiagram> createState() => _AnimatedDiagramState();
}

class _AnimatedDiagramState extends State<AnimatedDiagram>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);

    _animations = widget.values.map((value) {
      return Tween<double>(begin: 0, end: value).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    }).toList();

    _colorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 149, 56, 206),
      end: Colors.orange.shade600,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: _animations.asMap().entries.map((entry) {
                final index = entry.key;
                final animation = entry.value;
                final barHeight =
                    animation.value / widget.maxValue * widget.height;
                final barColor = (animation.value == widget.maxValue)
                    ? widget.highlightColor
                    : _colorAnimation.value;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: widget.width / widget.values.length / 2,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bar ${index + 1}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    ));
  }
}
