part of 'transaction_action_cubit.dart';

sealed class TransactionActionState extends Equatable {
  const TransactionActionState();

  @override
  List<Object> get props => [];
}

final class TransactionActionInitial extends TransactionActionState {}

final class TransactionActionLoading extends TransactionActionState {}

final class TransactionDeleted extends TransactionActionState {}

final class TransactionActionError extends TransactionActionState {
  final String message;

  const TransactionActionError(this.message);
}
