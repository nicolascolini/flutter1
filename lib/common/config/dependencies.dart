import 'package:auto_injector/auto_injector.dart';
import 'package:financial_tracker/domain/usecase/add_transaction_use_case_impl.dart';
import 'package:financial_tracker/domain/usecase/delete_transaction_use_case_impl.dart';
import 'package:financial_tracker/domain/usecase/get_transaction_by_date_use_case_impl.dart';
import 'package:financial_tracker/domain/usecase/use_case_facade.dart';

import '../../data/repositories/transaction_repository_contract.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../data/services/transaction_fake_service_impl.dart';
import '../../data/services/transaction_storage_contract.dart';
import '../../domain/usecase/get_all_%20transactions_use_case_impl.dart';
import '../../domain/usecase/get_transaction_use_case_impl.dart';
import '../../ui/controller/home_page_controller.dart';

final injector = AutoInjector();

void setupDependencies() {
  injector.addSingleton<TransactionRepositoryContract>(
    TransactionRepositoryImpl.new,
  );
  injector.addSingleton<TransactionStorageContract>(
    TransactionFakeServiceImpl.new,
  );
  injector.addSingleton(GetAllTransactionsUseCaseImpl.new);
  injector.addSingleton(GetTransactionUseCaseImpl.new);
  injector.addSingleton(GetTransactionBayDateUseCaseImpl.new);
  injector.addSingleton(DeleteTransactionUseCaseImpl.new);
  injector.addSingleton(AddTransactionUseCaseImpl.new);
  injector.addSingleton(TransactionFacadeUseCases.new);
  

  // injector.addSingleton<LocalStorageContract>(FakeDbService.new);
  injector.addSingleton<HomePageController>(HomePageController.new);
  injector.commit();
}
