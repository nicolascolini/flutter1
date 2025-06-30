import 'package:financial_tracker/common/types/date_filter_type.dart';
import 'package:financial_tracker/domain/usecase/use_case_facade.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../common/errors/errors_classes.dart';
import '../../common/patterns/command.dart';
import '../../common/patterns/result.dart';
import '../../domain/entity/transaction_entity.dart';

class HomePageController {
  // HomePageController({required TransactionRepositoryContract repo})
  // : _repo = repo {
  HomePageController({
    required TransactionFacadeUseCases transactionsUseCases,
    // required GetAllTransactionsUseCaseImpl getAllTransactions,
    // required GetTransactionUseCaseImpl getTransaction,
  }) : _transactionsUseCases = transactionsUseCases {
    //  _getAllTransactions = getAllTransactions,
    //  _getTransaction = getTransaction,
    load = Command0(_loadTransactions);
    searchTransactionsByDate = Command2(_searchTransactionsByDate);
    saveTransaction = Command1(_saveTransaction);
    undoDelectedTransaction = Command1(_undoDelectedTransaction);
    deleteTransaction = Command1(_deleteTransaction);
    //loadSample = Command0<void, void>(_resetToSample);
    incomes = Computed(
      () =>
          _transactions.value
              .where((e) => e.type == TransactionType.income)
              .toList(),
    );

    expenses = Computed(
      () =>
          _transactions.value
              .where((e) => e.type == TransactionType.expense)
              .toList(),
    );

    totalIncome = Computed(
      () => _transactions.value
          .where((t) => t.type == TransactionType.income)
          .fold(0.0, (sum, t) => sum + t.amount),
    );

    totalExpense = Computed(
      () => _transactions.value
          .where((t) => t.type == TransactionType.expense)
          .fold(0.0, (sum, t) => sum + t.amount),
    );

    balance = Computed(() => totalIncome.value - totalExpense.value);
  }

  //final TransactionRepositoryContract _repo;
  final TransactionFacadeUseCases _transactionsUseCases;
  // final GetAllTransactionsUseCaseImpl _getAllTransactions;
  // final GetTransactionUseCaseImpl _getTransaction;

  // commands
  late final Command0<List<TransactionEntity>, Failure> load;
  late final Command1<void, Failure, TransactionEntity> saveTransaction;
  late final Command1<void, Failure, TransactionEntity> undoDelectedTransaction;
  late final Command1<void, Failure, String> deleteTransaction;
  late final Command2<List<TransactionEntity>, Failure, DateTime, DateTime>
  searchTransactionsByDate;
  //late final Command0<void, void> loadSample;

  // signals
  final Signal<List<TransactionEntity>> _transactions = Signal([]);
  final Signal<bool> _isFilterVisible = Signal(false);

  // no signal, apenas variáveis de controle da tela
  TransactionEntity? _lastDeleted;
  int? _lastDeletedIndex;

  DateFilterType _currentFilterType = DateFilterType.all;
  DateTime? _startDate;
  DateTime? _endDate;
  DateFilterType get filterType => _currentFilterType;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  // computed signals
  late final Computed<List<TransactionEntity>> incomes;
  late final Computed<List<TransactionEntity>> expenses;
  late final Computed<double> totalIncome;
  late final Computed<double> totalExpense;
  late final Computed<double> balance;

  ReadonlySignal<List<TransactionEntity>> get transctions => _transactions;
  ReadonlySignal<bool> get isFilterVisible => _isFilterVisible;

  // ReadonlySignal<List<TransactionEntity>> get readonlyExpenses => expenses;

  // Carrega lista de transações do repositório
  Future<Result<List<TransactionEntity>, Failure>> _searchTransactionsByDate(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final result = await _transactionsUseCases.getByDate.call((
      startDate: startDate,
      endDate: endDate,
    ));
    // final result = await _getAllTransactions.call();
    // final result = await _repo.getAllTransacions();

    result.fold(
      onSuccess: (transactions) {
        _transactions.value = transactions;
      },
      onFailure: (_) {
        _transactions.value = [];
        print('sem transações carregadas na consulta por data');
      },
    );

    return result;
  }

  // Carrega lista de transações do repositório
  Future<Result<List<TransactionEntity>, Failure>> _loadTransactions() async {
    final result = await _transactionsUseCases.getAll.call(());
    // final result = await _getAllTransactions.call();
    // final result = await _repo.getAllTransacions();

    result.fold(
      onSuccess: (transactions) {
        _transactions.value = transactions;
      },
      onFailure: (_) => print('sem transações carregadas'),
    );

    return result;
  }

  // Salva nova transação e atualiza signal
  Future<Result<void, Failure>> _saveTransaction(
    TransactionEntity transaction,
  ) async {
    final result = await _transactionsUseCases.addTransaction.call((
      transaction: transaction,
    ));

    if (result.isSuccess) {
      _transactions.value = [..._transactions.value, transaction];
    }

    return result;
  }

  // Restaura transação excluída e atualiza signal
  Future<Result<void, Failure>> _undoDelectedTransaction(
    TransactionEntity transaction,
  ) async {
    final last = _lastDeleted;
    final index = _lastDeletedIndex;

    if (last != null && index != null && transaction == last) {
      final result = await _transactionsUseCases.addTransaction.call((
        transaction: last,
      ));


      if (result.isSuccess) {
        final list = [..._transactions.value];
        list.insert(index, last);
        _transactions.value = list;

        _lastDeleted = null;
        _lastDeletedIndex = null;
      }

      return result;
    }

    return Error(DefaultError('Nenhuma transação excluída para restaurar.'));
  }

  // exclui transação e atualiza signal
  Future<Result<void, Failure>> _deleteTransaction(String id) async {
    final result = await _transactionsUseCases.deleteById.call((id: id));

    result.fold(
      onSuccess: (_) {
        _lastDeletedIndex = _transactions.value.indexWhere(
          (e) => e.id == id,
        ); // armazena o índice do último deletado
        _lastDeleted =
            _transactions
                .value[_lastDeletedIndex!]; // armazena o último deletado

        _transactions.value =
            _transactions.value
                .where((e) => e.id != id)
                .toList(); // nova lista = nova referência
      },
      onFailure: (failure) => print('Erro ao excluir transação: $failure'),
    );

    return result;
  }

  /// Alterna a visibilidade do filtro de transações.
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

  // Recarrega a lista com dados fictícios
  // Future<Result<void, void>> _resetToSample() async {
  //   transactions.value = TransactionEntity.sampleList();
  //   return const Success(null);
  // }
}
