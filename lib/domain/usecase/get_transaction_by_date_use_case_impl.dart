import 'package:flutter/foundation.dart';

import '../../common/errors/errors_classes.dart';
import '../../common/patterns/result.dart';
import '../../data/repositories/transaction_repository_contract.dart';
import '../entity/transaction_entity.dart';
import 'use_case_contract.dart';

typedef GetTransactionByDateParams =
    ({@required DateTime startDate, @required DateTime endDate});

class GetTransactionBayDateUseCaseImpl
    implements
        IUseCaseContract<
          Result<List<TransactionEntity>, Failure>,
          GetTransactionByDateParams
        > {
  final TransactionRepositoryContract repo;

  GetTransactionBayDateUseCaseImpl(this.repo);

  @override
  Future<Result<List<TransactionEntity>, Failure>> call(
    GetTransactionByDateParams params,
  ) {
    return repo.getTransacionsByDate(params.startDate, params.endDate);
  }
}
