part of 'transaction_split_cubit.dart';

sealed class TransactionSplitState extends Equatable {
  final double totalAmount;
  final List<TransactionSplit> currentSplits;
  final String? selectedCategory;
  final double? currentAmount;
  final String? currentNote;

  const TransactionSplitState({
    required this.totalAmount,
    this.currentSplits = const [],
    this.selectedCategory,
    this.currentAmount,
    this.currentNote,
  });

  double get remainingToAllocate {
    final allocated = currentSplits.fold<double>(
      0,
      (sum, split) => sum + split.amount,
    );

    return totalAmount - allocated;
  }

  int get splitCount => currentSplits.length;

  TransactionSplitState copyWith({
    double? totalAmount,
    List<TransactionSplit>? currentSplits,
    String? selectedCategory,
    double? currentAmount,
    String? currentNote,
  }) {
    return TransactionSplitUpdated(
      totalAmount: totalAmount ?? this.totalAmount,
      currentSplits: currentSplits ?? this.currentSplits,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentAmount: currentAmount ?? this.currentAmount,
      currentNote: currentNote ?? this.currentNote,
    );
  }

  @override
  List<Object?> get props => [
    totalAmount,
    currentSplits,
    selectedCategory,
    currentAmount,
    currentNote,
  ];
}

final class TransactionSplitInitial extends TransactionSplitState {
  const TransactionSplitInitial({required super.totalAmount});
}

class TransactionSplitLoading extends TransactionSplitState {
  const TransactionSplitLoading({required super.totalAmount});
}

class TransactionSplitUpdated extends TransactionSplitState {
  const TransactionSplitUpdated({
    required super.totalAmount,
    super.currentSplits,
    super.selectedCategory,
    super.currentAmount,
    super.currentNote,
  });
}

class TransactionSplitError extends TransactionSplitState {
  final String message;

  const TransactionSplitError({
    required this.message,
    required super.totalAmount,
    super.currentSplits,
    super.selectedCategory,
    super.currentAmount,
    super.currentNote,
  });

  @override
  List<Object?> get props => [...super.props, message];
}

class TransactionSplitComplete extends TransactionSplitState {
  const TransactionSplitComplete({
    required super.totalAmount,
    required super.currentSplits,
  });
}
