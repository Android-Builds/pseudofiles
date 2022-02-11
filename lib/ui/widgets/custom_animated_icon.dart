// This part of the code is taken from https://stackoverflow.com/a/70396971/10046550

import 'package:flutter/material.dart';

class CustomAnimatedIcon extends StatefulWidget {
  const CustomAnimatedIcon({
    Key? key,
    required this.isOpen,
    required this.icon1,
    required this.icon2,
    this.duration = const Duration(milliseconds: 350),
  }) : super(key: key);
  final bool isOpen;
  final IconData icon1;
  final IconData icon2;
  final Duration duration;

  @override
  _CustomAnimatedIconState createState() => _CustomAnimatedIconState();
}

class _CustomAnimatedIconState extends State<CustomAnimatedIcon> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      transitionBuilder: (child, anim) => RotationTransition(
        turns: child.key == const ValueKey('icon1')
            ? Tween<double>(begin: 0.75, end: 1).animate(anim)
            : Tween<double>(begin: 1, end: 0.75).animate(anim),
        child: ScaleTransition(scale: anim, child: child),
      ),
      child: widget.isOpen
          ? Icon(
              widget.icon1,
              key: const ValueKey('icon1'),
            )
          : Icon(
              widget.icon2,
              key: const ValueKey('icon2'),
            ),
    );
  }
}
