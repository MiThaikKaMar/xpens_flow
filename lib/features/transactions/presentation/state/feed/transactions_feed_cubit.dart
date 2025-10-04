import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transactions_feed_state.dart';

class TransactionsFeedCubit extends Cubit<TransactionsFeedState> {
  TransactionsFeedCubit() : super(TransactionsFeedInitial());
}
