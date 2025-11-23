import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'insights_state.dart';

class InsightsCubit extends Cubit<InsightsState> {
  InsightsCubit() : super(InsightsInitial());
}
