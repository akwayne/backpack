import 'package:flutter/material.dart';

// Creates a background that appears to slide upwards forever
// But it is just an image that loops every 60 seconds
class LoginBackground extends StatefulWidget {
  const LoginBackground({super.key, required this.child});

  final Widget child;

  @override
  State<LoginBackground> createState() => _LoginBackgroundState();
}

class _LoginBackgroundState extends State<LoginBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 60),
    vsync: this,
  )..repeat();

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, -0.5),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height
    double displayHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned.fill(
          // background image fills a box that is 2x the height of the screen
          bottom: -displayHeight,
          child: SlideTransition(
            position: _offsetAnimation,
            child: Image.asset(
              // Image by upklyak on Freepik
              'assets/supplies.jpg',
              color: const Color.fromRGBO(255, 255, 255, 0.1),
              colorBlendMode: BlendMode.modulate,
              repeat: ImageRepeat.repeatY,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SizedBox(
                width: 400,
                child: widget.child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
