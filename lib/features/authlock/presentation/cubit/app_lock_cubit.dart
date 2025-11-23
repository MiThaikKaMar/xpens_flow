import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_lock_state.dart';

class AppLockCubit extends Cubit<AppLockState> {
  AppLockCubit() : super(AppLockInitial());
}
