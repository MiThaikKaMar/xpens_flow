part of 'transaction_editor_bloc.dart';

sealed class TransactionEditorEvent extends Equatable {
  const TransactionEditorEvent();

  @override
  List<Object> get props => [];
}

final class LoadAllCategories extends TransactionEditorEvent {}

final class LoadCurrency extends TransactionEditorEvent {}

final class TransactionSubmit extends TransactionEditorEvent {
  final Transaction transaction;

  const TransactionSubmit({required this.transaction});
}
