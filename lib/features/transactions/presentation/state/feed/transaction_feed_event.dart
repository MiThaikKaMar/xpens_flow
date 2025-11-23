part of 'transaction_feed_bloc.dart';

sealed class TransactionFeedEvent extends Equatable {
  const TransactionFeedEvent();

  @override
  List<Object> get props => [];
}

final class TransactionFeedAdd extends TransactionFeedEvent {
  final Transaction transaction;

  const TransactionFeedAdd({required this.transaction});
}

final class TransactionFeedShowAll extends TransactionFeedEvent {}
