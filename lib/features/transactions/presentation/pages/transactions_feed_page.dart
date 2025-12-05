import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpens_flow/features/transactions/presentation/state/feed/transaction_feed_bloc.dart';
import 'package:xpens_flow/features/transactions/presentation/widgets/transaction_list_item.dart';

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

            final currencySymbol = state.currencySymbol;

            return ListView.builder(
              itemCount: state.transactionList.length,
              itemBuilder: (context, index) {
                final transaction = state.transactionList[index];
                return TransactionListItem(
                  transaction: transaction,
                  currencySymbol: currencySymbol,
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
