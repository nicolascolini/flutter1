import 'package:financial_tracker/domain/entity/transaction_entity.dart';

import '../../common/errors/errors_classes.dart';
import '../../common/patterns/result.dart';

/// Contrato que define operações relacionadas ao estudante.
abstract class TransactionRepositoryContract {
  Future<Result<TransactionEntity, Failure>> getTransacion(String id);
  Future<Result<List<TransactionEntity>, Failure>> getAllTransacions();
  Future<Result<List<TransactionEntity>, Failure>> getTransacionsByTipe(
    TransactionType type,
  );
  Future<Result<List<TransactionEntity>, Failure>> getTransacionsByDate(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Result<void, Failure>> deleteTransacion(String id);
  Future<Result<void, Failure>> saveTransacion(TransactionEntity transaction);
}
