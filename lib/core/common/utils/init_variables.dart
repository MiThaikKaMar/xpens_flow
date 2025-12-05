import 'package:currency_picker/currency_picker.dart';
import 'package:xpens_flow/core/common/utils/app_strings.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';

class InitVariables {
  static Currency initCurrency = Currency(
    code: "USD",
    name: "United States Dollar",
    symbol: '\$',
    number: 840,
    flag: "USD",
    decimalDigits: 2,
    namePlural: "US dollars",
    symbolOnLeft: true,
    decimalSeparator: ".",
    thousandsSeparator: ",",
    spaceBetweenAmountAndSymbol: false,
  );

  static List<CategoryModel> initCatList = [
    CategoryModel(label: AppStrings.catHousing, iconName: 'Icons.house'),
    CategoryModel(label: AppStrings.catUtilities, iconName: 'Icons.bolt'),
    CategoryModel(
      label: AppStrings.catGroceries,
      iconName: 'Icons.shopping_cart',
    ),
    CategoryModel(
      label: AppStrings.catTransport,
      iconName: 'Icons.emoji_transportation',
    ),
    CategoryModel(label: AppStrings.catInsurance, iconName: 'Icons.shield'),
    CategoryModel(
      label: AppStrings.catHealth,
      iconName: 'Icons.health_and_safety',
    ),
    CategoryModel(label: AppStrings.catDining, iconName: 'Icons.dining'),
    CategoryModel(label: AppStrings.catEntertainment, iconName: 'Icons.games'),
    CategoryModel(
      label: AppStrings.catShopping,
      iconName: 'Icons.shopping_bag',
    ),
    CategoryModel(label: AppStrings.catTravel, iconName: 'Icons.flight'),
    CategoryModel(
      label: AppStrings.catSubscriptions,
      iconName: 'Icons.subscriptions',
    ),
    CategoryModel(label: AppStrings.catSaving, iconName: 'Icons.savings'),
    CategoryModel(label: AppStrings.catIncome, iconName: 'Icons.attach_money'),
  ];
}
