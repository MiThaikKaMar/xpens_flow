import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'budget_detail_state.dart';

class BudgetDetailCubit extends Cubit<BudgetDetailState> {
  BudgetDetailCubit() : super(BudgetDetailInitial());
}
