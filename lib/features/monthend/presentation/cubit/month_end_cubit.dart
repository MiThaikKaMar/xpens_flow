import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'month_end_state.dart';

class MonthEndCubit extends Cubit<MonthEndState> {
  MonthEndCubit() : super(MonthEndInitial());
}
