import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/router/routes.dart';
import 'package:xpens_flow/core/common/utils/app_strings.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';
import 'package:xpens_flow/core/ui/theme/typography.dart';
import 'package:xpens_flow/features/onboarding/presentation/cubit/category_cubit.dart';
import 'package:xpens_flow/features/onboarding/presentation/widgets/category_card.dart';

class CategoriesSuggestPage extends StatefulWidget {
  final CategoryCubit categoryCubit;

  const CategoriesSuggestPage({super.key, required this.categoryCubit});

  @override
  State<CategoriesSuggestPage> createState() => _CategoriesSuggestPageState();
}

class _CategoriesSuggestPageState extends State<CategoriesSuggestPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.catAppBarTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom: AppSpacing.lg,
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSpacing.sm),
                  // Title
                  Text(
                    AppStrings.catTitle,
                    style: AppTypography.headlineMedium,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(AppStrings.catDes, style: TextStyle(color: Colors.grey)),
                ],
              ),
              SizedBox(height: AppSpacing.md),
              // Categories
              Expanded(
                child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoaded) {
                      final List<CategoryModel> addNewIncludedList = [
                        ...state.initCatList,
                        CategoryModel(iconName: "Icons.add", label: "Add New"),
                      ];

                      return GridView.count(
                        crossAxisCount: 2,
                        //padding: const EdgeInsets.all(16.0),
                        mainAxisSpacing: AppSpacing.xs,
                        crossAxisSpacing: AppSpacing.xs,
                        childAspectRatio: 1.4,
                        children: addNewIncludedList.map((cat) {
                          bool isSelected = false;
                          if (state.selectedCatList != null) {
                            isSelected = state.selectedCatList!.contains(cat);
                          }
                          return GestureDetector(
                            onTap: () {
                              _handleTapCard(cat, isSelected);
                            },
                            child: CategoryCard(
                              cardItem: cat,
                              isSelected: isSelected,
                            ),
                          );
                        }).toList(),
                      );
                    }

                    return Container();
                  },
                ),
              ),

              SizedBox(height: AppSpacing.md),
              // Confirm Button
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       context.read<CategoryCubit>().onCompleteOnboarding();
              //       context.go(Routes.home);
              //     },
              //     child: Text(
              //       AppStrings.catBtComfirmCate,
              //       style: AppTypography.bodyLarge.copyWith(
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ),
              // ),
              BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  final bool hasSelection =
                      state is CategoryLoaded &&
                      state.selectedCatList != null &&
                      state.selectedCatList!.isNotEmpty;

                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: hasSelection
                          ? () {
                              context
                                  .read<CategoryCubit>()
                                  .onCompleteOnboarding();
                              context.go(Routes.home);
                            }
                          : null,
                      child: Text(
                        AppStrings.catBtComfirmCate,
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),

              // TextButton(
              //   onPressed: () {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text("Skipping category selection.")),
              //     );
              //     context.push(Routes.home);
              //   },
              //   child: Text(AppStrings.catDoItLater),
              // ),
              // SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    _textEditingController.clear();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Add New Category"),
          content: TextField(
            controller: _textEditingController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter category name",
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _handleAddCategory(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(onPressed: _handleAddCategory, child: Text("Add")),
          ],
        );
      },
    );
  }

  void _handleAddCategory() {
    context.read<CategoryCubit>().addNewCategory(
      CategoryModel(
        label: _textEditingController.text.trim(),
        iconName: "Icons.category",
      ),
    );
    Navigator.of(context).pop();
  }

  void _handleTapCard(CategoryModel cat, bool isSelected) {
    if (cat.label != "Add New") {
      if (isSelected) {
        context.read<CategoryCubit>().removeCategoryFromSelected(cat);
      } else {
        context.read<CategoryCubit>().addCategoryToSelected(cat);
      }
    } else {
      _showAddCategoryDialog();
    }
  }
}
