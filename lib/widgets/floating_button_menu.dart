import 'package:flutter/material.dart';
import 'package:pseudofiles/utils/constants.dart';

import 'custom_animated_icon.dart';

class FloatingButtonMenu extends StatefulWidget {
  const FloatingButtonMenu({Key? key, required this.items}) : super(key: key);
  final List<FloatingButtonMenuButton1> items;

  @override
  _FloatingButtonMenuState createState() => _FloatingButtonMenuState();
}

class _FloatingButtonMenuState extends State<FloatingButtonMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;
  bool hidden = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    offset = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.31,
      height: size.height * 0.25,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SlideTransition(
            position: offset,
            child: AnimatedOpacity(
                opacity: hidden ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) => miniButton(
                    widget.items[index].label,
                    widget.items[index].icon,
                    widget.items[index].onTap,
                  ),
                )),
          ),
          FloatingActionButton(
            child: CustomAnimatedIcon(
              isOpen: hidden,
              icon1: Icons.add,
              icon2: Icons.close,
            ),
            onPressed: () {
              switch (controller.status) {
                case AnimationStatus.completed:
                  controller.reverse();
                  break;
                case AnimationStatus.dismissed:
                  controller.forward();
                  break;
                default:
              }
              setState(() => hidden = !hidden);
            },
            heroTag: 'Floating Menu',
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  Widget miniButton(String label, IconData icon, Function onTap) => Padding(
        padding: const EdgeInsets.only(
          bottom: 10.0,
          right: 5.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Card(
              color: Theme.of(context).textTheme.bodyText1!.color,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            FloatingActionButton(
              onPressed: () => onTap(),
              heroTag: label,
              mini: true,
              child: Icon(
                icon,
                size: size.width * 0.045,
              ),
            ),
          ],
        ),
      );
}

class FloatingButtonMenuButton1 {
  String label;
  IconData icon;
  Function onTap;

  FloatingButtonMenuButton1(this.label, this.icon, this.onTap);
}
