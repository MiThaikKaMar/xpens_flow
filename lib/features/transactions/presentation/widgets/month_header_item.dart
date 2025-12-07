import 'package:flutter/material.dart';
import 'package:xpens_flow/core/ui/theme/colors.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';
import 'package:xpens_flow/core/ui/theme/typography.dart';

class MonthHeaderItem extends StatefulWidget {
  final String headerText;

  const MonthHeaderItem({super.key, required this.headerText});

  @override
  State<MonthHeaderItem> createState() => _MonthHeaderItemState();
}

class _MonthHeaderItemState extends State<MonthHeaderItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBlueBackground,
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      child: Text(
        widget.headerText,
        textAlign: TextAlign.start,
        style: AppTypography.headlineSmall,
      ),
    );
  }
}
