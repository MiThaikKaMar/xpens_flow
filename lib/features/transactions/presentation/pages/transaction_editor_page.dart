// ignore_for_file: deprecated_member_use

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/router/routes.dart';

import 'package:xpens_flow/core/common/utils/icon_helper.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';
import 'package:xpens_flow/core/ui/theme/colors.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';
import 'package:xpens_flow/features/transactions/presentation/pages/transaction_split_page.dart';
import 'package:xpens_flow/features/transactions/presentation/state/editor/transaction_editor_bloc.dart';
import 'package:xpens_flow/features/transactions/presentation/widgets/attachment_card.dart';

import '../../../../core/ui/format/date_format.dart';
import '../../../../core/ui/theme/app_theme.dart';
import '../../domain/entities/transaction_split.dart';

class TransactionEditorPage extends StatefulWidget {
  const TransactionEditorPage({
    super.key,
    required this.transactionId,
    required this.transaction,
    required this.currencySymbol,
    required transactionEditorBloc,
  }) : _transactionEditorBloc = transactionEditorBloc;

  final int transactionId;
  final Transaction transaction;
  final String currencySymbol;

  final TransactionEditorBloc _transactionEditorBloc;

  @override
  State<TransactionEditorPage> createState() => _TransactionEditorPageState();
}

class _TransactionEditorPageState extends State<TransactionEditorPage> {
  late TextEditingController _amountController;
  late TextEditingController _merchantController;
  late TextEditingController _descriptionController;
  late TextEditingController _addTagEditingController;

  late Transaction transaction;
  late int id;
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

    widget._transactionEditorBloc.add(LoadAllCategories());

    transaction = widget.transaction;
    bool isExpense = transaction.type == TransactionType.expense;

