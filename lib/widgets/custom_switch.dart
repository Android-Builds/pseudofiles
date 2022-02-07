import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.4, 0.0),
      end: const Offset(0.4, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.value ? Curves.easeIn : Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          if (_controller.isCompleted) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
          widget.value == false
              ? widget.onChanged(true)
              : widget.onChanged(false);
          setState(() {});
        },
        child: SizedBox(
            height: 20.0,
            width: 28.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // AnimatedCrossFade(
                //   duration: const Duration(milliseconds: 200),
                //   firstChild: Container(
                //     height: 14.0,
                //     decoration: BoxDecoration(
                //       color: Colors.red,
                //       borderRadius: BorderRadius.circular(50.0),
                //     ),
                //   ),
                //   secondChild: Container(
                //     height: 14.0,
                //     decoration: BoxDecoration(
                //       color: Colors.grey,
                //       borderRadius: BorderRadius.circular(50.0),
                //     ),
                //   ),
                //   crossFadeState: widget.value
                //       ? CrossFadeState.showFirst
                //       : CrossFadeState.showSecond,
                // ),
                // Container(
                //   height: 14.0,
                //   decoration: BoxDecoration(
                //     color: Colors.red,
                //     borderRadius: BorderRadius.circular(10.0),
                //   ),
                // ),
                // FadeTransition(
                //   opacity: _animation,
                //   child: Container(
                //     padding: EdgeInsets.all(2.0),
                //     height: 14.0,
                //     decoration: BoxDecoration(
                //       color: Colors.red,
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //     child: Container(
                //       height: 12.0,
                //       decoration: BoxDecoration(
                //         color: Theme.of(context).scaffoldBackgroundColor,
                //         borderRadius: BorderRadius.circular(10.0),
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.all(2.0),
                  height: 14.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: 12.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SlideTransition(
                  position: _offsetAnimation,
                  child: const CircleAvatar(
                    radius: 10.0,
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
