import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transaction_editor_state.dart';

class TransactionEditorCubit extends Cubit<TransactionEditorState> {
  TransactionEditorCubit() : super(TransactionEditorInitial());
}
