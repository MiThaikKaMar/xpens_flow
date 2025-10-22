import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpens_flow/features/onboarding/data/models/category_model.dart';
import 'package:xpens_flow/features/onboarding/domain/usecases/complete_onboarding.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CompleteOnboarding completeOnboarding;
  final List<CategoryModel> _initCatList;
  final List<CategoryModel> selectedCatList = [];

  CategoryCubit({required this.completeOnboarding, required initCatList})
    : _initCatList = initCatList,
      super(CategoryInitial()) {
    loadInitCategories(_initCatList);
  }

  void loadInitCategories(List<CategoryModel> initCatList) {
    selectedCatList.clear;
    emit(
      CategoryLoaded(
        initCatList: initCatList,
        selectedCatList: selectedCatList,
      ),
    );
  }

  void addCategoryToSelected(CategoryModel cat) {
    selectedCatList.add(cat);
    emit(
      CategoryLoaded(
        initCatList: _initCatList,
        selectedCatList: selectedCatList,
      ),
    );
  }

  void removeCategoryFromSelected(CategoryModel cat) {
    selectedCatList.remove(cat);
    emit(
      CategoryLoaded(
        initCatList: _initCatList,
        selectedCatList: selectedCatList,
      ),
    );
  }

  void addNewCategory(CategoryModel cat) {
    selectedCatList.add(cat);
    _initCatList.add(cat);
    emit(
      CategoryLoaded(
        initCatList: _initCatList,
        selectedCatList: selectedCatList,
      ),
    );
  }

  void onCompleteOnboarding() async {
    final res = await completeOnboarding.call(
      SelectedCatParams(selectedCatList),
    );

    res.fold((l) => debugPrint(l), (r) => debugPrint(r.message));
  }
}
