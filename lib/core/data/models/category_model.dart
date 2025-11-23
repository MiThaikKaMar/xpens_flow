import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part '../../../features/onboarding/data/models/category_model.g.dart';

@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  final String label;
  @HiveField(1)
  final String iconName;

  const CategoryModel({required this.label, required this.iconName});

  IconData get iconData {
    switch (iconName) {
      case 'Icons.house':
        return Icons.house;
      case 'Icons.bolt':
        return Icons.bolt;
      case 'Icons.shopping_cart':
        return Icons.shopping_cart;
      case 'Icons.emoji_transportation':
        return Icons.emoji_transportation;
      case 'Icons.health_and_safety':
        return Icons.health_and_safety;
      case 'Icons.dining':
        return Icons.dining;
      case 'Icons.games':
        return Icons.games;
      case 'Icons.shopping_bag':
        return Icons.shopping_bag;
      case 'Icons.flight':
        return Icons.flight;
      case 'Icons.subscriptions':
        return Icons.subscriptions;
      case 'Icons.savings':
        return Icons.savings;
      case 'Icons.attach_money':
        return Icons.attach_money;
      case 'Icons.add':
        return Icons.add;
      case 'Icons.new_label':
        return Icons.new_label;

      default:
        return Icons.category;
    }
  }
}
