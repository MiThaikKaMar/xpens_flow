import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/di/init_dependencies.dart';
import 'package:xpens_flow/core/common/app_strings.dart';
import 'package:xpens_flow/features/onboarding/presentation/cubit/category_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => serviceLocator<CategoryCubit>())],
      child: const XpensFlow(),
    ),
  );
}

class XpensFlow extends StatelessWidget {
  const XpensFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: serviceLocator<GoRouter>(),
    );
  }
}
