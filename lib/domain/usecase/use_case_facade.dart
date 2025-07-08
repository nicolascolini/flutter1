import 'package:financial_tracker/domain/usecase/add_transaction_use_case_impl.dart';
import 'package:financial_tracker/domain/usecase/delete_transaction_use_case_impl.dart';
import 'package:financial_tracker/domain/usecase/get_all_%20transactions_use_case_impl.dart';
import 'package:financial_tracker/domain/usecase/get_transaction_by_date_use_case_impl.dart';
import 'package:financial_tracker/domain/usecase/get_transaction_use_case_impl.dart';
import 'package:financial_tracker/domain/usecase/update_transaction_use_case_impl.dart';


class TransactionFacadeUseCases {
  final GetAllTransactionsUseCaseImpl getAll;
  final GetTransactionUseCaseImpl getById;
  final GetTransactionBayDateUseCaseImpl getByDate;
  final DeleteTransactionUseCaseImpl deleteById;
  final AddTransactionUseCaseImpl addTransaction;
  final UpdateTransactionUseCaseImpl updateTransaction; 

  TransactionFacadeUseCases({
    required this.getAll,
    required this.getById,
    required this.getByDate,
    required this.deleteById,
    required this.addTransaction,
    required this.updateTransaction,
  });
}
