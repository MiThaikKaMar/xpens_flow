// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';
import 'package:xpens_flow/core/ui/theme/colors.dart';
import 'package:xpens_flow/core/ui/theme/typography.dart';

import '../../../../core/ui/theme/spacing.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel cardItem;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    required this.cardItem,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8.0 : 2.0,
      color: isSelected
          ? AppColors.primary.withOpacity(0.4)
          : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.smmd),
        side: isSelected
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2.0)
            : BorderSide.none,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.black.withOpacity(0.2)
                  : const Color.fromARGB(255, 12, 18, 20),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),

            padding: EdgeInsets.all(AppSpacing.sm),
            child: Icon(
              cardItem.iconData,
              size: AppSpacing.lg,
              color: isSelected
                  ? Colors.white
                  : AppColors.primary.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            cardItem.label,
            textAlign: TextAlign.center,
            style: AppTypography.bodySemiSmall.copyWith(
              // fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              // color: isSelected
              //     ? Theme.of(context).primaryColor
              //     : Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
