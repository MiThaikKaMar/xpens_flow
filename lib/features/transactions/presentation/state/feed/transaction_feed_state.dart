part of 'transaction_feed_bloc.dart';

sealed class TransactionFeedState extends Equatable {
  const TransactionFeedState();

  @override
  List<Object> get props => [];
}

final class TransactionFeedInitial extends TransactionFeedState {}

final class TransactionFeedLoading extends TransactionFeedState {}

final class TransactionFeedAddSuccess extends TransactionFeedState {}

final class TransactionFeedLoaded extends TransactionFeedState {
  final List<Transaction> transactionList;

  const TransactionFeedLoaded({required this.transactionList});
}

final class TransactionFeedError extends TransactionFeedState {
  final String message;

  const TransactionFeedError({required this.message});
}
