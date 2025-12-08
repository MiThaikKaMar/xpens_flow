import 'package:flutter/material.dart';

class TransactionEditorPage extends StatefulWidget {
  const TransactionEditorPage({super.key, required this.transactionId});

  final int transactionId;

  @override
  State<TransactionEditorPage> createState() => _TransactionEditorPageState();
}

class _TransactionEditorPageState extends State<TransactionEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Transaction")),
      body: Center(child: Text("Transaction Editor Page")),
    );
  }
}
