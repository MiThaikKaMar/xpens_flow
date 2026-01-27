// ignore_for_file: deprecated_member_use

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xpens_flow/core/common/utils/icon_helper.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction_split.dart';
import 'package:xpens_flow/features/transactions/presentation/state/editor/transaction_editor_bloc.dart';
import 'package:xpens_flow/features/transactions/presentation/state/feed/transaction_feed_bloc.dart';

import '../../../../core/data/models/category_model.dart';
import '../../../../core/ui/format/date_format.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../core/ui/theme/typography.dart';
import '../../domain/entities/transaction.dart';
import '../widgets/attachment_card.dart';

class TransactionAddPage extends StatefulWidget {
  final TransactionEditorBloc _transactionEditorBloc;
  final TransactionFeedBloc _transactionFeedBloc;

  const TransactionAddPage({
    super.key,
    required transactionEditorBloc,
    required transactionFeedBloc,
  }) : _transactionFeedBloc = transactionFeedBloc,
       _transactionEditorBloc = transactionEditorBloc;

  @override
  State<TransactionAddPage> createState() => _TransactionAddPageState();
}

class _TransactionAddPageState extends State<TransactionAddPage> {
  final TextEditingController _amountEditingController =
      TextEditingController();
  final TextEditingController _merchantEditingController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> attachments = [];
  List<TransactionSplit> splits = [];
  bool isRecurring = false;

  final ImagePicker picker = ImagePicker();

  TransactionType? selectedType = TransactionType.expense;
  String selecedAccount = Accounts.mainChecking.name;
  DateTime displayDateTime = DateTime.now();
  String categoryText = '';
  List<String> tags = [];
  String currencySymbol = '';

  late TextEditingController _addTagEditingController;

  double _getEditedAmount() {
    return double.parse(
      _amountEditingController.text.replaceAll(
        RegExp(RegExp.escape(currencySymbol)),
        '',
      ),
    );
  }

  void _handleAddTag(String tag, BuildContext dialogContext) {
    tags.add(tag);
    setState(() {
      Navigator.pop(dialogContext);
    });
  }

  void _handleSaveTransaction(Transaction transaction) {
    debugPrint('''New transaction: ${transaction.id}, ${transaction.amount},
    ${transaction.type} , ${transaction.category}, ${transaction.account}, ${transaction.merchant_note},
${transaction.date_time}, ${transaction.description}, ${transaction.tags} , 
${transaction.isTransfer}, ${transaction.isRecurring}, ${transaction.attachments},
${transaction.splits}, ${transaction.createdAt}, ${transaction.updatedAt}

    ''');

    if (_getEditedAmount() == 0.0) {
      //showSnackbar(context, "Amount can not be empty");
      debugPrint("Amount can not be empty");
      return;
    }

    if (categoryText.isEmpty) {
      //showSnackbar(context, "Please select a category");
      debugPrint("Please select a category");
      return;
    }
    widget._transactionFeedBloc.add(
      TransactionFeedAdd(transaction: transaction),
    );

    context.pop();
  }

