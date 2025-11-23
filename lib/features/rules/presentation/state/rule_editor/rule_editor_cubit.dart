import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'rule_editor_state.dart';

class RuleEditorCubit extends Cubit<RuleEditorState> {
  RuleEditorCubit() : super(RuleEditorInitial());
}
