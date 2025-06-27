import '../../common/errors/errors_classes.dart';
import '../../common/patterns/result.dart';
import '../../data/repositories/transaction_repository_contract.dart';
import '../entity/transaction_entity.dart';
import 'use_case_contract.dart';

class GetAllTransactionsUseCaseImpl
    implements IUseCaseContract<Result<List<TransactionEntity>, Failure>, ()> {
  final TransactionRepositoryContract repo;

  GetAllTransactionsUseCaseImpl(this.repo);

  @override
  Future<Result<List<TransactionEntity>, Failure>> call([() params = const ()]) {
    return repo.getAllTransacions();
  }
}
