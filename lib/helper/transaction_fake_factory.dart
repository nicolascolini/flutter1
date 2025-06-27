
import 'package:faker_dart/faker_dart.dart';
import '../domain/entity/transaction_entity.dart';

abstract class TransactionFakeFactory {
  static TransactionEntity factory() {
    final faker = Faker.instance;
    faker.setLocale(FakerLocaleType.pt_PT);

    var instance = TransactionEntity(
      title: faker.commerce.productName(),
      type:
          (faker.datatype.boolean())
              ? TransactionType.income
              : TransactionType.expense,
      date: faker.date.between(
        DateTime.now().subtract(Duration(days: 30)),
        DateTime.now(),
      ),
      amount: faker.datatype.float(
        min: 100.0,
        // min: 1.0 * math.pow(10.0, faker.datatype.number(min: 1, max: 3)),
        max: 2000.0,
        precision: 2,
      ),
    );
    return instance;
  }
}
