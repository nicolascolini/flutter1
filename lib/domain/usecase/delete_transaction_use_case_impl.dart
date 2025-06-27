import 'package:flutter/foundation.dart';

import '../../common/errors/errors_classes.dart';
import '../../common/patterns/result.dart';
import '../../data/repositories/transaction_repository_contract.dart';
import 'use_case_contract.dart';

typedef DeleteTransactionParams = ({@required String id});

class DeleteTransactionUseCaseImpl implements IUseCaseContract<
    Result<void, Failure>,
    DeleteTransactionParams> {

  final TransactionRepositoryContract repo;

  DeleteTransactionUseCaseImpl(this.repo);

  @override
  Future<Result<void, Failure>> call(DeleteTransactionParams params) {
    return repo.deleteTransacion(params.id);
  }
}