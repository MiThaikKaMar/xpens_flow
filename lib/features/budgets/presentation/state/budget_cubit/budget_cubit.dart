import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit() : super(BudgetInitial());
}
