//A part of code from https://gist.github.com/agungsb/2e7b00ac6bfc31c5a4fe9df084d61008

import 'package:flutter/material.dart';
import 'package:pseudofiles/classes/file_manager.dart';
import 'package:pseudofiles/utils/constants.dart';
import 'package:pseudofiles/utils/themes.dart';

import 'custom_animated_icon.dart';

class FlaotingMenuButton extends StatefulWidget {
  const FlaotingMenuButton({
    Key? key,
    required this.onPressed,
    required this.tooltip,
    required this.items,
  }) : super(key: key);

  final Function(bool value) onPressed;
  final String tooltip;
  final List<FloatingButtonMenuButton> items;

  @override
  _FlaotingMenuButtonState createState() => _FlaotingMenuButtonState();
}

class _FlaotingMenuButtonState extends State<FlaotingMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  bool isOpened = false;

  @override
  initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _translateButton = Tween<double>(
      begin: 50.0,
      end: -10.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.75, curve: Curves.easeOut),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
    widget.onPressed(isOpened);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: animate,
      child: Container(
        height: size.height,
        width: size.width,
        color: isOpened ? Colors.transparent : null,
        padding: const EdgeInsets.only(bottom: 13.0, right: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(widget.items.length + 1, (index) {
            if (index == widget.items.length) {
              return FloatingActionButton(
                backgroundColor: FileManager.useMaterial3
                    ? Theme.of(context).colorScheme.secondary
                    : accentColor,
                onPressed: animate,
                tooltip: widget.tooltip,
                child: CustomAnimatedIcon(
                  isOpen: isOpened,
                  icon1: Icons.close,
                  icon2: Icons.add,
                ),
                // child: AnimatedIcon(
                //   icon: AnimatedIcons.menu_close,
                //   progress: _animateIcon,
                // ),
              );
            } else {
              return Transform(
                transform: Matrix4.translationValues(
                  0.0,
                  _translateButton.value * (widget.items.length - index),
                  0.0,
                ),
                child: MiniButtons(
                  label: widget.items[index].label,
                  icon: widget.items[index].icon,
                  onTap: () async {
                    animate();
                    await Future.delayed(const Duration(milliseconds: 100));
                    widget.items[index].onTap();
                  },
                  isOpen: isOpened,
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}

class MiniButtons extends StatelessWidget {
  const MiniButtons({
    Key? key,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isOpen,
  }) : super(key: key);
  final String label;
  final IconData icon;
  final bool isOpen;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        isOpen
            ? Card(
                color: Theme.of(context).textTheme.bodyText1!.color,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        const SizedBox(width: 10.0),
        FloatingActionButton(
          mini: true,
          onPressed: onTap,
          tooltip: label,
          child: Icon(icon),
        ),
        const SizedBox(width: 5.0),
      ],
    );
  }
}

class FloatingButtonMenuButton {
  String label;
  IconData icon;
  Function() onTap;

  FloatingButtonMenuButton(this.label, this.icon, this.onTap);
}
