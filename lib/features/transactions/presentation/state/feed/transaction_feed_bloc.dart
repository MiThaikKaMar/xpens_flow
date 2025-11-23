import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpens_flow/core/domain/usecases/usecase.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction.dart';
import 'package:xpens_flow/features/transactions/domain/usecases/add_transaction.dart';
import 'package:xpens_flow/features/transactions/domain/usecases/list_transactions.dart';

part 'transaction_feed_event.dart';
part 'transaction_feed_state.dart';

class TransactionFeedBloc
    extends Bloc<TransactionFeedEvent, TransactionFeedState> {
  final AddTransaction _addTransaction;
  final ListTransactions _listTransactions;

  TransactionFeedBloc({required addTransaction, required listTransactions})
    : _addTransaction = addTransaction,
      _listTransactions = listTransactions,
      super(TransactionFeedInitial()) {
    // on<TransactionFeedEvent>((_, emit) {
    //   emit(TransactionFeedLoading());
    // });
    on<TransactionFeedAdd>(_onTransactionFeedAdd);
    on<TransactionFeedShowAll>(_onTransactionFeedShowAll);
  }

  _onTransactionFeedShowAll(
    TransactionFeedShowAll event,
    Emitter<TransactionFeedState> emit,
  ) async {
    emit(TransactionFeedLoading());

    final result = await _listTransactions.call(NoParams());

    result.fold(
      (e) {
        debugPrint("Error Fetching transacton: ${e.message}");
        emit(TransactionFeedError(message: e.message));
      },
      (list) {
        debugPrint("All transation fetched: $list");
        emit(TransactionFeedLoaded(transactionList: list));
      },
    );
  }

  _onTransactionFeedAdd(
    TransactionFeedAdd event,
    Emitter<TransactionFeedState> emit,
  ) async {
    debugPrint(
      "Bloc: Attempting to add transaction with note: ${event.transaction.merchant_note}",
    ); // Log the note

    final result = await _addTransaction(event.transaction);

    result.fold(
      (l) {
        debugPrint("Transaction add Failed");
        emit(TransactionFeedError(message: l.message));
      },
      (r) {
        debugPrint("Transaction add successfully");
        emit(TransactionFeedAddSuccess());

        add(TransactionFeedShowAll());
      },
    );
  }
}
