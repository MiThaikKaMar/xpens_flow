import 'package:flutter/material.dart';
import 'package:xpens_flow/core/common/utils/icon_helper.dart';
import 'package:xpens_flow/core/ui/format/date_format.dart';
import 'package:xpens_flow/features/transactions/presentation/state/split/transaction_split_cubit.dart';

import '../../../../core/ui/theme/spacing.dart';
import '../../domain/entities/transaction.dart';

class TransactionSplitPage extends StatefulWidget {
  final int transactionId;
  final Transaction transaction;
  final String currencySymbol;
  final TransactionSplitCubit _transactionSplitCubit;

  const TransactionSplitPage({
    super.key,
    required this.transactionId,
    required this.transaction,
    required this.currencySymbol,
    required transactionSplitCubit,
  }) : _transactionSplitCubit = transactionSplitCubit;

  @override
  State<TransactionSplitPage> createState() => _TransactionSplitPageState();
}

class _TransactionSplitPageState extends State<TransactionSplitPage> {
  late Transaction transaction;
  late String currencySymbol;

  @override
  void initState() {
    super.initState();

    transaction = widget.transaction;
    currencySymbol = widget.currencySymbol;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.close),
        title: Text("Split Transaction"),
        actions: [TextButton(onPressed: () {}, child: Text("Save"))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //.............................
            //Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ListTile(
                  leading: Icon(getIconDataFromString(transaction.category)),
                  title: Text(transaction.category),
                  subtitle: Text(formatFullDateTime(transaction.date_time)),
                ),
                Text("$currencySymbol${transaction.amount}"),
                Text("Total to split"),
              ],
            ),
            Divider(),

            //...........................
            // Remaining
            ListTile(
              title: Text("Remaining to allocate"),
              subtitle: Text("$currencySymbol${transaction.amount}"),
              // trailing: IconButton.filled(
              //   onPressed: () {
              //     //scroll to quick split
              //   },
              //   icon: Icon(Icons.content_cut),
              // ),
            ),
            SizedBox(height: AppSpacing.lg),

            //........................
            // Create Split
            Text("Create Split"),

            SizedBox(height: AppSpacing.md),
            // Category
            Text("Category"),
            PopupMenuButton(
              itemBuilder: (context) {
                return [PopupMenuItem(child: Text("data"))];
              },
              child: ListTile(
                title: Text("Select category"),
                trailing: Icon(Icons.arrow_drop_down),
              ),
            ),
            SizedBox(height: AppSpacing.md),

            //....................
            // Amount
            Text("Amount"),
            TextField(),

            SizedBox(height: AppSpacing.md),

            //.....................
            //Note
            Text("Note (optional)"),
            TextField(decoration: InputDecoration(hintText: "Add a note...")),
            SizedBox(height: AppSpacing.lg),

            //..........................

            // Quick Split
            Text("Quick Split"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Card(
                  child: Column(children: [Text("1/2"), Text("Split in half")]),
                ),
                Card(
                  child: Column(
                    children: [Text("1/3"), Text("Split in thirds")],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),

            //.............................
            // Current Splits
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text("Current Splits"), Text("0 of 1")],
            ),
            Text("No splits created yet"),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [FilledButton(onPressed: () {}, child: Text("Add Split"))],
      ),
    );
  }
}

//Usage -> https://poe.com/s/73p3BYJFtaGI5A8xGnog
