// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:xpens_flow/core/common/utils/icon_helper.dart';

import '../../../../core/data/models/category_model.dart';
import '../../../../core/ui/format/date_format.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../core/ui/theme/typography.dart';
import '../../domain/entities/transaction.dart';

class TransactionAddPage extends StatefulWidget {
  const TransactionAddPage({super.key});

  @override
  State<TransactionAddPage> createState() => _TransactionAddPageState();
}

class _TransactionAddPageState extends State<TransactionAddPage> {
  final TextEditingController amountEditingController = TextEditingController();
  final TextEditingController noteEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  TransactionType? selectedType = TransactionType.expense;
  String selecedAccount = Accounts.mainChecking.name;
  DateTime displayDateTime = DateTime.now();
  String categoryText = '';
  List<String> tags = [];

  late TextEditingController _addTagEditingController;

  void _handleAddTag(String tag, BuildContext dialogContext) {
    tags.add(tag);
    setState(() {
      Navigator.pop(dialogContext);
    });
  }

  @override
  void initState() {
    super.initState();

    _addTagEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Transaction")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ............Amount..............
              Text("Amount"),
              SizedBox(height: AppSpacing.sm),
              Text(
                "\$",
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

              //.............Type...............
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

              //..........Account & Date..................
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //.............Account............
                  Column(
                    children: [
                      Text("Account"),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          setState(() {
                            selecedAccount = value;
                          });
                        },
                        itemBuilder: (context) {
                          return Accounts.values.map((account) {
                            return PopupMenuItem(
                              value: account.name,
                              child: Row(
                                children: [
                                  Icon(getIconDataFromAccountText(account)),
                                  Text(account.name),
                                ],
                              ),
                            );
                          }).toList();
                        },
                        child: Row(
                          children: [
                            Text(selecedAccount),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ],
                  ),

                  //............Date.................
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Date"),
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
                            Icon(
                              Icons.calendar_today,
                              size: AppSpacing.size18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.lg),

              //............Merchant.................
              Column(
                children: [
                  Text("Merchant"),
                  TextField(),
                  Divider(),
                  Text("Suggested"),
                  Row(
                    children: ["Starbucks ", "KFC "].map((merchant) {
                      return Text(merchant);
                    }).toList(),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.lg),

              //............Description.............
              Text("Description"),
              TextField(),

              SizedBox(height: AppSpacing.lg),

              //.............Category...................
              PopupMenuButton<CategoryModel>(
                onSelected: (categoryModel) {
                  setState(() {
                    categoryText = categoryModel.label;
                  });
                },
                itemBuilder: (context) {
                  return [
                    CategoryModel(label: "Hello", iconName: 'Icons.house'),
                    CategoryModel(label: "Hello2", iconName: 'Icons.house'),
                  ].map((category) {
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

                child: ListTile(
                  leading: Icon(getIconDataFromString(categoryText)),
                  title: Text("Category"),
                  subtitle: Text(categoryText),
                  trailing: Icon(Icons.arrow_drop_down),
                ),
              ),

              //............Tags.................
              Text("Tags"),
              SizedBox(
                height: 48, // fixed height for alignment
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: tags.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    // Last item = Add Tag button
                    if (index == tags.length) {
                      return Center(
                        child: TextButton.icon(
                          onPressed: () {
                            _addTagEditingController.clear();
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  title: const Text("Add New Tag"),
                                  content: TextField(
                                    controller: _addTagEditingController,
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () => _handleAddTag(
                                        _addTagEditingController.text.trim(),
                                        dialogContext,
                                      ),
                                      child: const Text("Add"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Add Tag"),
                        ),
                      );
                    }

                    // Tag chip
                    return Center(child: Chip(label: Text(tags[index])));
                  },
                ),
              ),

              SizedBox(height: AppSpacing.lg),

              //.............Receipt.................
              Text("Receipt"),
              Row(
                children: [
                  OutlinedButton(onPressed: () {}, child: Text("Camera")),
                  OutlinedButton(onPressed: () {}, child: Text("Gallery")),
                ],
              ),

              SizedBox(height: AppSpacing.lg),

              //............Recurring Transaction..........
              ListTile(
                title: Text("Recurring Transaction"),
                subtitle: Text("Set up automatic entires"),
                trailing: Switch(value: false, onChanged: (value) {}),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(onPressed: () {}, child: Text("Save Transaction")),
          TextButton(onPressed: () {}, child: Text("Split Transaction")),
        ],
      ),
    );
  }
}
