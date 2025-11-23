import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'transaction_editor_state.dart';

class TransactionEditorCubit extends Cubit<TransactionEditorState> {
  TransactionEditorCubit() : super(TransactionEditorInitial());
}
