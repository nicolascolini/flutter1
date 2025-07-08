import 'package:financial_tracker/common/errors/errors_classes.dart';
import 'package:financial_tracker/common/patterns/command.dart';
import 'package:financial_tracker/common/patterns/result.dart';
import 'package:financial_tracker/common/types/date_filter_type.dart';
import 'package:financial_tracker/domain/entity/transaction_entity.dart';
import 'package:financial_tracker/domain/usecase/use_case_facade.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomePageController {
  HomePageController({
    required TransactionFacadeUseCases transactionsUseCases,
  }) : _transactionsUseCases = transactionsUseCases {
    load = Command0(_loadTransactions);
    searchTransactionsByDate = Command2(_searchTransactionsByDate);
    saveTransaction = Command1(_saveTransaction);
    undoDelectedTransaction = Command1(_undoDelectedTransaction);
    deleteTransaction = Command1(_deleteTransaction);
    updateTransaction = Command1(_updateTransaction); // 👈 novo comando

    incomes = Computed(
      () => _transactions.value
          .where((e) => e.type == TransactionType.income)
          .toList(),
    );

    expenses = Computed(
      () => _transactions.value
          .where((e) => e.type == TransactionType.expense)
          .toList(),
    );

    totalIncome = Computed(() => incomes.value.fold(0.0, (sum, t) => sum + t.amount));
    totalExpense = Computed(() => expenses.value.fold(0.0, (sum, t) => sum + t.amount));
    balance = Computed(() => totalIncome.value - totalExpense.value);
  }

  final TransactionFacadeUseCases _transactionsUseCases;

  // commands
  late final Command0<List<TransactionEntity>, Failure> load;
  late final Command1<void, Failure, TransactionEntity> saveTransaction;
  late final Command1<void, Failure, TransactionEntity> undoDelectedTransaction;
  late final Command1<void, Failure, String> deleteTransaction;
  late final Command1<void, Failure, TransactionEntity> updateTransaction; // 👈 novo comando
  late final Command2<List<TransactionEntity>, Failure, DateTime, DateTime>
      searchTransactionsByDate;

  // signals
  final Signal<List<TransactionEntity>> _transactions = Signal([]);
  final Signal<bool> _isFilterVisible = Signal(false);

  TransactionEntity? _lastDeleted;
  int? _lastDeletedIndex;

  DateFilterType _currentFilterType = DateFilterType.all;
  DateTime? _startDate;
  DateTime? _endDate;
  DateFilterType get filterType => _currentFilterType;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // computed
  late final Computed<List<TransactionEntity>> incomes;
  late final Computed<List<TransactionEntity>> expenses;
  late final Computed<double> totalIncome;
  late final Computed<double> totalExpense;
  late final Computed<double> balance;

  ReadonlySignal<List<TransactionEntity>> get transctions => _transactions;
  ReadonlySignal<bool> get isFilterVisible => _isFilterVisible;

  Future<Result<List<TransactionEntity>, Failure>> _loadTransactions() async {
    final result = await _transactionsUseCases.getAll.call(());

    result.fold(
      onSuccess: (transactions) => _transactions.value = transactions,
      onFailure: (_) => print('Erro ao carregar transações'),
    );

    return result;
  }

  Future<Result<List<TransactionEntity>, Failure>> _searchTransactionsByDate(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final result = await _transactionsUseCases.getByDate.call((
      startDate: startDate,
      endDate: endDate,
    ));

    result.fold(
      onSuccess: (transactions) => _transactions.value = transactions,
      onFailure: (_) {
        _transactions.value = [];
        print('Erro na consulta por data');
      },
    );

    return result;
  }

  Future<Result<void, Failure>> _saveTransaction(TransactionEntity transaction) async {
    final result = await _transactionsUseCases.addTransaction.call((transaction: transaction));

    if (result.isSuccess) {
      _transactions.value = [..._transactions.value, transaction];
    }

    return result;
  }

  Future<Result<void, Failure>> _updateTransaction(TransactionEntity updated) async {
    final result = await _transactionsUseCases.updateTransaction.call((transaction: updated));

    if (result.isSuccess) {
      _transactions.value = _transactions.value.map((t) {
        return t.id == updated.id ? updated : t;
      }).toList();
    }

    return result;
  }

  Future<Result<void, Failure>> _undoDelectedTransaction(TransactionEntity transaction) async {
    final last = _lastDeleted;
    final index = _lastDeletedIndex;

    if (last != null && index != null && transaction == last) {
      final result = await _transactionsUseCases.addTransaction.call((transaction: last));

      if (result.isSuccess) {
        final list = [..._transactions.value];
        list.insert(index, last);
        _transactions.value = list;
        _lastDeleted = null;
        _lastDeletedIndex = null;
      }

      return result;
    }

    return Error(DefaultError('Nenhuma transação para restaurar.'));
  }

  Future<Result<void, Failure>> _deleteTransaction(String id) async {
    final result = await _transactionsUseCases.deleteById.call((id: id));

    result.fold(
      onSuccess: (_) {
        _lastDeletedIndex = _transactions.value.indexWhere((e) => e.id == id);
        _lastDeleted = _transactions.value[_lastDeletedIndex!];
        _transactions.value = _transactions.value.where((e) => e.id != id).toList();
      },
      onFailure: (failure) => print('Erro ao excluir: $failure'),
    );

    return result;
  }

  void toggleFilterVisibility() {
    _isFilterVisible.value = !_isFilterVisible.value;
  }

  void setFiltersParams(
    DateFilterType type,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    _currentFilterType = type;
    _startDate = startDate;
    _endDate = endDate;
  }
}
