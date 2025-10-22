// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/fpdart.dart';

import 'package:xpens_flow/core/domain/usecases/usecase.dart';
import 'package:xpens_flow/core/error/failure.dart';
import 'package:xpens_flow/features/onboarding/data/models/category_model.dart';
import 'package:xpens_flow/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteOnboarding extends AsyncUsecase<String, SelectedCatParams> {
  final OnboardingRepository _onboardingRepository;

  CompleteOnboarding({required OnboardingRepository onboardingRepository})
    : _onboardingRepository = onboardingRepository;

  @override
  Future<Either<String, Failure>> call(SelectedCatParams params) async {
    return _onboardingRepository.saveSelectedCategories(params.selectedCatList);
  }
}

class SelectedCatParams {
  final List<CategoryModel> selectedCatList;
  SelectedCatParams(this.selectedCatList);
}
