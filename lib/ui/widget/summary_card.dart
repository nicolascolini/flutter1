import 'package:financial_tracker/common/utils/formatter.dart';
import 'package:flutter/material.dart';

/// Widget to display financial summary information
class SummaryCard extends StatelessWidget {
  /// Total income amount
  final double totalIncome;

  /// Total expense amount
  final double totalExpense;

  /// Current balance amount
  final double balance;

  const SummaryCard({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withValues(alpha: 0.7),
              colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header
            Text(
              'Resumo Financeiro',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
    
            // Three key financial indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Income
                _buildSummaryItem(
                  context,
                  'Receita',
                  Formatter.formatCurrency(totalIncome),
                  Icons.arrow_upward,
                  colorScheme.secondary,
                ),
                // Expense
                _buildSummaryItem(
                  context,
                  'Despesa',
                  Formatter.formatCurrency(totalExpense),
                  Icons.arrow_downward,
                  colorScheme.tertiary,
                ),
                // Balance
                _buildSummaryItem(
                  context,
                  'Balanço',
                  Formatter.formatCurrency(balance),
                  Icons.account_balance_wallet,
                  balance >= 0 ? Colors.green : Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build individual summary items
  Widget _buildSummaryItem(
    BuildContext context,
    String title,
    String amount,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      children: [
        // Icon with background
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.onSecondary.withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        // Title
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSecondary.withValues(alpha: 0.95),
          ),
        ),
        const SizedBox(height: 4),
        // Amount
        Text(
          amount,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSecondary,
          ),
        ),
      ],
    );
  }
}
