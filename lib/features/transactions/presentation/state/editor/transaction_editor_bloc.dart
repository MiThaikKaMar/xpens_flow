import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';
import 'package:xpens_flow/core/domain/usecases/get_current_currency.dart';
import 'package:xpens_flow/core/domain/usecases/get_selected_categories.dart';
import 'package:xpens_flow/core/domain/usecases/usecase.dart';
import 'package:xpens_flow/features/transactions/domain/usecases/add_transaction.dart';

import '../../../domain/entities/transaction.dart';

part 'transaction_editor_event.dart';
part 'transaction_editor_state.dart';

class TransactionEditorBloc
    extends Bloc<TransactionEditorEvent, TransactionEditorState> {
  final GetSelectedCategories _getAllCategories;
  final GetCurrentCurrency _getCurrentCurrency;
  final AddTransaction _addTransaction;

  TransactionEditorBloc({
    required getAllCategories,
    required addTransaction,
    required getCurrentCurrency,
  }) : _getAllCategories = getAllCategories,
       _addTransaction = addTransaction,
       _getCurrentCurrency = getCurrentCurrency,
       super(TransactionEditorInitial()) {
    on<LoadAllCategories>(_onLoadCategories);
    on<TransactionSubmit>(_onTransactionSubmit);
    on<LoadCurrency>(_onLoadCurrency);
  }

  _onLoadCurrency(
    LoadCurrency event,
    Emitter<TransactionEditorState> emit,
  ) async {
    emit(CurrencyLoading());

    final currencyResult = _getCurrentCurrency.call(NoParams());
    currencyResult.fold(
      (error) => emit(CurrencyError(message: error.message)),
      (currency) => emit(CurrencyLoaded(currency: currency)),
    );
  }

  _onTransactionSubmit(
    TransactionSubmit event,
    Emitter<TransactionEditorState> emit,
  ) async {
    emit(TransactionSubmitting());

    final result = await _addTransaction(event.transaction);

    result.fold(
      (l) {
        debugPrint("Transaction save failed");
        emit(TransactionSubmissionError(message: l.message));
      },
      (r) {
        debugPrint("Transaction save successfully");
        emit(TransactionSubmitted());
      },
    );
  }

  _onLoadCategories(
    LoadAllCategories event,
    Emitter<TransactionEditorState> emit,
  ) async {
    emit(CategoriesLoading());

    try {
      final categoriesResult = _getAllCategories(NoParams());

      categoriesResult.fold(
        (l) {
          emit(CategoriesError(message: l.message));
        },
        (categories) {
          emit(CategoriesLoaded(categories: categories));
        },
      );
    } catch (e) {
      emit(CategoriesError(message: e.toString()));
    }
  }
}
