import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit() : super(BudgetInitial());
}
