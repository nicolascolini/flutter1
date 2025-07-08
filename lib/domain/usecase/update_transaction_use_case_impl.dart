import 'package:flutter/foundation.dart';

import '../../common/errors/errors_classes.dart';
import '../../common/patterns/result.dart';
import '../../data/repositories/transaction_repository_contract.dart';
import '../entity/transaction_entity.dart';
import 'use_case_contract.dart';

typedef UpdateTransactionParams = ({@required TransactionEntity transaction});

class UpdateTransactionUseCaseImpl implements IUseCaseContract<
    Result<void, Failure>,
    UpdateTransactionParams> {
  final TransactionRepositoryContract repo;

  UpdateTransactionUseCaseImpl(this.repo);

  @override
  Future<Result<void, Failure>> call(UpdateTransactionParams params) {
    return repo.updateTransacion(params.transaction);
  }
}

