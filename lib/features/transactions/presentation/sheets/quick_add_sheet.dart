// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';
import 'package:xpens_flow/core/ui/format/date_format.dart';
import 'package:xpens_flow/core/ui/theme/app_theme.dart';
import 'package:xpens_flow/core/ui/theme/typography.dart';
import 'package:xpens_flow/features/transactions/data/models/transaction_model.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';
import 'package:xpens_flow/features/transactions/presentation/state/feed/transaction_feed_bloc.dart';

import '../../../../core/ui/bloc/app_settings_bloc.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';

class QuickAddSheet extends StatefulWidget {
  const QuickAddSheet({super.key});

  @override
  State<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<QuickAddSheet> {
  final TextEditingController amountEditingController = TextEditingController();
  final TextEditingController noteEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  DateTime displayDateTime = DateTime.now();

  int _selectedItem = 0;
  String _selectedCategory = '';
  final TransactionType _selectedTransactionType = TransactionType.expense;

  String currencySign = '';
  List<CategoryModel>? _categories = [];

  bool _isAmountInvalid = false;

  late TransactionFeedBloc _transactionFeedBloc;

  @override
  void initState() {
    super.initState();
    _transactionFeedBloc = BlocProvider.of<TransactionFeedBloc>(context);

    amountEditingController.addListener(() {
      final text = amountEditingController.text.trim();
      final isEmpty = text.isEmpty;

      if (!isEmpty) {
        setState(() {
          _isAmountInvalid = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    amountEditingController.dispose();

    noteEditingController.dispose();
    super.dispose();
  }

  void _handleTransaction() {
    debugPrint("DEBUG: _handleTransaction called!");

    final amountText = amountEditingController.text.trim();

    if (amountText.isEmpty) {
      setState(() {
        _isAmountInvalid = true;
      });
      //showSnackbar(context, "Amount can not be empty");
      debugPrint("Amount can not be empty");
      return;
    }

    if (_selectedCategory.isEmpty) {
      //showSnackbar(context, "Please select a category");
      debugPrint("Please select a category");
      return;
    }

    double amount;

    try {
      amount = double.parse(amountText);
    } catch (e) {
      // showSnackbar(context, "Invalid amount format");
      debugPrint("Invalid amount format");
      return;
    }
    final noteText = noteEditingController.text.trim();
    debugPrint("NoteText: $noteText");

    final newTransaction = Transaction(
      amount: amount,
      category: _selectedCategory,
      type: _selectedTransactionType,
      merchant_note: noteText.isNotEmpty ? noteText : null,
      date_time: displayDateTime,
    );

    _transactionFeedBloc.add(TransactionFeedAdd(transaction: newTransaction));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // return BlocListener<TransactionFeedBloc, TransactionFeedState>(
    //   listener: (context, state) {
    //     if (state is TransactionFeedLoading) {
    //       //showSnackbar(context, "Adding Transaction");
    //     } else if (state is TransactionFeedAddSuccess) {
    //       // showSnackbar(context, "Transaction added successfully!");
    //       amountEditingController.clear();
    //       noteEditingController.clear();
    //       setState(() {
    //         displayDateTime = DateTime.now();
    //         _selectedCategory = _categories!.isNotEmpty
    //             ? _categories![0].label
    //             : "";
    //         _selectedItem = 0;
    //       });
    //     }
    //   },
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        if (state is AppSettingsLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is AppSettingsError) {
          return Center(child: Text(state.message));
        }

        if (state is AppSettingsLoaded) {
          currencySign = state.currentCurrency;
          _categories = state.catList;
          if (state.catList.isNotEmpty) {
            _selectedCategory = _selectedCategory == ''
                ? state.catList[0].label
                : _selectedCategory;
          }
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,

                  vertical: AppSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close Button
                    IconButton.filled(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tight(
                        Size(AppSpacing.xl, AppSpacing.xl),
                      ),
                      iconSize: AppSpacing.md,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),

                    // Title
                    Text("Quick Add", style: AppTypography.headlineSmall),

                    // Save Button
                    IconButton.filled(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints.tight(
                        Size(AppSpacing.xl, AppSpacing.xl),
                      ),

                      iconSize: AppSpacing.md,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: Icon(Icons.save_outlined, color: AppColors.primary),
                      onPressed: _handleTransaction,
                      // () {
                      //   final amountText = amountEditingController.text
                      //       .trim();
                      //   debugPrint(
                      //     "hello${TransactionModel(amount: amountText.isNotEmpty ? double.parse(amountText) : 0.0, category: _selectedCategory, type: TransactionType.expense, merchantNote: noteEditingController.text.trim(), dateTime: displayDateTime).toMap()}",
                      //   );
                      // },
                    ),
                  ],
                ),
              ),

              //........
              Divider(),

              // Currency Input
              SizedBox(height: AppSpacing.sm),
              Text(
                currencySign,
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.w100),
              ),
              TextField(
                focusNode: _focusNode,
                style: AppTypography.amountLarge.copyWith(
                  fontWeight: FontWeight.w100,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                showCursor: _focusNode.hasFocus,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                cursorHeight: AppSpacing.size42,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: _focusNode.hasFocus ? null : '0.0',

                  hintStyle: AppTypography.amountLarge.copyWith(
                    fontWeight: FontWeight.w100,
                    color: Colors.grey,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                controller: amountEditingController,
                onTap: () {
                  if (!_focusNode.hasFocus) _focusNode.requestFocus();
                },
              ),
              SizedBox(height: AppSpacing.sm),
              Text("Tap to edit amount", style: TextStyle(color: Colors.grey)),
              Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: _isAmountInvalid,
                child: Text(
                  "Amount is required!",
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.errorLight,
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.sm),

              //........
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    SizedBox(height: AppSpacing.md),
                    //Categories
                    Text(
                      "Category",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: _categories == null
                          ? []
                          : _categories!.asMap().entries.map((entry) {
                              return ChoiceChip(
                                label: Text(
                                  entry.value.label,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                selected: _selectedItem == entry.key,
                                onSelected: (value) => setState(() {
                                  _selectedItem = entry.key;
                                  debugPrint(
                                    "selected value: $value ${entry.value.label}",
                                  );
                                  _selectedCategory = entry.value.label;
                                }),
                                // Visuals
                                backgroundColor: Colors.grey.withOpacity(
                                  0.18,
                                ), // unselected fill
                                selectedColor: Colors
                                    .transparent, // keep transparent if you want only border highlight
                                labelStyle: TextStyle(
                                  color: _selectedItem == entry.key
                                      ? AppColors.primary
                                      : Colors.white70,
                                  fontSize: 14,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.smmd,
                                  vertical: AppSpacing.smmd,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: BorderSide(
                                    color: _selectedItem == entry.key
                                        ? AppColors.primary
                                        : Colors.white12,
                                    width: _selectedItem == entry.key ? 2 : 1,
                                  ),
                                ),
                                // remove elevation for flat look
                                elevation: 0,
                                pressElevation: 0,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              );
                            }).toList(),
                    ),
                    SizedBox(height: AppSpacing.md),
                    //.......
                    Divider(),
                    SizedBox(height: AppSpacing.md),

                    // Merchant/ Note
                    Row(
                      children: [
                        Text(
                          "Merchant/ Note",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Icon(
                          Icons.info_outline,
                          size: AppSpacing.size18,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    TextField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      controller: noteEditingController,
                    ),
                    SizedBox(height: AppSpacing.md),

                    //...........
                    Divider(),

                    SizedBox(height: AppSpacing.md),

                    // Date & Time
                    Text(
                      "Date & Time",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    GestureDetector(
                      onTap: () {
                        DatePicker.showDateTimePicker(
                          context,
                          onConfirm: (time) {
                            setState(() {
                              displayDateTime = time;
                            });
                          },
                        );
                      },
                      child: ListTile(
                        shape: AppTheme.roundedRectangleBorder.copyWith(
                          side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        ),
                        title: Text(formatDateTime(displayDateTime)),
                        trailing: Icon(
                          Icons.calendar_today,
                          size: AppSpacing.size18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //..............
            ],
          ),
        );
      },
    );
    //  );
  }
}


/// Quick Add Enhancement
/// // Update your Quick Add to optionally capture more data
// class QuickAddTransaction extends StatefulWidget {
//   // ... existing code
// }

// class _QuickAddTransactionState extends State<QuickAddTransaction> {
//   // Existing fields
//   double? amount;
//   String? category;
//   TransactionType? type;
  
//   // NEW: Optional fields (can be added later in Edit)
//   String? selectedAccount;
//   String? merchant;
//   bool showAdvancedFields = false; // Toggle for advanced input
  
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Existing quick add fields...
        
//         // Optional: "More Details" button
//         TextButton(
//           onPressed: () {
//             setState(() => showAdvancedFields = !showAdvancedFields);
//           },
//           child: Text(showAdvancedFields ? "Less Details" : "More Details"),
//         ),
        
//         if (showAdvancedFields) ...[
//           // Account dropdown
//           DropdownButton<String>(
//             value: selectedAccount,
//             hint: Text("Select Account"),
//             items: accounts.map((acc) => 
//               DropdownMenuItem(value: acc, child: Text(acc))
//             ).toList(),
//             onChanged: (val) => setState(() => selectedAccount = val),
//           ),
          
//           // Merchant field
//           TextField(
//             decoration: InputDecoration(labelText: "Merchant"),
//             onChanged: (val) => merchant = val,
//           ),
//         ],
        
//         // Save button creates transaction with available data
//         ElevatedButton(
//           onPressed: () {
//             final transaction = Transaction(
//               amount: amount!,
//               category: category!,
//               type: type!,
//               date_time: DateTime.now(),
//               merchant_note: merchant,
//               account: selectedAccount,
//               // Other fields will be null and can be edited later
//             );
//             // Save transaction
//           },
//           child: Text("Save"),
//         ),
//       ],
//     );
//   }
// }