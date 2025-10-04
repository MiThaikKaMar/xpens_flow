import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_lock_state.dart';

class AppLockCubit extends Cubit<AppLockState> {
  AppLockCubit() : super(AppLockInitial());
}
