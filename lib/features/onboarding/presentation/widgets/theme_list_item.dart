import 'package:flutter/material.dart';

class ThemeListItem extends StatefulWidget {
  final String typeLable;
  final Color containerColor;
  final Color itemBorderColor;

  const ThemeListItem({
    super.key,
    required this.typeLable,
    required this.containerColor,
    required this.itemBorderColor,
  });

  @override
  State<ThemeListItem> createState() => _ThemeItemState();
}

class _ThemeItemState extends State<ThemeListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.containerColor,
        border: BoxBorder.all(color: widget.itemBorderColor),
      ),
      child: Text(widget.typeLable),
    );
  }
}
