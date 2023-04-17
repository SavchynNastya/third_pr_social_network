import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(_animationController),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Text(
                'Instagram',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            FadeTransition(
              opacity: _animation,
              child: SvgPicture.asset(
                'images/instagram.svg',
                semanticsLabel: 'Instagram Logo',
                width: 100,
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