  Future<void> _handleFilePicker() async {
    String? filePath;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'image/jpeg', 'image/png'],
    );

    if (result != null) {
      filePath = result.files.single.path!;
      debugPrint("FilePath: $filePath");

      setState(() {
        attachments.add(filePath!);
      });
    } else {
      //User canceled the picker
    }
  }

  Future<void> _handlePhotoCapture() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    String? filePath;

    if (photo != null) {
      filePath = photo.path;
      debugPrint("FilePath: $filePath");

      setState(() {
        attachments.add(filePath!);
      });
    } else {
      //User canceled the picker
    }
  }

  void _handleRemoveAttachment(String filePath) {
    setState(() {
      attachments.remove(filePath);
    });
  }

  @override
  void initState() {
    super.initState();

    widget._transactionEditorBloc.add(LoadAllCategories());
    widget._transactionEditorBloc.add(LoadCurrency());

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
              BlocBuilder<TransactionEditorBloc, TransactionEditorState>(
                builder: (context, state) {
                  if (state is CurrencyError) {
                    return Text(
                      currencySymbol,
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w100,
                      ),
                    );
                  }
                  if (state is CurrencyLoaded) {
                    currencySymbol = state.currency;
                    return Text(
                      currencySymbol,
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.w100,
                      ),
                    );
                  }
                  return Text(
                    currencySymbol,
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.w100),
                  );
                },
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
                controller: _amountEditingController,
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
                  TextField(controller: _merchantEditingController),
                  Divider(),
                  Text("Suggested"),
                  Row(
                    children: ["Starbucks ", "KFC ", "McDonald’s ", "Uber"].map(
                      (merchant) {
                        return GestureDetector(
                          onTap: () => setState(() {
                            _merchantEditingController.text = merchant;
                          }),
                          child: Text(merchant),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.lg),

              //............Description.............
              Text("Description"),
              TextField(controller: _descriptionController),

              SizedBox(height: AppSpacing.lg),

              //.............Category...................
              BlocBuilder<TransactionEditorBloc, TransactionEditorState>(
                buildWhen: (previous, current) {
                  // only rebuild when categories states change
                  return current is CategoriesLoaded ||
                      current is CategoriesLoading ||
                      current is CategoriesError;
                },
                builder: (context, state) {
                  if (state is CategoriesLoading) {
                    return PopupMenuButton(
                      enabled: false,
                      itemBuilder: (context) => [],
                      child: ListTile(
                        leading: Icon(getIconDataFromString(categoryText)),
                        title: Text("Category"),
                        subtitle: Text("Loading..."),
                        trailing: Icon(Icons.arrow_drop_down),
                      ),
                    );
                  }

                  if (state is CategoriesError) {
                    return PopupMenuButton(
                      enabled: false,
                      itemBuilder: (context) => [],
                      child: ListTile(
                        leading: Icon(getIconDataFromString(categoryText)),
                        title: Text("Category"),
                        subtitle: Text("Error loading"),
                        trailing: Icon(Icons.arrow_drop_down),
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

                      child: ListTile(
                        leading: Icon(getIconDataFromString(categoryText)),
                        title: Text("Category"),
                        subtitle: Text(
                          categoryText == '' ? "Select category" : categoryText,
                        ),
                        trailing: Icon(Icons.arrow_drop_down),
                      ),
                    );
                  }

                  return PopupMenuButton<CategoryModel>(
                    enabled: false,
                    itemBuilder: (context) => [],

                    child: ListTile(
                      leading: Icon(getIconDataFromString(categoryText)),
                      title: Text("Category"),
                      subtitle: Text("Something wrong!"),
                      trailing: Icon(Icons.arrow_drop_down),
                    ),
                  );
                },
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
              Wrap(
                spacing: AppSpacing.smmd,
                runSpacing: AppSpacing.smmd,
                children: [
                  if (attachments.isNotEmpty)
                    ...attachments.map((entry) {
                      return AttachmentCard(
                        imageUrl: entry,
                        isDeletable: true,
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
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () async {
                      await _handlePhotoCapture();
                    },
                    child: Text("Camera"),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      await _handleFilePicker();
                    },
                    child: Text("Gallery"),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.lg),

              //............Recurring Transaction..........
              ListTile(
                title: Text("Recurring Transaction"),
                subtitle: Text("Set up automatic entires"),
                trailing: Switch(
                  value: isRecurring,
                  onChanged: (value) {
                    setState(() {
                      isRecurring = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              _handleSaveTransaction(newTransaction());
            },
            child: Text("Save Transaction"),
          ),
        ],
      ),
    );
  }

  Transaction newTransaction() {
    String amount = _amountEditingController.text.trim();
    String merchantNote = _merchantEditingController.text.trim();
    String descriptionText = _descriptionController.text.trim();
    bool isTransfer = TransactionType.transfer == selectedType;

    // //Validations
    // if (amount == '') return;

    final newTransaction = Transaction(
      id: null,
      amount: double.parse(amount),
      category: categoryText,
      type: selectedType!,
      merchant_note: merchantNote,
      date_time: displayDateTime,
      account: selecedAccount,
      description: descriptionText,
      tags: tags,
      isTransfer: isTransfer,
      isRecurring: isRecurring,
      attachments: attachments,
      splits: splits,
      createdAt: displayDateTime,
      updatedAt: displayDateTime,

      // appliedRule: appliedRule,
    );

    return newTransaction;
  }
}
