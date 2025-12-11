// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:xpens_flow/core/ui/theme/spacing.dart';

import '../../../../core/ui/format/date_format.dart';
import '../../../../core/ui/theme/app_theme.dart';

class TransactionEditorPage extends StatefulWidget {
  const TransactionEditorPage({super.key, required this.transactionId});

  final int transactionId;

  @override
  State<TransactionEditorPage> createState() => _TransactionEditorPageState();
}

class _TransactionEditorPageState extends State<TransactionEditorPage> {
  @override
  Widget build(BuildContext context) {
    DateTime displayDateTime = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Transaction"),
        actions: [Icon(Icons.done)],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ///Amount
            Text("AMOUNT"),
            TextField(),
            SizedBox(height: AppSpacing.lg),

            //...............
            ///Account
            Text("ACCOUNT"),
            //DropdownMenu(dropdownMenuEntries: dropdownMenuEntries),
            SizedBox(height: AppSpacing.lg),

            //.................
            /// Date
            Text("DATE"),
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
            SizedBox(height: AppSpacing.lg),

            //.......................
            /// Category
            Text("CATEGORY"),
            //DropdownMenu(dropdownMenuEntries: dropdownMenuEntries),
            SizedBox(height: AppSpacing.lg),

            ///.............................
            ///Merchant
            Text("MERCHANT"),
            TextField(),
            SizedBox(height: AppSpacing.lg),

            ///........................
            ///Description
            Text("DESCRIPTION"),
            TextField(),
            SizedBox(height: AppSpacing.lg),

            //...........................
            // Tags
            Text("TAGS"),
            // Add & remove tag ui
            SizedBox(height: AppSpacing.lg),

            //...............................
            // Split transaction
            Text("SPLIT TRANSACTION"),
            // Add & remove spliting transaction ui
            SizedBox(height: AppSpacing.lg),

            //......................
            /// Rules
            Row(
              children: [
                Checkbox(value: false, onChanged: (bool? value) {}),
                Text("Mark as Transfer"),
              ],
            ),
            Row(
              children: [
                Checkbox(value: false, onChanged: (bool? value) {}),
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
          ],
        ),
      ),

      bottomNavigationBar:
          // Delete
          FilledButton(onPressed: () {}, child: Text("Delete Transaction")),
    );
  }
}