    id = transaction.id!;
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
    _addTagEditingController = TextEditingController();
    //tags = ["Business", "Client"];
    // attachments = [
    //   '/data/user/0/com.mollydev.xpens_flow/cache/file_picker/1766147217876/edit.png',
    //   '/data/user/0/com.mollydev.xpens_flow/cache/file_picker/1766147221496/edit_transaction.png',
    // ];
  }

  void _handleSubmitTransaction(Transaction transaction) {
    debugPrint('''Updated transaction: ${transaction.id}, ${transaction.amount},
    ${transaction.type} , ${transaction.category}, ${transaction.merchant_note},
${transaction.date_time}, ${transaction.description}, ${transaction.tags} , 
${transaction.isTransfer}, ${transaction.isRecurring}, ${transaction.attachments},
${transaction.splits}, ${transaction.createdAt}, ${transaction.updatedAt}

    ''');

    final (isValid, splitTotal) = areSplitsValid(
      transaction.amount,
      transaction.splits,
    );

    if (isValid) {
      widget._transactionEditorBloc.add(
        TransactionSubmit(transaction: transaction),
      );
      context.pop();
    } else {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text("Split amounts don't match"),
            content: Text(
              "Transaction amount is ${transaction.amount.toStringAsFixed(2)},\n splits total ${splitTotal.toStringAsFixed(2)}",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _handleSplitActions();
                },
                child: Text("Review Splits"),
              ),
            ],
          );
        },
      );
    }
  }

  (bool, double) areSplitsValid(double amount, List<TransactionSplit>? splits) {
    if (splits == null || splits.isEmpty) return (true, 0.0);

    final splitTotal = splits.fold<double>(0.0, (sum, s) => sum + s.amount);
    /*
    double splitTotal = 0.0;

for (final split in splits) {
  splitTotal += split.amount;
}
 */

    return (splitTotal == amount, splitTotal);
  }

  double _getEditedAmount() {
    return double.parse(
      _amountController.text.replaceAll(
        RegExp(RegExp.escape(widget.currencySymbol)),
        '',
      ),
    );
  }

  void _handleAddTag(String tag, BuildContext dialogContext) {
    tags ??= [];
    tags!.add(tag);
    setState(() {
      Navigator.pop(dialogContext);
    });
  }

  void _handleRemoveTag(String tag) {
    setState(() {
      tags!.remove(tag);
    });
  }

  Future<void> _handleFilePicker() async {
    String? filePath;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      filePath = result.files.single.path!;
      debugPrint("FilePath: $filePath");

      attachments ??= [];
      setState(() {
        attachments?.add(filePath!);
      });
    } else {
      //User canceled the picker
    }
  }

  void _handleRemoveAttachment(String filePath) {
    setState(() {
      attachments?.remove(filePath);
    });
  }

  void _handleSplitActions() {
    final editedAmount = _getEditedAmount();

    debugPrint("splits in editor: ${splits?.length}");
    context
        .push<List<TransactionSplit>>(
          Routes.transactionSplit.replaceAll(':id', transaction.id.toString()),
          extra: {
            'editedAmount': editedAmount,
            'transaction': transaction,
            'symbol': widget.currencySymbol,
            'existingSplits': splits,
          },
        )
        .then((result) {
          //Handle the return data
          if (result != null) {
            setState(() {
              splits = result;
            });
          }
        });
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

            BlocBuilder<TransactionEditorBloc, TransactionEditorState>(
              builder: (context, state) {
                if (state is CategoriesLoading) {
                  return PopupMenuButton(
                    enabled: false,
                    itemBuilder: (context) => [],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: AppSpacing.md,
                          height: AppSpacing.md,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        Text("Loading..."),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  );
                }

                if (state is CategoriesError) {
                  return PopupMenuButton(
                    enabled: false,
                    itemBuilder: (context) => [],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red),
                        Text("Error loading"),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  );
                }

                if (state is CategoriesLoaded) {
                  final categories = state.categories;

                  return PopupMenuButton<CategoryModel>(
                    onSelected: (categoryModel) {
                      setState(() {
                        categoryText = categoryModel.label;
                      });
                    },
                    itemBuilder: (context) {
                      return categories.map((category) {
                        return PopupMenuItem(
                          value: category,
                          child: Row(
                            children: [
                              Icon(category.iconData),
                              SizedBox(width: AppSpacing.sm),
                              Text(category.label),
                            ],
                          ),
                        );
                      }).toList();
                    },

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(getIconDataFromString(categoryText)),
                        Text(categoryText),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  );
                }

                return PopupMenuButton<CategoryModel>(
                  enabled: false,
                  itemBuilder: (context) => [],

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(getIconDataFromString(categoryText)),
                      Text(categoryText),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                );
              },
            ),

            // PopupMenuButton(
            //   onSelected: (value) {},
            //   itemBuilder: (context) {
            //     return ["House", "Rent", "Groceries", "Bill"].map((item) {
            //       return PopupMenuItem(value: item, child: Text(item));
            //     }).toList();
            //   },
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       Icon(getIconDataFromString(categoryText)),
            //       Text(categoryText),
            //       Icon(Icons.arrow_drop_down),
            //     ],
            //   ),
            // ),
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
            ///METHOD
            Text("PAYMENT METHOD"),
            ListTile(
              title: Text(account ?? "Add payment method in Settings"),
              trailing: account != null
                  ? Icon(
                      Icons.arrow_forward_ios,
                      size: AppSpacing.size18,
                      color: Colors.grey,
                    )
                  : null,
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
                        onDeleted: () {
                          _handleRemoveTag(tag);
                        },
                      );
                    }).toList(),
                  ),
            TextButton.icon(
              onPressed: () {
                _addTagEditingController.clear();
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: Text("Add New Tag"),
                      content: TextField(controller: _addTagEditingController),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => _handleAddTag(
                            _addTagEditingController.text.trim(),
                            dialogContext,
                          ),
                          child: Text("Add"),
                        ),
                      ],
                    );
                  },
                );
              },
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

            Wrap(
              spacing: AppSpacing.smmd,
              runSpacing: AppSpacing.smmd,
              children: [
                if (attachments != null)
                  ...attachments!.map((entry) {
                    return AttachmentCard(
                      imageUrl: entry,
                      onDelete: () {
                        _handleRemoveAttachment(entry);
                      },
                      onTap: () {
                        debugPrint("View Attachment");
                      },
                    );
                  })
                else
                  Text("No attachments yet"),
              ],
            ),

            // Add Button
            TextButton.icon(
              onPressed: () async {
                await _handleFilePicker();
              },
              icon: Icon(Icons.attach_file),
              label: Text("Add Attachment"),
            ),

            SizedBox(height: AppSpacing.lg),

            //...............................
            // Split transaction
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("SPLIT TRANSACTION"),
                splits != null && splits!.isNotEmpty
                    ? TextButton(
                        onPressed: _handleSplitActions,
                        child: Text("Edit Split"),
                      )
                    : TextButton(
                        onPressed: _handleSplitActions,
                        child: Text("Add Split"),
                      ),
              ],
            ),

            splits != null && splits!.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: splits?.length,
                    itemBuilder: (context, index) {
                      final split = splits![index];
                      return Row(
                        children: [
                          Icon(getIconDataFromString(split.category)),
                          Text(split.category),
                          Spacer(),
                          Text(
                            widget.currencySymbol +
                                split.amount.toStringAsFixed(2),
                          ),
                        ],
                      );
                    },
                  )
                : Text("No items"),

            // Add & remove spliting transaction ui
            SizedBox(height: AppSpacing.lg),

            //.........................
            // Audit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Created"),
                Text(
                  formatFullDateTime(transaction.createdAt ?? DateTime.now()),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Last Updated"),
                Text(
                  formatFullDateTime(transaction.updatedAt ?? DateTime.now()),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text("Applied Rule"), Text("Auto-categorized")],
            ),

            SizedBox(height: AppSpacing.size42),
          ],
        ),
      ),

      bottomNavigationBar:
          // Delete
          FilledButton(
            onPressed: () {
              String amount = _amountController.text.replaceAll(
                RegExp(RegExp.escape(widget.currencySymbol)),
                "",
              );

              String merchantNote = _merchantController.text.trim();
              String description = _descriptionController.text.trim();

              final updatedTransaction = Transaction(
                id: id,
                amount: double.parse(amount),
                category: categoryText,
                type: selectedType!,
                merchant_note: merchantNote,
                date_time: dateTime,
                account: account,
                description: description,
                tags: tags,
                isTransfer: isTransfer,
                isRecurring: isRecurring,
                attachments: attachments,
                splits: splits,
                createdAt: createdAt,
                updatedAt: DateTime.now(),
                appliedRule: appliedRule,
              );

              _handleSubmitTransaction(updatedTransaction);
            },
            child: Text("Save Changes"),
          ),
    );
  }
}
