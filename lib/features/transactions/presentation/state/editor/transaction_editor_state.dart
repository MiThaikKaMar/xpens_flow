part of 'transaction_editor_bloc.dart';

sealed class TransactionEditorState extends Equatable {
  const TransactionEditorState();

  @override
  List<Object> get props => [];
}

final class TransactionEditorInitial extends TransactionEditorState {}

final class CategoriesLoading extends TransactionEditorState {}

final class CategoriesLoaded extends TransactionEditorState {
  final List<CategoryModel> categories;

  const CategoriesLoaded({required this.categories});
}

final class CategoriesError extends TransactionEditorState {
  final String message;

  const CategoriesError({required this.message});

  @override
  List<Object> get props => [message];
}

final class TransactionSubmitting extends TransactionEditorState {}

final class TransactionSubmitted extends TransactionEditorState {}

final class TransactionSubmissionError extends TransactionEditorState {
  final String message;

  const TransactionSubmissionError({required this.message});
}

final class CurrencyLoading extends TransactionEditorState {}

final class CurrencyLoaded extends TransactionEditorState {
  final String currency;

  const CurrencyLoaded({required this.currency});
}

final class CurrencyError extends TransactionEditorState {
  final String message;

  const CurrencyError({required this.message});

  @override
  List<Object> get props => [message];
}
