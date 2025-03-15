import 'package:floating_action_bubble_custom/floating_action_bubble_custom.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  final List<Widget> items;

  const MenuButton({super.key, required this.items});

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionBubble(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      backgroundColor: Color(0xFF223E6D),
      animation: _animation,
      onPressed:
          () =>
              _animationController.isCompleted
                  ? _animationController.reverse()
                  : _animationController.forward(),
      iconColor: Colors.white,
      iconData: Icons.menu,

      items: widget.items,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
