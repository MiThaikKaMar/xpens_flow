// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:xpens_flow/core/common/utils/icon_helper.dart';
import 'package:xpens_flow/core/ui/theme/colors.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';

import '../../../../core/ui/format/date_format.dart';
import '../../../../core/ui/theme/app_theme.dart';
import '../../domain/entities/transaction_split.dart';

class TransactionEditorPage extends StatefulWidget {
  const TransactionEditorPage({
    super.key,
    required this.transactionId,
    required this.transaction,
    required this.currencySymbol,
  });

  final int transactionId;
  final Transaction transaction;
  final String currencySymbol;

  @override
  State<TransactionEditorPage> createState() => _TransactionEditorPageState();
}

class _TransactionEditorPageState extends State<TransactionEditorPage> {
  late TextEditingController _amountController;
  late TextEditingController _merchantController;
  late TextEditingController _descriptionController;

  late Transaction transaction;
  late String amountText;

  late String categoryText;
  late String merchantNote;
  late TransactionType? selectedType;
  late DateTime dateTime;
  late String? account;
  late String? description;
  late List<String>? tags;
  late bool isTransfer;
  late bool isRecurring;
  late List<String>? attachments;
  late List<TransactionSplit>? splits;
  late DateTime? createdAt;
  late DateTime? updatedAt;
  late String? appliedRule;

  @override
  void initState() {
    super.initState();
    transaction = widget.transaction;
    bool isExpense = transaction.type == TransactionType.expense;
    amountText = isExpense
        ? "${widget.currencySymbol}${transaction.amount}"
        : "${widget.currencySymbol}${transaction.amount}";
    _amountController = TextEditingController(text: amountText);

    categoryText = transaction.category;
    merchantNote = transaction.merchant_note ?? '';
    selectedType = transaction.type;
    dateTime = transaction.date_time;
    account = transaction.account;
    description = transaction.description;
    tags = transaction.tags;
    isTransfer = transaction.isTransfer;
    isRecurring = transaction.isRecurring;
    attachments = transaction.attachments;
    splits = transaction.splits;
    createdAt = transaction.createdAt;
    updatedAt = transaction.updatedAt;
    appliedRule = transaction.appliedRule;

    _merchantController = TextEditingController(text: merchantNote);
    _descriptionController = TextEditingController(text: description);
  }

  @override
  Widget build(BuildContext context) {
    // DateTime displayDateTime = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Transaction"),
        actions: [Icon(Icons.delete_outline)],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ///Amount
            Text("AMOUNT"),
            TextField(controller: _amountController),
            SizedBox(height: AppSpacing.lg),

            //..................
            /// Types
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: TransactionType.values.map((type) {
                final isSelected = selectedType == type;
                return ChoiceChip(
                  label: Text(
                    type.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  selected: isSelected,
                  onSelected: (selected) => setState(() {
                    selectedType = selected ? type : null;
                  }),
                  // Visuals
                  backgroundColor: Colors.grey.withOpacity(
                    0.18,
                  ), // unselected fill
                  selectedColor: Colors
                      .transparent, // keep transparent if you want only border highlight
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.white70,
                    fontSize: 14,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.smmd,
                    vertical: AppSpacing.smmd,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.white12,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  // remove elevation for flat look
                  elevation: 0,
                  pressElevation: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
            SizedBox(height: AppSpacing.lg),

            //.......................
            /// Category
            Text("CATEGORY"),
            ListTile(
              leading: Icon(getIconDataFromString(categoryText)),
              title: Text(categoryText),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            SizedBox(height: AppSpacing.lg),

            ///.............................
            ///Merchant
            Text("MERCHANT"),
            TextField(controller: _merchantController),
            SizedBox(height: AppSpacing.lg),

            //.................
            /// Date
            Text("DATE & TIME"),
            GestureDetector(
              onTap: () {
                DatePicker.showDateTimePicker(
                  context,
                  onConfirm: (time) {
                    setState(() {
                      dateTime = time;
                    });
                  },
                );
              },
              child: ListTile(
                shape: AppTheme.roundedRectangleBorder.copyWith(
                  side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                title: Text(formatDateTime(dateTime)),
                trailing: Icon(
                  Icons.calendar_today,
                  size: AppSpacing.size18,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            //...............
            ///Account
            Text("ACCOUNT"),
            ListTile(
              title: Text(account ?? "No account Linked yet"),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: AppSpacing.size18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: AppSpacing.lg),

            ///........................
            ///Description
            Text("DESCRIPTION"),
            TextField(controller: _descriptionController),
            SizedBox(height: AppSpacing.lg),

            //...........................
            // Tags
            Text("TAGS"),
            tags == null
                ? Text('No tags yet. Add some!')
                : Wrap(
                    children: tags!.map((tag) {
                      return Chip(
                        label: Text(tag),
                        deleteIcon: Icon(Icons.close),
                        onDeleted: () {},

                        //_removeTag(tag),
                      );
                    }).toList(),
                  ),
            TextButton.icon(
              onPressed: () {},
              label: Text("Add Tag"),
              icon: Icon(Icons.add),
            ),

            SizedBox(height: AppSpacing.lg),

            //......................
            /// Rules
            Row(
              children: [
                Checkbox(
                  value: isTransfer,
                  onChanged: (bool? value) {
                    setState(() {
                      isTransfer = value!;
                    });
                  },
                ),
                Text("Mark as Transfer"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isRecurring,
                  onChanged: (bool? value) {
                    setState(() {
                      isRecurring = value!;
                    });
                  },
                ),
                Text("Recurring Transaction"),
              ],
            ),

            SizedBox(height: AppSpacing.lg),

            //.......................
            //Attachments
            Text("ATTACHMENTS"),
            Container(
              color: Colors.blueGrey,
              width: AppSpacing.size100,
              height: AppSpacing.size100,
            ),
            SizedBox(height: AppSpacing.lg),

            //...............................
            // Split transaction
            Text("SPLIT TRANSACTION"),
            // Add & remove spliting transaction ui
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),

      bottomNavigationBar:
          // Delete
          FilledButton(onPressed: () {}, child: Text("Save Changes")),
    );
  }
}
