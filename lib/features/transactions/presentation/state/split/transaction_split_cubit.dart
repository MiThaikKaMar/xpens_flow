import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xpens_flow/core/data/models/category_model.dart';
import 'package:xpens_flow/core/domain/usecases/get_selected_categories.dart';
import 'package:xpens_flow/core/domain/usecases/usecase.dart';
import 'package:xpens_flow/features/transactions/domain/entities/transaction_split.dart';

part 'transaction_split_state.dart';

class TransactionSplitCubit extends Cubit<TransactionSplitState> {
  final GetSelectedCategories _getAllCategories;

  TransactionSplitCubit({required getAllCategories})
    : _getAllCategories = getAllCategories,
      super(TransactionSplitInitial());

  // Initialize split management
  void initializeSplitManagement(double totalAmount, {int maxSplits = 10}) {
    emit(SplitManagementState(totalAmount: totalAmount, maxSplits: maxSplits));
  }

  void loadAllCategories() {
    emit(CategoriesLoading());

    try {
      final categoriesResult = _getAllCategories(NoParams());
      categoriesResult.fold(
        (failure) {
          emit(CategoriesError(message: failure.message));
        },
        (categories) {
          emit(CategoriesLoaded(categories: categories));
        },
      );
    } catch (e) {
      emit(CategoriesError(message: e.toString()));
    }
  }

  // Update selected category
  void updateCategory(String category) {
    if (state is SplitManagementState) {
      final currentState = state as SplitManagementState;
      emit(
        currentState.copyWith(selectedCategory: category, errorMessage: null),
      );
    }
    //emit(state.copyWith(selectedCategory: category));
  }

  // Update current amount being entered
  void updateAmount(double? amount) {
    if (state is SplitManagementState) {
      final currentState = state as SplitManagementState;
      emit(currentState.copyWith(currentAmount: amount, errorMessage: null));
    }
    //emit(state.copyWith(currentAmount: amount));
  }

  //Update note
  void updateNote(String note) {
    if (state is SplitManagementState) {
      final currentState = state as SplitManagementState;
      emit(currentState.copyWith(currentNote: note, errorMessage: null));
    }
    //emit(state.copyWith(currentNote: note));
  }

  // Add a split
  void addSplit(int transactionId) {
    if (state is! SplitManagementState) return;

    final currentState = state as SplitManagementState;

    // Basic validation
    if (currentState.selectedCategory == null ||
        currentState.selectedCategory == "Select category") {
      emit(currentState.copyWith(errorMessage: 'Please select a category'));
      return;
    }

    if (currentState.currentAmount == null ||
        currentState.currentAmount! <= 0) {
      emit(currentState.copyWith(errorMessage: 'Please enter a valid amount'));
      return;
    }

    if (currentState.currentAmount! > currentState.remainingToAllocate) {
      emit(
        currentState.copyWith(
          errorMessage: 'Amount exceeds remaining to allocate',
        ),
      );
      return;
    }

    if (currentState.currentSplits.length >= currentState.maxSplits) {
      emit(
        currentState.copyWith(
          errorMessage: 'Maximun ${currentState.maxSplits} splits allowed',
        ),
      );
      return;
    }

    final newSplit = TransactionSplit(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      transactionId: transactionId,
      category: currentState.selectedCategory!,
      amount: currentState.currentAmount!,
      note: currentState.currentNote,
    );

    final updatedSplits = List<TransactionSplit>.from(
      currentState.currentSplits,
    )..add(newSplit);

    emit(
      currentState.copyWith(
        currentSplits: updatedSplits,
        selectedCategory: null, // Reset form
        currentAmount: null,
        currentNote: null,
        errorMessage: null,
      ),
    );
  }

  // Quick split in half
  void splitInHalf(int transactionId) {
    if (state is! SplitManagementState) return;

    final currentState = state as SplitManagementState;
    if (currentState.remainingToAllocate <= 0) return;
    final amount = currentState.remainingToAllocate / 2;
    _addEqualSplits(2, amount, transactionId);
  }

  //Quick split in thirds
  void splitInThirds(int transactionId) {
    if (state is! SplitManagementState) return;

    final currentState = state as SplitManagementState;
    if (currentState.remainingToAllocate <= 0) return;
    final amount = currentState.remainingToAllocate / 3;
    _addEqualSplits(3, amount, transactionId);
  }

  // Helper method for equal splits
  void _addEqualSplits(int count, double amount, int transactionId) {
    if (state is! SplitManagementState) return;

    final currentState = state as SplitManagementState;

    final newSplits = List<TransactionSplit>.from(currentState.currentSplits);

    if (newSplits.length + count > currentState.maxSplits) {
      emit(currentState.copyWith(errorMessage: "Too many splits"));
      return;
    }

    for (int i = 0; i < count; i++) {
      newSplits.add(
        TransactionSplit(
          id: '${DateTime.now().millisecondsSinceEpoch}_$i',
          transactionId: transactionId,
          category: 'Uncategoried',
          amount: amount,
          note: 'Auto-split ${i + 1}/$count',
        ),
      );
    }

    emit(
      currentState.copyWith(currentSplits: newSplits, selectedCategory: null),
    );
  }

  // Remove a split
  void removeSplit(String splitId) {
    if (state is! SplitManagementState) return;

    final currentState = state as SplitManagementState;
    final updateSplits = currentState.currentSplits
        .where((split) => split.id != splitId)
        .toList();

    emit(currentState.copyWith(currentSplits: updateSplits));
  }

  // Clear error state
  void clearError() {
    if (state is SplitManagementState) {
      final currentState = state as SplitManagementState;
      emit(currentState.copyWith(errorMessage: null));
    }
  }

  // Save splits (this is where you'd persist to storage)
  void saveSplits() {
    if (state is! SplitManagementState) return;

    final currentState = state as SplitManagementState;

    if (currentState.currentSplits.isEmpty) {
      emit(
        currentState.copyWith(errorMessage: 'Please add at least one split'),
      );
      return;
    }

    if (currentState.remainingToAllocate > 0) {
      emit(
        currentState.copyWith(
          errorMessage: 'Please allocate the full amount before saving',
        ),
      );
      return;
    }

    // Here you would save to storage
    // For now, just emit success or navigate back

    for (var e in currentState.currentSplits) {
      debugPrint(
        "Saved split: ${e.amount}, ${e.category} , ${e.note} , ${e.transactionId} , ${e.id}",
      );
    }

    //Navigate back or show success message
    //Navigator.of(context).pop(currentState.currentSplits);
  }
}
