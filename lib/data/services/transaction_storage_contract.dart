import '../../common/errors/errors_classes.dart';
import '../../common/patterns/result.dart';
import '../../domain/entity/transaction_entity.dart';

abstract class TransactionStorageContract {
  Future<Result<TransactionEntity, Failure>> fetchTransacion(String id);
  Future<Result<List<TransactionEntity>, Failure>> fetchAllTransacions();
  Future<Result<List<TransactionEntity>, Failure>> fetchTransacionsByTipe(
    TransactionType type,
  );
  Future<Result<List<TransactionEntity>, Failure>> fetchTransacionsByDate(
    DateTime startDate,
    DateTime endDate,
  );
  Future<Result<void, Failure>> removeTransacion(String id);
  Future<Result<void, Failure>> storeTransacion(TransactionEntity transaction);
}
