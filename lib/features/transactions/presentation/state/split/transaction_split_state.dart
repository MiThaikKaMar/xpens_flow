part of 'transaction_split_cubit.dart';

sealed class TransactionSplitState extends Equatable {
  // final double totalAmount;
  // final List<TransactionSplit> currentSplits;
  // final String? selectedCategory;
  // final double? currentAmount;
  // final String? currentNote;

  // const TransactionSplitState({
  //   required this.totalAmount,
  //   this.currentSplits = const [],
  //   this.selectedCategory,
  //   this.currentAmount,
  //   this.currentNote,
  // });

  // double get remainingToAllocate {
  //   final allocated = currentSplits.fold<double>(
  //     0,
  //     (sum, split) => sum + split.amount,
  //   );

  //   return totalAmount - allocated;
  // }

  // int get splitCount => currentSplits.length;

  // TransactionSplitState copyWith({
  //   double? totalAmount,
  //   List<TransactionSplit>? currentSplits,
  //   String? selectedCategory,
  //   double? currentAmount,
  //   String? currentNote,
  // }) {
  //   return TransactionSplitUpdated(
  //     totalAmount: totalAmount ?? this.totalAmount,
  //     currentSplits: currentSplits ?? this.currentSplits,
  //     selectedCategory: selectedCategory ?? this.selectedCategory,
  //     currentAmount: currentAmount ?? this.currentAmount,
  //     currentNote: currentNote ?? this.currentNote,
  //   );
  // }

  @override
  List<Object?> get props => [];
}

// All Categories
final class CategoriesLoading extends TransactionSplitState {}

final class CategoriesLoaded extends TransactionSplitState {
  final List<CategoryModel> categories;

  CategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

final class CategoriesError extends TransactionSplitState {
  final String message;

  CategoriesError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class TransactionSplitInitial extends TransactionSplitState {}

//Main Split management state
class SplitManagementState extends TransactionSplitState {
  final double totalAmount;
  final List<TransactionSplit> currentSplits;
  final String? selectedCategory;
  final double? currentAmount;
  final String? currentNote;
  final String? errorMessage;
  final int maxSplits;

  SplitManagementState({
    required this.totalAmount,
    this.currentSplits = const [],
    this.selectedCategory,
    this.currentAmount,
    this.currentNote,
    this.errorMessage,
    this.maxSplits = 10,
  });

  double get remainingToAllocate {
    final allocated = currentSplits.fold<double>(
      0,
      (sum, split) => sum + split.amount,
    );
    return totalAmount - allocated;
  }

  int get splitCount => currentSplits.length;

  SplitManagementState copyWith({
    double? totalAmount,
    List<TransactionSplit>? currentSplits,
    String? selectedCategory,
    double? currentAmount,
    String? currentNote,
    String? errorMessage,
    int? maxSplits,
  }) {
    return SplitManagementState(
      totalAmount: totalAmount ?? this.totalAmount,
      currentSplits: currentSplits ?? this.currentSplits,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentAmount: currentAmount ?? this.currentAmount,
      currentNote: currentNote ?? this.currentNote,
      errorMessage: errorMessage,
      maxSplits: maxSplits ?? this.maxSplits,
    );
  }

  @override
  List<Object?> get props => [
    totalAmount,
    currentSplits,
    selectedCategory,
    currentAmount,
    currentNote,
    errorMessage,
    maxSplits,
  ];
}
