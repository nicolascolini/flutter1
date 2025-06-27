import 'package:flutter/foundation.dart';

import '../../common/errors/errors_classes.dart';
import '../../common/patterns/result.dart';
import '../../data/repositories/transaction_repository_contract.dart';
import '../entity/transaction_entity.dart';
import 'use_case_contract.dart';

typedef GetTransactionParams = ({@required String id});

class GetTransactionUseCaseImpl implements IUseCaseContract<
    Result<TransactionEntity, Failure>,
    GetTransactionParams> {

  final TransactionRepositoryContract repo;

  GetTransactionUseCaseImpl(this.repo);

  @override
  Future<Result<TransactionEntity, Failure>> call(GetTransactionParams params) {
    return repo.getTransacion(params.id);
  }
}