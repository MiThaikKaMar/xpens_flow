import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpens_flow/core/common/utils/icon_helper.dart';
import 'package:xpens_flow/core/ui/format/date_format.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction_split.dart';
import 'package:xpens_flow/features/transactions/presentation/state/split/transaction_split_cubit.dart';

import '../../../../core/ui/theme/spacing.dart';
import '../../domain/entities/transaction.dart';

class TransactionSplitPage extends StatefulWidget {
  final int transactionId;
  final Transaction transaction;
  final String currencySymbol;
  final List<TransactionSplit>? existingSplits;

  const TransactionSplitPage({
    super.key,
    required this.transactionId,
    required this.transaction,
    required this.currencySymbol,
    this.existingSplits,
  });

  @override
  State<TransactionSplitPage> createState() => _TransactionSplitPageState();
}

class _TransactionSplitPageState extends State<TransactionSplitPage> {
  late Transaction transaction;
  late int transactionId;
  late String currencySymbol;
  late String newSplitCategory;

  late TextEditingController _newAmountController;
  late TextEditingController _newNoteController;

  //late List<CategoryModel>? allCategories;

  @override
  void initState() {
    super.initState();

    transaction = widget.transaction;
    transactionId = transaction.id!;
    currencySymbol = widget.currencySymbol;

    newSplitCategory = 'Select category';

    _newAmountController = TextEditingController();
    _newNoteController = TextEditingController();

    debugPrint("Existing Splits : ${widget.existingSplits?.length}");
    // Initialize everything at once
    context.read<TransactionSplitCubit>().loadCategoriesAndInitialize(
      transaction.amount,
      initialSplits: widget.existingSplits,
    );
    //Initialize split management and load categories
    // context.read<TransactionSplitCubit>().initializeSplitManagement(
    //   transaction.amount,
    // );
    //context.read<TransactionSplitCubit>().loadAllCategories();
    context.read<TransactionSplitCubit>().updateCategory(newSplitCategory);

    // Listen to text field changes
    _newAmountController.addListener(() {
      final amount = double.tryParse(_newAmountController.text);
      context.read<TransactionSplitCubit>().updateAmount(amount);
    });

    _newNoteController.addListener(() {
      context.read<TransactionSplitCubit>().updateNote(_newNoteController.text);
    });
  }

  @override
  void dispose() {
    _newAmountController.dispose();
    _newNoteController.dispose();
    super.dispose();
  }

  Widget _buildSplitContent(BuildContext context, SplitManagementState state) {
    //Get categories from the cubit directly
    final cubit = context.read<TransactionSplitCubit>();
    final allCategories = cubit.allCategories;
    return SingleChildScrollView(
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
          // Remaining to allocate
          ListTile(
            title: Text("Remaining to allocate"),
            subtitle: Text(
              "$currencySymbol${state.remainingToAllocate.toStringAsFixed(2)}",
            ),
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
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                newSplitCategory = value;
              });
              context.read<TransactionSplitCubit>().updateCategory(value);
            },
            itemBuilder: (context) {
              if (allCategories != null) {
                return allCategories.map((category) {
                  return PopupMenuItem(
                    value: category.label,
                    child: Text(category.label),
                  );
                }).toList();
              }
              return [
                PopupMenuItem(
                  value: 'No categories',

                  enabled: false,
                  child: Text('No categories available'),
                ),
              ];
            },

            child: ListTile(
              title: Text(
                newSplitCategory != 'Select category'
                    ? newSplitCategory
                    : 'Select a category',
              ),
              trailing: Icon(Icons.arrow_drop_down),
              // subtitle: allCategories != null
              //     ? Text('${allCategories.length} categories available')
              //     : Text('Loading categories...'),
            ),
          ),
          SizedBox(height: AppSpacing.md),

          //....................
          // Amount
          Text("Amount"),
          TextField(
            controller: _newAmountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: '0.0'),
          ),

          SizedBox(height: AppSpacing.md),

          //.....................
          //Note
          Text("Note (optional)"),
          TextField(
            controller: _newNoteController,
            decoration: InputDecoration(hintText: "Add a note..."),
          ),
          SizedBox(height: AppSpacing.lg),

          //..........................

          // Quick Split
          Text("Quick Split"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  context.read<TransactionSplitCubit>().splitInHalf(
                    transactionId,
                  );
                },
                child: Card(
                  child: Column(children: [Text("1/2"), Text("Split in half")]),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<TransactionSplitCubit>().splitInThirds(
                    transactionId,
                  );
                },
                child: Card(
                  child: Column(
                    children: [Text("1/3"), Text("Split in thirds")],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),

          //.............................
          // Current Splits
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Current Splits"),
              Text("${state.splitCount} of ${state.maxSplits}"),
            ],
          ),
          if (state.currentSplits.isEmpty)
            Text("No splits created yet")
          else
            Column(
              children: state.currentSplits.map((split) {
                return ListTile(
                  title: Text(split.category),
                  subtitle: split.note != null ? Text(split.note!) : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${widget.currencySymbol}${split.amount.toStringAsFixed(2)}",
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<TransactionSplitCubit>().removeSplit(
                            split.id,
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("Split Transaction"),
        actions: [
          TextButton(
            onPressed: () {
              context.read<TransactionSplitCubit>().saveSplits();
            },
            child: Text("Save"),
          ),
        ],
      ),
      body: BlocConsumer<TransactionSplitCubit, TransactionSplitState>(
        listener: (context, state) {
          if (state is SplitManagementState && state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }

          // Handle successful save
          if (state is SplitsSavedSuccess) {
            Navigator.of(context).pop(state.splits);
          }
          //Handle categories loaded
          // if (state is CategoriesLoaded) {
          //   allCategories = state.categories;
          //   context.read<TransactionSplitCubit>().initializeSplitManagement(
          //     transaction.amount,
          //   );
          // }
        },
        builder: (context, state) {
          // if (state is CategoriesLoading) {
          //   return Center(child: CircularProgressIndicator());
          // }
          if (state is CategoriesLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading categories...'),
                ],
              ),
            );
          }

          // if (state is CategoriesError) {
          //   return Center(child: Text("Error: ${state.message}"));
          // }
          if (state is CategoriesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text("Error: ${state.message}"),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<TransactionSplitCubit>()
                          .loadCategoriesAndInitialize(transaction.amount);
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // if (state is CategoriesLoaded) {
          //   allCategories = state.categories;
          //   context.read<TransactionSplitCubit>().initializeSplitManagement(
          //     transaction.amount,
          //   );
          //   return Container();
          // }

          if (state is SplitManagementState) {
            return _buildSplitContent(context, state);
          }
          // Fallback
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Initializing...'),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar:
          BlocBuilder<TransactionSplitCubit, TransactionSplitState>(
            builder: (context, state) {
              if (state is SplitManagementState) {
                return FilledButton(
                  onPressed: () {
                    context.read<TransactionSplitCubit>().addSplit(
                      transactionId,
                    );
                    // Clear form
                    _newAmountController.clear();
                    _newNoteController.clear();
                    setState(() {
                      newSplitCategory = 'Select category';
                    });
                  },
                  child: Text("Add Split"),
                );
              }
              return Container();
            },
          ),
    );
  }
}
