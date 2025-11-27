import 'package:flutter/material.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';

class ThemeListItem extends StatefulWidget {
  final String typeLabel;
  final Color containerColor;
  final Color itemBorderColor;

  const ThemeListItem({
    super.key,
    required this.typeLabel,
    required this.containerColor,
    required this.itemBorderColor,
  });

  @override
  State<ThemeListItem> createState() => _ThemeItemState();
}

class _ThemeItemState extends State<ThemeListItem> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   padding: EdgeInsets.all(20),
    //   decoration: BoxDecoration(
    //     border: BoxBorder.all(color: widget.itemBorderColor),
    //   ),
    //   child: Column(
    //     children: [
    //       Container(height: AppSpacing.md, color: widget.containerColor),
    //       Text(widget.typeLable),
    //     ],
    //   ),
    // );

    return Container(
      margin: EdgeInsets.only(right: AppSpacing.sm),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      decoration: BoxDecoration(
        border: Border.all(color: widget.itemBorderColor, width: 2),
        borderRadius: BorderRadius.circular(12), // Add rounded corners
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: AppSpacing.xxl,
            height: AppSpacing.md,
            decoration: BoxDecoration(
              color: widget.containerColor,
              border: Border.all(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(height: 12),
          Text(widget.typeLabel, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
