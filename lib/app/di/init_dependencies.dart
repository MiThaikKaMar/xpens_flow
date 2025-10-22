import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xpens_flow/app/router/app_router.dart';
import 'package:xpens_flow/core/common/init_variables.dart';
import 'package:xpens_flow/core/data/db/database_helper.dart';
import 'package:xpens_flow/features/onboarding/data/hive/hive_category_service.dart';
import 'package:xpens_flow/core/helpers/shared_preferences_helper.dart';
import 'package:xpens_flow/features/onboarding/data/models/category_model.dart';
import 'package:xpens_flow/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:xpens_flow/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:xpens_flow/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:xpens_flow/features/onboarding/presentation/cubit/category_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final appRouter = AppRouter().router;
  serviceLocator.registerLazySingleton<GoRouter>(() => appRouter);

  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  serviceLocator.registerSingleton<SharedPreferencesHelper>(
    SharedPreferencesHelperImpl(serviceLocator<SharedPreferences>()),
  );

  serviceLocator.registerSingleton<DatabaseHelper>(DatabaseHelper());

  // Init Hive

  // Get the application documents directory
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  final path = appDocumentDirectory.path;
  Hive
    ..init(path)
    ..registerAdapter(CategoryModelAdapter());
  // Open the categories box
  await Hive.openBox<CategoryModel>('categories');

  _initOnboarding();
}

void _initOnboarding() {
  HiveCategoryService hiveCategoryService = HiveCategoryService();

  serviceLocator.registerSingleton<HiveCategoryService>(hiveCategoryService);

  serviceLocator.registerFactory<OnboardingRepository>(
    () => OnboardingRepositoryImpl(serviceLocator<HiveCategoryService>()),
  );

  serviceLocator.registerFactory<CompleteOnboarding>(
    () => CompleteOnboarding(
      onboardingRepository: serviceLocator<OnboardingRepository>(),
    ),
  );

  serviceLocator.registerLazySingleton<CategoryCubit>(
    () => CategoryCubit(
      completeOnboarding: serviceLocator<CompleteOnboarding>(),
      initCatList: InitVariables.initCatList,
    ),
  );
}
