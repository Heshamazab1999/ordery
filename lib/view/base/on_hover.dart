import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/color_resources.dart';

class OnHover extends StatefulWidget {
  final Widget child;
  final bool isItem;
  OnHover({Key key, this.child, this.isItem = false}) : super(key: key);

  @override
  State<OnHover> createState() => _OnHoverState();
}

class _OnHoverState extends State<OnHover> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    final hoverTransformed = Matrix4.identity()..scale(1.05, 1.03);
    final transform = isHovered ? hoverTransformed : Matrix4.identity();
    final shedow1 = BoxDecoration(
      // shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: ColorResources.Black_COLOR.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 3),
        )
      ],
    );
    final shedow2 = BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: ColorResources.Black_COLOR.withOpacity(0),
          blurRadius: 0,
          offset: const Offset(0, 0),
        )
      ],
    );
    return MouseRegion(
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: widget.isItem ? isHovered ? shedow1 : shedow2 : shedow2,
        transform: widget.isItem ? Matrix4.identity() : transform  ,
        child: widget.child,
      ),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
