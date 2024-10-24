import 'package:flutter/material.dart';

class Fish {
  final Color color;
  final double speed;

  Fish({required this.color, required this.speed});

  Widget build(BuildContext context) {
    return AnimatedFish(color: color, speed: speed);
  }
}

class AnimatedFish extends StatefulWidget {
  final Color color;
  final double speed;

  const AnimatedFish({required this.color, required this.speed});

  @override
  _AnimatedFishState createState() => _AnimatedFishState();
}

class _AnimatedFishState extends State<AnimatedFish> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _position;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: (10 / widget.speed).round()), // Adjust speed
      vsync: this,
    )..repeat(reverse: true);

    _position = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(1, 1), // End position can be randomized
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _position.value.dx * 300, // Assuming a 300x300 container
          top: _position.value.dy * 300,
          child: CircleAvatar(backgroundColor: widget.color, radius: 10),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
