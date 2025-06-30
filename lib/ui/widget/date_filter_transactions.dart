import 'package:financial_tracker/common/types/date_filter_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//enum DateFilterType { all, today, week, month, custom }

/// Widget for filtering transactions by date
class DateFilterTransactions extends StatefulWidget {
  /// Callback for when date filter changes
  final Function(DateTime? startDate, DateTime? endDate) onFilterChanged;

  /// Função de callback quando o formulário é enviado
  final Function() onAllTransactionsFiltered;

  // call para atualizar o filtro de data
  final Function(DateFilterType type, DateTime? startDate, DateTime? endDate)
  onUpdateFilter;

  /// Callback for when the filter is hidden
  final VoidCallback? onTapHideFilter;

final ({DateFilterType type, DateTime? startDate, DateTime? endDate}) filtro;

  const DateFilterTransactions({
    super.key,
    required this.onFilterChanged,
    required this.filtro,
    this.onTapHideFilter,
    required this.onAllTransactionsFiltered,
    required this.onUpdateFilter,
  });

  @override
  State<DateFilterTransactions> createState() => _DateFilterWidgetState();
}

class _DateFilterWidgetState extends State<DateFilterTransactions> {
  late DateFilterType _filterType;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _filterType = widget.filtro.type;
    _startDate = widget.filtro.startDate;
    _endDate = widget.filtro.endDate;

    // Initialize dates based on current filter
    _initializeDates();
  }

  void _initializeDates() {
    final now = DateTime.now();
    final range = _filterType.resolveRange(now, _startDate, _endDate);

    setState(() {
      _startDate = range?.start;
      _endDate = range?.end;
    });
  }

  void _applyFilter(DateFilterType type) {
    setState(() {
      _filterType = type;
      _initializeDates();
    });

    if (type == DateFilterType.all) {
      widget.onAllTransactionsFiltered();
    } else {
      widget.onFilterChanged(_startDate, _endDate);
    }
    widget.onUpdateFilter(_filterType, _startDate, _endDate);
  }

  Future<void> _selectCustomDateRange() async {
    // final now = DateTime.now();
    // final initialDateRange = DateTimeRange(
    //   start: _startDate ?? DateTime(now.year, now.month, 1),
    //   end: _endDate ?? now,
    // );
    // print(_startDate);
    // print(_endDate);
    // print(initialDateRange);
    final now = DateTime.now();
    final maxDate = now.add(const Duration(days: 1));

    final safeRange = _filterType
        .resolveRange(now, _startDate, _endDate)
        ?.cappedAt(
          maxDate,
        ); // com operador "?", cappedAt só é executado se o valor não for nulo retornado por resolveRange

    final pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: safeRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      setState(() {
        _filterType = DateFilterType.custom;
        _startDate = pickedDateRange.start;
        // Set end date to end of day
        _endDate = DateTime(
          pickedDateRange.end.year,
          pickedDateRange.end.month,
          pickedDateRange.end.day,
          23,
          59,
          59,
        );
      });

      widget.onFilterChanged(_startDate, _endDate);
      widget.onUpdateFilter(_filterType, _startDate, _endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.7),
              theme.colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter title
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: theme.colorScheme.onSecondary,
                  ),
                  onPressed: () {
                    // Aqui você aciona a função que alterna visibilidade
                    // Essa função vem da tela principal, então passe como parâmetro
                    widget.onTapHideFilter
                        ?.call(); // ou diretamente: _toggleFilterVisibility()
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  'Filtro de Data de Transações',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Wrap envolve os widgets filhos em uma linha com quebra automática
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip(DateFilterType.all, 'Tudo'),
                _buildFilterChip(DateFilterType.today, 'Hoje'),
                _buildFilterChip(DateFilterType.week, 'Esta Semana'),
                _buildFilterChip(DateFilterType.month, 'Este Mês'),
                _buildFilterChip(DateFilterType.custom, 'Personalizado'),
              ],
            ),

            // Show date range if custom filter selected
            if (_filterType == DateFilterType.custom) ...[
              const SizedBox(height: 12),
              InkWell(
                onTap: _selectCustomDateRange,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${DateFormat('dd/MM/yyyy').format(_startDate!)} - ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build a filter chip for date selection
  Widget _buildFilterChip(DateFilterType type, String label) {
    final theme = Theme.of(context);
    final isSelected = _filterType == type;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      child: ChoiceChip(
        checkmarkColor: theme.colorScheme.onSecondary,
        label: Text(label),
        selected: isSelected,
        selectedColor: theme.colorScheme.primary.withValues(alpha: 0.9),
        labelStyle: TextStyle(
          color:
              isSelected
                  ? theme.colorScheme.onSecondary
                  : theme.textTheme.bodyLarge?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        onSelected: (selected) {
          if (selected) {
            if (type == DateFilterType.custom) {
              _selectCustomDateRange();
            } else {
              _applyFilter(type);
            }
          }
        },
      ),
    );
  }
}
