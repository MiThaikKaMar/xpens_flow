import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction_split.dart';

part 'transaction_split_state.dart';

class TransactionSplitCubit extends Cubit<TransactionSplitState> {
  TransactionSplitCubit() : super(TransactionSplitInitial(totalAmount: 0));

  // Update selected category
  void updateCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  // Update current amount being entered
  void updateAmount(double amount) {
    emit(state.copyWith(currentAmount: amount));
  }

  //Update note
  void updateNote(String note) {
    emit(state.copyWith(currentNote: note));
  }

  // Quick split in half
  void splitInHalf() {
    final amount = state.remainingToAllocate / 2;
    _addEqualSplits(2, amount);
  }

  //Quick split in thirds
  void splitInThirds() {
    final amount = state.remainingToAllocate / 3;
    _addEqualSplits(3, amount);
  }

  // Helper method for equal splits
  void _addEqualSplits(int count, double amount) {
    final newSplits = List<TransactionSplit>.from(state.currentSplits);

    for (int i = 0; i < count; i++) {
      newSplits.add(
        TransactionSplit(
          category: state.selectedCategory ?? 'Uncategoried',
          amount: amount,
        ),
      );
    }

    emit(
      state.copyWith(
        currentSplits: newSplits,
        selectedCategory: null,
        currentAmount: null,
        currentNote: null,
      ),
    );
  }

  // Add a split
  void addSplit() {
    //Basic validation
    if (state.selectedCategory == null ||
        state.currentAmount == null ||
        state.currentAmount! <= 0 ||
        state.currentAmount! > state.remainingToAllocate) {
      emit(
        TransactionSplitError(
          message: 'Invalid input. Please check category and amount.',
          totalAmount: state.totalAmount,
          currentSplits: state.currentSplits,
          selectedCategory: state.selectedCategory,
          currentAmount: state.currentAmount,
          currentNote: state.currentNote,
        ),
      );
      return;
    }

    final newSplit = TransactionSplit(
      category: state.selectedCategory!,
      amount: state.currentAmount!,
      note: state.currentNote ?? '',
    );

    final updatedSplits = List<TransactionSplit>.from(state.currentSplits)
      ..add(newSplit);

    emit(
      state.copyWith(
        currentSplits: updatedSplits,
        selectedCategory: null,
        currentAmount: null,
        currentNote: null,
      ),
    );
  }

  // Clear error state
  void clearError() {
    emit(
      TransactionSplitUpdated(
        totalAmount: state.totalAmount,
        currentSplits: state.currentSplits,
        selectedCategory: state.selectedCategory,
        currentAmount: state.currentAmount,
        currentNote: state.currentNote,
      ),
    );
  }

  // Complete the split
  void completeSplit() {
    if (state.remainingToAllocate > 0) {
      emit(
        TransactionSplitError(
          message: 'Please allocate the full amount before completing',
          totalAmount: state.totalAmount,
          currentSplits: state.currentSplits,
          selectedCategory: state.selectedCategory,
          currentAmount: state.currentAmount,
          currentNote: state.currentNote,
        ),
      );
      return;
    }

    if (state.currentSplits.isEmpty) {
      emit(
        TransactionSplitError(
          message: 'Please add at least one split',
          totalAmount: state.totalAmount,
          currentSplits: state.currentSplits,
          selectedCategory: state.selectedCategory,
          currentAmount: state.currentAmount,
          currentNote: state.currentNote,
        ),
      );
      return;
    }

    emit(
      TransactionSplitComplete(
        totalAmount: state.totalAmount,
        currentSplits: state.currentSplits,
      ),
    );
  }
}
