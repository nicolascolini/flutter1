import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../common/errors/errors_classes.dart';
import '../../common/patterns/result.dart';
import '../../data/repositories/transaction_repository_contract.dart';
import '../entity/transaction_entity.dart';
import 'use_case_contract.dart';

typedef AddTransactionParams = ({@required TransactionEntity transaction});

class AddTransactionUseCaseImpl
    implements
        IUseCaseContract<
          Result<void, Failure>,
          AddTransactionParams
        > {
  final TransactionRepositoryContract repo;

  AddTransactionUseCaseImpl(this.repo);

  @override
  Future<Result<void, Failure>> call(AddTransactionParams params) {
    return repo.saveTransacion(params.transaction);
  }
}
