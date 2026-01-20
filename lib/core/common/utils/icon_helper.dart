import 'package:flutter/material.dart';

import '../../../features/transactions/domain/entities/transaction.dart';

IconData getIconDataFromString(String iconName) {
  switch (iconName) {
    case 'Housing':
      return Icons.house;
    case 'Utilities':
      return Icons.bolt;
    case 'Groceries':
      return Icons.shopping_cart;
    case 'Transport':
      return Icons.emoji_transportation;
    case 'Insurance' || 'Health':
      return Icons.health_and_safety;
    case 'Dining':
      return Icons.dining;
    case 'Entertainment':
      return Icons.games;
    case 'Shopping':
      return Icons.shopping_bag;
    case 'Travel':
      return Icons.flight;
    case 'Subscriptions':
      return Icons.subscriptions;
    case 'Savings':
      return Icons.savings;
    case 'Income':
      return Icons.attach_money;
    default:
      return Icons.category;
  }
}

IconData getIconDataFromAccountText(Accounts accountText) {
  switch (accountText) {
    case Accounts.mainChecking:
      return Icons.account_balance;
    case Accounts.cash:
      return Icons.payments;
    case Accounts.creditCard:
      return Icons.credit_card;
    case Accounts.wallet:
      return Icons.account_balance_wallet;
  }
}
