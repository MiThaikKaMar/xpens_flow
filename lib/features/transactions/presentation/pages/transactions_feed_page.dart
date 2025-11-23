import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpens_flow/core/ui/format/date_format.dart';
import 'package:xpens_flow/features/transactions/presentation/state/feed/transaction_feed_bloc.dart';

class TransactionsFeedPage extends StatefulWidget {
  final TransactionFeedBloc transactionFeedBloc;

  const TransactionsFeedPage({super.key, required this.transactionFeedBloc});

  @override
  State<TransactionsFeedPage> createState() => _TransactionsFeedPageState();
}

class _TransactionsFeedPageState extends State<TransactionsFeedPage> {
  @override
  void initState() {
    super.initState();
    debugPrint("Init sate trigger of transaction page");
    widget.transactionFeedBloc.add(TransactionFeedShowAll());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TransactionFeedBloc, TransactionFeedState>(
        bloc: widget.transactionFeedBloc,
        builder: (context, state) {
          debugPrint(
            "UI: Current Bloc State is: ${state.runtimeType}",
          ); // Add this line

          if (state is TransactionFeedInitial) {
            return const Text("Loading transactions");
          } else if (state is TransactionFeedLoading) {
            return const CircularProgressIndicator();
          } else if (state is TransactionFeedLoaded) {
            if (state.transactionList.isEmpty) {
              return Center(
                child: Text("No transactions found! Start adding some!"),
              );
            }

            return ListView.builder(
              itemCount: state.transactionList.length,
              itemBuilder: (context, index) {
                final transaction = state.transactionList[index];
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(transaction.merchant_note ?? ''),
                        Text(transaction.amount.toString()),
                      ],
                    ),
                    Row(
                      children: [
                        Text(transaction.category),
                        Text(formatDateTime(transaction.date_time)),
                      ],
                    ),
                  ],
                );
              },
            );
          } else if (state is TransactionFeedError) {
            return Center(child: Text('Fetch Error ${state.message}'));
          }
          return const Center(child: Text("An unknown error occur"));
        },
      ),
    );
  }
}
