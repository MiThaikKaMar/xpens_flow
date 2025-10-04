import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'import_state.dart';

class ImportCubit extends Cubit<ImportState> {
  ImportCubit() : super(ImportInitial());
}
