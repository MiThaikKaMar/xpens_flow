import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';
import 'package:xpens_flow/core/domain/usecases/get_selected_categories.dart';
import 'package:xpens_flow/core/domain/usecases/usecase.dart';

import '../../../domain/entities/transaction.dart';

part 'transaction_editor_event.dart';
part 'transaction_editor_state.dart';

class TransactionEditorBloc
    extends Bloc<TransactionEditorEvent, TransactionEditorState> {
  final GetSelectedCategories _getAllCategories;

  TransactionEditorBloc({required getAllCategories})
    : _getAllCategories = getAllCategories,
      super(TransactionEditorInitial()) {
    on<LoadAllCategories>(_onLoadCategories);
    on<TransactionSubmit>(_onTransactionSubmit);
  }

  _onTransactionSubmit(
    TransactionSubmit event,
    Emitter<TransactionEditorState> emit,
  ) async {}

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
