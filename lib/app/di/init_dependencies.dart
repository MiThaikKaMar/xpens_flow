import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpens_flow/app/router/app_router.dart';
import 'package:xpens_flow/core/common/utils/init_variables.dart';
import 'package:xpens_flow/core/data/datasources/database_helper.dart';
import 'package:xpens_flow/core/data/datasources/hive_category_service.dart';
import 'package:xpens_flow/core/data/datasources/shared_preferences_helper.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';
import 'package:xpens_flow/core/data/repositories/app_settings_repository_impl.dart';
import 'package:xpens_flow/core/domain/repositories/app_settings_repository.dart';
import 'package:xpens_flow/core/domain/usecases/get_current_currency.dart';
import 'package:xpens_flow/core/domain/usecases/get_selected_categories.dart';
import 'package:xpens_flow/core/ui/bloc/app_settings_bloc.dart';
import 'package:xpens_flow/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:xpens_flow/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:xpens_flow/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:xpens_flow/features/onboarding/presentation/cubit/category_cubit.dart';
import 'package:xpens_flow/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:xpens_flow/features/transactions/data/datasources/transaction_local_data_source_impl.dart';
import 'package:xpens_flow/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:xpens_flow/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:xpens_flow/features/transactions/domain/usecases/add_transaction.dart';
import 'package:xpens_flow/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:xpens_flow/features/transactions/domain/usecases/list_transactions.dart';
import 'package:xpens_flow/features/transactions/presentation/state/action/transaction_action_cubit.dart';
import 'package:xpens_flow/features/transactions/presentation/state/editor/transaction_editor_bloc.dart';
import 'package:xpens_flow/features/transactions/presentation/state/feed/transaction_feed_bloc.dart';
import 'package:xpens_flow/features/transactions/presentation/state/split/transaction_split_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  serviceLocator.registerSingleton<SharedPreferencesHelper>(
    SharedPreferencesHelperImpl(serviceLocator<SharedPreferences>()),
  );

  // Init Hive

  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  final path = appDocumentDirectory.path;
  Hive
    ..init(path)
    ..registerAdapter(CategoryModelAdapter());
  // Open the categories box
  await Hive.openBox<CategoryModel>('categories');

  HiveCategoryService hiveCategoryService = HiveCategoryService();

  serviceLocator.registerSingleton<HiveCategoryService>(hiveCategoryService);

  //Routers

  final appRouter = AppRouter().router;
  serviceLocator.registerLazySingleton<GoRouter>(() => appRouter);

  serviceLocator.registerSingleton<DatabaseHelper>(DatabaseHelper());

  _initOnboarding();
  _coreAppSettings();
  _transaction();
}

void _transaction() {
  //data source
  serviceLocator.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(
      databaseHelper: serviceLocator<DatabaseHelper>(),
    ),
  );

  //repository
  serviceLocator.registerFactory<TransactionRepository>(
    () => TransactionRepositoryImpl(
      localDataSource: serviceLocator<TransactionLocalDataSource>(),
    ),
  );

  //usecase
  serviceLocator.registerFactory(
    () => AddTransaction(
      transactionRepository: serviceLocator<TransactionRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => ListTransactions(
      transactionRepository: serviceLocator<TransactionRepository>(),
    ),
  );

  serviceLocator.registerFactory(
    () => DeleteTransaction(
      transactionRepository: serviceLocator<TransactionRepository>(),
    ),
  );

  //bloc
  serviceLocator.registerLazySingleton<TransactionFeedBloc>(
    () => TransactionFeedBloc(
      addTransaction: serviceLocator<AddTransaction>(),
      listTransactions: serviceLocator<ListTransactions>(),
      getCurrentCurrency: serviceLocator<GetCurrentCurrency>(),
    ),
  );

  serviceLocator.registerLazySingleton<TransactionEditorBloc>(
    () => TransactionEditorBloc(
      getAllCategories: serviceLocator<GetSelectedCategories>(),
      addTransaction: serviceLocator<AddTransaction>(),
      getCurrentCurrency: serviceLocator<GetCurrentCurrency>(),
    ),
  );

  // Cubit
  serviceLocator.registerLazySingleton<TransactionSplitCubit>(
    () => TransactionSplitCubit(
      getAllCategories: serviceLocator<GetSelectedCategories>(),
    ),
  );
  // final cubit = serviceLocator<TransactionSplitCubit>(param1: 150.0);

  serviceLocator.registerLazySingleton<TransactionActionCubit>(
    () => TransactionActionCubit(
      deleteTransaction: serviceLocator<DeleteTransaction>(),
    ),
  );
}

void _coreAppSettings() {
  //repository
  serviceLocator.registerFactory<AppSettingsRepository>(
    () => AppSettingsRepositoryImpl(
      prefHelper: serviceLocator<SharedPreferencesHelper>(),
      hiveService: serviceLocator<HiveCategoryService>(),
    ),
  );

  //usecase
  serviceLocator.registerFactory<GetCurrentCurrency>(
    () => GetCurrentCurrency(
      appSettingsRepository: serviceLocator<AppSettingsRepository>(),
    ),
  );

  serviceLocator.registerFactory<GetSelectedCategories>(
    () => GetSelectedCategories(
      appSettingsRepository: serviceLocator<AppSettingsRepository>(),
    ),
  );

  //bloc
  serviceLocator.registerLazySingleton<AppSettingsBloc>(
    () => AppSettingsBloc(
      getCurrentCurrency: serviceLocator<GetCurrentCurrency>(),
      getSelectedCategories: serviceLocator<GetSelectedCategories>(),
    ),
  );
}

void _initOnboarding() {
  //repository
  serviceLocator.registerFactory<OnboardingRepository>(
    () => OnboardingRepositoryImpl(serviceLocator<HiveCategoryService>()),
  );

  //usecase
  serviceLocator.registerFactory<CompleteOnboarding>(
    () => CompleteOnboarding(
      onboardingRepository: serviceLocator<OnboardingRepository>(),
    ),
  );

  //bloc
  serviceLocator.registerLazySingleton<CategoryCubit>(
    () => CategoryCubit(
      completeOnboarding: serviceLocator<CompleteOnboarding>(),
      initCatList: InitVariables.initCatList,
    ),
  );
}
