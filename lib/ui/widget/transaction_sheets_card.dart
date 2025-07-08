import 'package:financial_tracker/common/errors/errors_classes.dart';
import 'package:financial_tracker/common/patterns/command.dart';

import '../../common/utils/formatter.dart';
import '../../domain/entity/transaction_entity.dart';
import 'package:flutter/material.dart';

class TransactionCardSheets extends StatefulWidget {
  final List<TransactionEntity> incomeTransactions;
  final List<TransactionEntity> expenseTransactions;
  final Function(String id) onDelete;
  final Command1<void, Failure, TransactionEntity> undoDelete;
  final Future<void> Function(TransactionEntity transaction) onUpdate; // NOVO callback update
  final BuildContext scaffoldContext;

  const TransactionCardSheets({
    super.key,
    required this.incomeTransactions,
    required this.expenseTransactions,
    required this.onDelete,
    required this.undoDelete,
    required this.onUpdate,
    required this.scaffoldContext,
  });

  @override
  State<TransactionCardSheets> createState() => _TransactionCardSheetsState();
}

class _TransactionCardSheetsState extends State<TransactionCardSheets>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Para controlar os controllers dos TextFields dinamicamente, 
  // usamos Map<String, TextEditingController> para título e valor
  final Map<String, TextEditingController> _titleControllers = {};
  final Map<String, TextEditingController> _amountControllers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    // inicializa os controllers para as transações atuais
    _initControllers(widget.incomeTransactions);
    _initControllers(widget.expenseTransactions);
  }

  void _initControllers(List<TransactionEntity> transactions) {
    for (var t in transactions) {
      _titleControllers[t.id] ??= TextEditingController(text: t.title);
      _amountControllers[t.id] ??= TextEditingController(text: t.amount.toString());
    }
  }

  @override
  void didUpdateWidget(covariant TransactionCardSheets oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Atualiza controllers se a lista mudar
    _initControllers(widget.incomeTransactions);
    _initControllers(widget.expenseTransactions);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleControllers.forEach((_, c) => c.dispose());
    _amountControllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  Future<void> _updateTransactionField(TransactionEntity oldTransaction, {
    String? newTitle,
    double? newAmount,
    DateTime? newDate,
  }) async {
    // Cria uma cópia com os novos valores (se existirem)
    final updated = oldTransaction.copyWith(
      title: newTitle ?? oldTransaction.title,
      amount: newAmount ?? oldTransaction.amount,
      date: newDate ?? oldTransaction.date,
    );

    await widget.onUpdate(updated);
  }

  Future<void> _pickDate(TransactionEntity transaction) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: transaction.date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != transaction.date) {
      await _updateTransactionField(transaction, newDate: picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withOpacity(0.15),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                _buildTab(
                  TransactionType.income.namePlural,
                  Icons.arrow_upward,
                  0,
                  colorScheme.primary,
                  colorScheme.primary.withOpacity(0.5),
                ),
                _buildTab(
                  TransactionType.expense.namePlural,
                  Icons.arrow_downward,
                  1,
                  colorScheme.secondary,
                  colorScheme.secondary.withOpacity(0.5),
                ),
              ],
              indicatorColor:
                  _tabController.index == 0 ? colorScheme.primary : colorScheme.secondary,
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: SizedBox(
              height: 290,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTransactionList(
                    context,
                    widget.incomeTransactions,
                    colorScheme.primary,
                    TransactionType.income.namePlural,
                  ),
                  _buildTransactionList(
                    context,
                    widget.expenseTransactions,
                    colorScheme.secondary,
                    TransactionType.expense.namePlural,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    String title,
    IconData icon,
    int index,
    Color activeColor,
    Color inactiveColor,
  ) {
    final isSelected = _tabController.index == index;
    final color = isSelected ? activeColor : inactiveColor;

    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    List<TransactionEntity> transactions,
    Color color,
    String title,
  ) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              title == TransactionType.income.namePlural
                  ? Icons.savings
                  : Icons.shopping_cart,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              'Sem ${title.toLowerCase()} registradas',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          final undoTransaction = transaction.copyWith();

          final titleController = _titleControllers[transaction.id]!;
          final amountController = _amountControllers[transaction.id]!;

          return Dismissible(
            key: Key(transaction.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) async {
              await widget.onDelete(transaction.id);
              ScaffoldMessenger.of(widget.scaffoldContext).clearSnackBars();
              ScaffoldMessenger.of(widget.scaffoldContext).showSnackBar(
                SnackBar(
                  content: Text('${transaction.title} excluída!!!'),
                  backgroundColor: Colors.pinkAccent,
                  action: SnackBarAction(
                    label: 'DESFAZER',
                    textColor: Colors.white,
                    onPressed: () async {
                      await widget.undoDelete.execute(undoTransaction);
                      if (widget.undoDelete.resultSignal.value?.isSuccess ?? false) {
                        ScaffoldMessenger.of(widget.scaffoldContext).showSnackBar(
                          SnackBar(
                            content: Text('${transaction.title} restaurada!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(widget.scaffoldContext).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.undoDelete.resultSignal.value?.failureValueOrNull ?? 'Erro desconhecido'}',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  radius: 22,
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(
                    title == TransactionType.income.namePlural
                        ? Icons.attach_money
                        : Icons.shopping_bag,
                    color: color,
                  ),
                ),
                title: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                  onSubmitted: (value) async {
                    if (value.trim().isNotEmpty && value != transaction.title) {
                      await _updateTransactionField(transaction, newTitle: value.trim());
                    }
                  },
                  onEditingComplete: () async {
                    final value = titleController.text.trim();
                    if (value.isNotEmpty && value != transaction.title) {
                      await _updateTransactionField(transaction, newTitle: value);
                    }
                    FocusScope.of(context).unfocus();
                  },
                ),
                subtitle: GestureDetector(
                  onTap: () => _pickDate(transaction),
                  child: Text(
                    Formatter.formatDate(transaction.date),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                  ),
                ),
                trailing: SizedBox(
                  width: 110,
                  child: TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                    onSubmitted: (value) async {
                      final parsed = double.tryParse(value);
                      if (parsed != null && parsed != transaction.amount) {
                        await _updateTransactionField(transaction, newAmount: parsed);
                      } else {
                        // Se parse falhar, restaura valor original no controller
                        amountController.text = transaction.amount.toString();
                      }
                    },
                    onEditingComplete: () async {
                      final value = amountController.text.trim();
                      final parsed = double.tryParse(value);
                      if (parsed != null && parsed != transaction.amount) {
                        await _updateTransactionField(transaction, newAmount: parsed);
                      } else {
                        amountController.text = transaction.amount.toString();
                      }
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
