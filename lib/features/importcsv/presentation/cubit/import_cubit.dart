import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'import_state.dart';

class ImportCubit extends Cubit<ImportState> {
  ImportCubit() : super(ImportInitial());
}
