import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../common/utils/formatter.dart';

/// Widget to display financial data in chart form
class SummaryChart extends StatelessWidget {
  /// Total income amount
  final double totalIncome;

  /// Total expense amount
  final double totalExpense;

  /// Map containing transactions separated by type
  //final Map<String, List<TransactionEntity>> transactions;

  const SummaryChart({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
    //required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chart title
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.pie_chart,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Receitas vs. Despesas',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        // Choose between pie chart and bar chart based on data availability
        if (totalIncome == 0 && totalExpense == 0)
          _buildEmptyState(context)
        else
          Container(
            height: 160,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Pie chart section
                Expanded(flex: 3, child: _buildPieChart(context)),
                const SizedBox(width: 10),
                // Legend section
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(
                        context,
                        'Receitas',
                        Theme.of(context).colorScheme.secondary,
                        totalIncome,
                      ),
                      const SizedBox(height: 16),
                      _buildLegendItem(
                        context,
                        'Despesas',
                        Theme.of(context).colorScheme.tertiary,
                        totalExpense,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Build pie chart visualization
  Widget _buildPieChart(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 30,
        sections: [
          // Income section
          PieChartSectionData(
            value: totalIncome,
            title: '',
            radius: 60,
            color: Theme.of(context).colorScheme.secondary,
            showTitle: false,
          ),
          // Expense section
          PieChartSectionData(
            value: totalExpense,
            title: '',
            radius: 60,
            color: Theme.of(context).colorScheme.tertiary,
            showTitle: false,
          ),
        ],
        // Optional styling
        borderData: FlBorderData(show: false),
        pieTouchData: PieTouchData(enabled: false),
      ),
    );
  }

  /// Build legend item for the chart
  Widget _buildLegendItem(
    BuildContext context,
    String title,
    Color color,
    double amount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            Container(width: 16, height: 16, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 25),
            Text(
              Formatter.formatCurrency(amount),
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  /// Build empty state when no data is available
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: 176,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insert_chart, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Sem transações cadastradas',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicione transações para visualizar o gráfico',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
