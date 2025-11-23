import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';
import 'package:xpens_flow/core/ui/format/date_format.dart';
import 'package:xpens_flow/features/transactions/data/models/transaction_model.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';
import 'package:xpens_flow/features/transactions/presentation/state/feed/transaction_feed_bloc.dart';

import '../../../../core/ui/bloc/app_settings_bloc.dart';

class QuickAddSheet extends StatefulWidget {
  const QuickAddSheet({super.key});

  @override
  State<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends State<QuickAddSheet> {
  final TextEditingController amountEditingController = TextEditingController();
  final TextEditingController noteEditingController = TextEditingController();

  DateTime displayDateTime = DateTime.now();

  int _selectedItem = 0;
  String _selectedCategory = '';
  final TransactionType _selectedTransactionType = TransactionType.expense;

  String currencySign = '';
  List<CategoryModel>? _categories = [];

  late TransactionFeedBloc _transactionFeedBloc;

  @override
  void initState() {
    super.initState();
    _transactionFeedBloc = BlocProvider.of<TransactionFeedBloc>(context);
  }

  @override
  void dispose() {
    amountEditingController.dispose();
    noteEditingController.dispose();
    super.dispose();
  }

  void _handleTransaction() {
    debugPrint("DEBUG: _handleTransaction called!");

    final amountText = amountEditingController.text.trim();

    if (amountText.isEmpty) {
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

    final newTransaction = TransactionModel(
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text("Quick Add"),
                  IconButton(
                    icon: Icon(Icons.find_in_page),
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
              Divider(),
              Text(currencySign),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                controller: amountEditingController,
              ),
              Text("Tap to edit amount"),

              Divider(),
              Text("Category"),
              Wrap(
                children: _categories == null
                    ? []
                    : _categories!.asMap().entries.map((entry) {
                        return ChoiceChip(
                          label: Text(entry.value.label),
                          selected: _selectedItem == entry.key,
                          onSelected: (value) => setState(() {
                            _selectedItem = entry.key;
                            debugPrint(
                              "selected value: $value ${entry.value.label}",
                            );
                            _selectedCategory = entry.value.label;
                          }),
                        );
                      }).toList(),
              ),

              Divider(),
              Text("Merchant/ Note"),
              TextField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: noteEditingController,
              ),
              Divider(),
              Text("Date & Time"),
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
                child: Row(
                  children: [
                    Text(formatDateTime(displayDateTime)),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    //  );
  }
}
