import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'month_end_state.dart';

class MonthEndCubit extends Cubit<MonthEndState> {
  MonthEndCubit() : super(MonthEndInitial());
}
