// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/router/routes.dart';
import 'package:xpens_flow/core/ui/format/date_format.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';
import 'package:xpens_flow/features/transactions/presentation/state/feed/transaction_feed_bloc.dart';
import 'package:xpens_flow/features/transactions/presentation/widgets/month_header_item.dart';
import 'package:xpens_flow/features/transactions/presentation/widgets/transaction_list_item.dart';

import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/spacing.dart';

class TransactionsFeedPage extends StatefulWidget {
  final TransactionFeedBloc transactionFeedBloc;

  const TransactionsFeedPage({super.key, required this.transactionFeedBloc});

  @override
  State<TransactionsFeedPage> createState() => _TransactionsFeedPageState();
}

class _TransactionsFeedPageState extends State<TransactionsFeedPage> {
  bool _isAllChecked = false;

  @override
  void initState() {
    super.initState();
    debugPrint("Init sate trigger of transaction page");
    widget.transactionFeedBloc.add(TransactionFeedShowAll());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionFeedBloc, TransactionFeedState>(
      bloc: widget.transactionFeedBloc,
      builder: (context, state) {
        debugPrint(
          "UI: Current Bloc State is: ${state.runtimeType}",
        ); // Add this line

        if (state is TransactionFeedInitial) {
          return Center(child: const Text("Loading transactions"));
        } else if (state is TransactionFeedLoading) {
          return Center(child: const CircularProgressIndicator());
        } else if (state is TransactionFeedLoaded) {
          if (state.transactionList.isEmpty) {
            return Center(
              child: Text("No transactions found! Start adding some!"),
            );
          }

          final currencySymbol = state.currencySymbol;

          final transactions = state.transactionList;
          final sortedTransactions = List<Transaction>.from(transactions)
            ..sort((a, b) => b.date_time.compareTo(a.date_time));

          return Column(
            children: [
              // App Bar
              AppBar(
                title: Text("Transactions"),
                centerTitle: false,
                actions: [
                  // Checkable icon
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkBlueBgLight,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                    child: Transform.scale(
                      scale: 0.8,
                      child: Checkbox(
                        fillColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors
                                .transparent; // Transparent when checked
                          }
                          return Colors
                              .transparent; // Transparent when unchecked
                        }),
                        checkColor: AppColors.darkOrange.withOpacity(
                          0.7,
                        ), // Checkmark color
                        side: MaterialStateBorderSide.resolveWith((states) {
                          return BorderSide(
                            color: AppColors.darkOrange.withOpacity(0.7),
                            width: 1.5,
                          );
                        }),
                        splashRadius: 1,
                        visualDensity: VisualDensity.compact,
                        value: _isAllChecked,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isAllChecked = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),

                  //Add New Transaction
                  Container(
                    margin: EdgeInsets.only(right: AppSpacing.md),

                    decoration: BoxDecoration(
                      color: AppColors.darkBlueBgLight,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                    child: IconButton(
                      onPressed: () {
                        context.push(Routes.transactionAdd);
                      },
                      icon: Icon(
                        Icons.add,
                        size: AppSpacing.size18,
                        color: AppColors.darkOrange.withOpacity(0.7),
                      ),
                      splashRadius: 1, // Minimize splash effect
                      visualDensity: VisualDensity.compact, // Add this
                    ),
                  ),
                ],
              ),

              /// Search Section
              Container(
                height: AppSpacing.size150,
                color: AppColors.darkBlueBackground,
              ),

              // Transactions List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: sortedTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = sortedTransactions[index];

                    final isFirstOfGroup =
                        index == 0 ||
                        sortedTransactions[index].date_time.month !=
                            sortedTransactions[index - 1].date_time.month ||
                        sortedTransactions[index].date_time.year !=
                            sortedTransactions[index - 1].date_time.year;

                    return Column(
                      children: [
                        if (isFirstOfGroup)
                          MonthHeaderItem(
                            headerText: formatMonthHeader(
                              sortedTransactions[index].date_time,
                            ),
                          ),
                        TransactionListItem(
                          transaction: transaction,
                          currencySymbol: currencySymbol,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is TransactionFeedError) {
          return Center(child: Text('Fetch Error ${state.message}'));
        }
        return const Center(child: Text("An unknown error occur"));
      },
    );
  }
}
