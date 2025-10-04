import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'budget_detail_state.dart';

class BudgetDetailCubit extends Cubit<BudgetDetailState> {
  BudgetDetailCubit() : super(BudgetDetailInitial());
}
