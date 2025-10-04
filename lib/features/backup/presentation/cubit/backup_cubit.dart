import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'backup_state.dart';

class BackupCubit extends Cubit<BackupState> {
  BackupCubit() : super(BackupInitial());
}
