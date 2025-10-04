import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transaction_detail_state.dart';

class TransactionDetailCubit extends Cubit<TransactionDetailState> {
  TransactionDetailCubit() : super(TransactionDetailInitial());
}
