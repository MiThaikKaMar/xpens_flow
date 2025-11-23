import 'package:hive_flutter/hive_flutter.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';

class HiveCategoryService {
  final Box<CategoryModel> _box = Hive.box<CategoryModel>('categories');

  // Add a category
  Future<void> addCategory(CategoryModel category) async {
    await _box.add(category);
  }

  // Get all categories
  List<CategoryModel> getAllCategories() {
    return _box.values.toList();
  }

  // Delete a category by index
  Future<void> deleteCategory(int index) async {
    await _box.deleteAt(index);
  }

  // Update a category
  Future<void> updateCategory(int index, CategoryModel category) async {
    await _box.putAt(index, category);
  }

  // Clear all categories
  Future<void> clearAll() async {
    await _box.clear();
  }
}
