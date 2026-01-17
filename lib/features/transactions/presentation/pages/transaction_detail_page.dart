// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/router/routes.dart';
import 'package:xpens_flow/core/common/utils/icon_helper.dart';
import 'package:xpens_flow/core/ui/format/date_format.dart';
import 'package:xpens_flow/features/transactions/presentation/state/action/transaction_action_cubit.dart';
import 'package:xpens_flow/features/transactions/presentation/widgets/attachment_card.dart';

import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_split.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({
    super.key,
    required this.transactionId,
    required this.transaction,
    required this.currencySymbol,
  });

  final int transactionId;
  final Transaction transaction;
  final String currencySymbol;

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  late String _amountText;
  late bool _isExpense;
  late Transaction transaction;

  @override
  void initState() {
    super.initState();
    transaction = widget.transaction;
    _isExpense = widget.transaction.type == TransactionType.expense;
  }

  void _deleteTransaction() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete Transaction?"),
          content: const Text(
            "This action cannot be undone. \n Are you sure you want to delete this transaction?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<TransactionActionCubit>().delete(transaction.id!);
                Navigator.pop(dialogContext);
                context.pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _amountText = _isExpense
        ? "-${widget.currencySymbol}${transaction.amount}"
        : "+${widget.currencySymbol}${transaction.amount}";

    String categoryText = transaction.category;
    String merchantNote = transaction.merchant_note ?? '';
    // TransactionType type = transaction.type;
    // DateTime dateTime = transaction.date_time;
    String? account = transaction.account;
    String? description = transaction.description;
    List<String>? tags = transaction.tags;
    bool isTransfer = transaction.isTransfer;
    bool isRecurring = transaction.isRecurring;
    List<String>? attachments = transaction.attachments;
    List<TransactionSplit>? splits = transaction.splits;
    DateTime? createdAt = transaction.createdAt;
    DateTime? updatedAt = transaction.updatedAt;
    String? appliedRule = transaction.appliedRule;

    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Details"),
        centerTitle: false,
        actions: [
          // Edit the transaction
          Container(
            decoration: BoxDecoration(
              color: AppColors.darkBlueBgLight,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: IconButton(
              onPressed: () {
                context
                    .push(
                      Routes.transactionEdit.replaceAll(
                        ':id',
                        widget.transactionId.toString(),
                      ),
                      extra: {
                        'transaction': transaction,
                        'symbol': widget.currencySymbol,
                      },
                    )
                    .then((result) {
                      if (result != null) {
                        setState(() {
                          transaction = result as Transaction;
                        });
                      }
                    });
              },
              icon: Icon(
                Icons.edit,
                size: AppSpacing.size18,
                color: AppColors.darkOrange.withOpacity(0.7),
              ),
              splashRadius: 1, // Minimize splash effect
              visualDensity: VisualDensity.compact, // Add this
            ),
          ),
          SizedBox(width: AppSpacing.sm),

          //Delete the transaction
          Container(
            margin: EdgeInsets.only(right: AppSpacing.md),

            decoration: BoxDecoration(
              color: AppColors.darkBlueBgLight,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: IconButton(
              onPressed: _deleteTransaction,
              icon: Icon(
                Icons.delete,
                size: AppSpacing.size18,
                color: AppColors.error,
              ),
              splashRadius: 1, // Minimize splash effect
              visualDensity: VisualDensity.compact, // Add this
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text("Transaction detailed ID: ${widget.transactionId}"),

            // Top part
            Text(_amountText),
            Visibility(visible: account != null, child: Text('Chase Checking')),

            /// Account
            ///Chase: This is the name of a well-known major bank (JPMorgan Chase).
            ///Checking: This indicates the type of account at Chase Bank. A checking account is a standard deposit account that allows for easy access to funds for everyday transactions like paying bills, making purchases, etc.
            ///the visual element showing "Chase Checking" below the transaction amount (-\$2,847.50) signifies that this rent payment was debited from your Chase checking account.
            Text("Posted ${formatFullDate(widget.transaction.date_time)}"),
            Divider(),

            //..................................

            /// Info Part
            ListTile(
              leading: Icon(getIconDataFromString(categoryText)),
              title: Text(categoryText),
            ),

            /// Merchant
            Visibility(
              visible: merchantNote != '',
              child: Column(children: [Text("MERCHANT"), Text(merchantNote)]),
            ),

            /// Description
            Visibility(
              visible: description != null,
              child: Column(
                children: [Text("DESCRIPTION"), Text(description ?? '')],
              ),
            ),

            Divider(),

            //....................................
            /// Tags
            Visibility(
              visible: tags != null,
              child: Column(
                children: [
                  Text("TAGS"),
                  Row(
                    children: tags == null
                        ? []
                        : tags.asMap().entries.map((tag) {
                            return ChoiceChip(
                              label: Text(tag.value),
                              selected: true,
                            );
                          }).toList(),
                  ),

                  Divider(),
                ],
              ),
            ),

            //........................................

            //Attachments
            Visibility(
              visible: attachments != null,
              child: Column(
                children: [
                  Text("ATTACHMENTS"),
                  Row(
                    children: attachments == null
                        ? []
                        : attachments.map((attachment) {
                            return AttachmentCard(
                              imageUrl: attachment,
                              isDeletable: false,
                              onDelete: () {},
                              onTap: () {},
                            );
                          }).toList(),
                  ),

                  Divider(),
                ],
              ),
            ),

            //......................
            // Split Details
            Visibility(
              visible: splits != null && splits.isNotEmpty,
              child: Column(
                children: [
                  Text("SPLIT DETAILS"),
                  Column(
                    children: splits == null
                        ? []
                        : splits.map((item) {
                            return ListTile(
                              leading: Icon(
                                getIconDataFromString(item.category),
                              ),
                              title: Text(item.category),
                              trailing: Text(item.amount.toString()),
                            );
                          }).toList(),
                  ),

                  Divider(),
                ],
              ),
            ),
            //.............................
            // Rules
            Visibility(
              visible: isTransfer,
              child: Row(
                children: [
                  Checkbox(value: true, onChanged: (bool? value) {}),
                  Text("Mark as Transfer"),
                ],
              ),
            ),
            Visibility(
              visible: isRecurring,
              child: Row(
                children: [
                  Checkbox(value: true, onChanged: (bool? value) {}),
                  Text("Recurring Transaction"),
                  Divider(),
                ],
              ),
            ),

            //................................
            //Audit
            Text("AUDIT TRAIL"),
            Text("Created: ${formatFullDateTime(createdAt!)}"),
            Visibility(
              visible: updatedAt != null,
              child: Text("Updated: ${formatFullDateTime(updatedAt!)}"),
            ),
            SizedBox(height: AppSpacing.md),
            Visibility(
              visible: appliedRule != null,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Rule applied:"),
                    TextSpan(text: "Monthly Rent Auto-categorize"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
