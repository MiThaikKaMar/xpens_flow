// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/router/routes.dart';

import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({super.key, required this.transactionId});

  final int transactionId;

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  @override
  Widget build(BuildContext context) {
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
                context.push(
                  Routes.transactionEdit.replaceAll(
                    ':id',
                    widget.transactionId.toString(),
                  ),
                );
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
              onPressed: () {},
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
            Text("Transaction detailed ID: ${widget.transactionId}"),

            // Top part
            Text("-\$2,847.50"),
            Text('Chase Checking'),

            /// Account
            ///Chase: This is the name of a well-known major bank (JPMorgan Chase).
            ///Checking: This indicates the type of account at Chase Bank. A checking account is a standard deposit account that allows for easy access to funds for everyday transactions like paying bills, making purchases, etc.
            ///the visual element showing "Chase Checking" below the transaction amount (-\$2,847.50) signifies that this rent payment was debited from your Chase checking account.
            Text("Posted Jan 15, 2024"),
            Divider(),

            //..................................

            /// Info Part
            ListTile(
              leading: Icon(Icons.house),
              title: Text("Housing & Utilities"),
              subtitle: Text("Tap to edit"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),

            /// Merchant
            Text("MERCHANT"),
            Text("Property Management Co."),

            /// Description
            Text("DESCRIPTION"),
            Text("Monthly rent payment - January 2024"),
            Divider(),

            //....................................
            /// Tags
            Text("TAGS"),
            ChoiceChip(label: Text("Essential"), selected: true),
            Divider(),

            //........................................

            //Attachments
            Text("ATTACHMENTS"),
            Container(
              color: AppColors.darkBlueBgLight,
              width: AppSpacing.size100,
              height: AppSpacing.size100,
            ),
            Divider(),

            //......................
            // Split Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("SPLIT DETAILS"),
                TextButton(onPressed: () {}, child: Text("Edit Split")),
              ],
            ),
            ListTile(
              leading: Icon(Icons.house),
              title: Text("Rent"),
              trailing: Text("-\$2,500.00"),
            ),
            ListTile(
              leading: Icon(Icons.bolt),
              title: Text("Utilities"),
              trailing: Text("-\$347.50"),
            ),
            Divider(),
            //.............................
            // Rules
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Mark as Transfer"),
                Switch(value: false, onChanged: (bool value) {}),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recurring Transaction"),
                Switch(value: true, onChanged: (bool value) {}),
              ],
            ),
            Divider(),

            //................................
            //Audit
            Text("AUDIT TRAIL"),
            Text("Created: Jan 15, 2024 at 9:32 AM"),
            Text("Updated: Jan 15, 2024 at 9:35 AM"),
            SizedBox(height: AppSpacing.md),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Rule applied:"),
                  TextSpan(text: "Monthly Rent Auto-categorize"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
