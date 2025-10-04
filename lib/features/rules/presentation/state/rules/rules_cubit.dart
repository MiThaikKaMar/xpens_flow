import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'rules_state.dart';

class RulesCubit extends Cubit<RulesState> {
  RulesCubit() : super(RulesInitial());
}
