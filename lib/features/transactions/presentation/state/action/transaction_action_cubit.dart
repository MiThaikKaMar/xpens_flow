import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpens_flow/features/transactions/domain/usecases/delete_transaction.dart';

part 'transaction_action_state.dart';

class TransactionActionCubit extends Cubit<TransactionActionState> {
  final DeleteTransaction _deleteTransaction;

  TransactionActionCubit({required deleteTransaction})
    : _deleteTransaction = deleteTransaction,
      super(TransactionActionInitial());

  Future<void> delete(int id) async {
    emit(TransactionActionLoading());

    final result = await _deleteTransaction(id);

    result.fold((failure) => emit(TransactionActionError(failure.message)), (
      count,
    ) {
      emit(TransactionDeleted());
      debugPrint(count.toString());
    });
  }
}
