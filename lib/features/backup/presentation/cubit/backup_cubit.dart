import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'backup_state.dart';

class BackupCubit extends Cubit<BackupState> {
  BackupCubit() : super(BackupInitial());
}
