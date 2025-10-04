import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'rule_editor_state.dart';

class RuleEditorCubit extends Cubit<RuleEditorState> {
  RuleEditorCubit() : super(RuleEditorInitial());
}
