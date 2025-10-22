part of 'category_cubit.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> initCatList;
  final List<CategoryModel>? selectedCatList;

  CategoryLoaded({required this.initCatList, required this.selectedCatList});
}
