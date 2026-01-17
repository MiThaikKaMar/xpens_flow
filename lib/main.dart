import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xpens_flow/app/di/init_dependencies.dart';
import 'package:xpens_flow/core/common/utils/app_strings.dart';
import 'package:xpens_flow/features/onboarding/presentation/cubit/category_cubit.dart';
import 'package:xpens_flow/features/transactions/presentation/state/action/transaction_action_cubit.dart';
import 'package:xpens_flow/features/transactions/presentation/state/editor/transaction_editor_bloc.dart';
import 'package:xpens_flow/features/transactions/presentation/state/feed/transaction_feed_bloc.dart';
import 'package:xpens_flow/features/transactions/presentation/state/split/transaction_split_cubit.dart';

import 'core/ui/bloc/app_settings_bloc.dart';
import 'core/ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<CategoryCubit>()),
        BlocProvider(
          create: (_) =>
              serviceLocator<AppSettingsBloc>()..add(LoadAppSettingsEvent()),
        ),
        BlocProvider(create: (_) => serviceLocator<TransactionFeedBloc>()),
        BlocProvider(create: (_) => serviceLocator<TransactionEditorBloc>()),
        BlocProvider(create: (_) => serviceLocator<TransactionSplitCubit>()),
        BlocProvider(create: (_) => serviceLocator<TransactionActionCubit>()),
      ],

      child: const XpensFlow(),
    ),
  );
}

class XpensFlow extends StatelessWidget {
  const XpensFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.darkTheme,
      routerConfig: serviceLocator<GoRouter>(),
    );
  }
}
