import 'dart:convert';

import 'package:financial_tracker/domain/entity/transaction_entity.dart';

import 'common/config/dependencies.dart';
import 'common/theme/app_theme.dart';
import 'helper/transaction_fake_factory.dart';
import 'helper/transaction_fake_repository.dart';
import 'ui/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  setupDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  // var teste = TransactionFakeRepository();
  // var result = await teste.getData();
  // final List<dynamic> jsonList = jsonDecode(result);
  // print(jsonList.runtimeType); // Deve ser List
  // print(jsonList.first.runtimeType); // Deve ser Map<String, dynamic>
  // print(jsonList.first); // Veja o conteúdo real
  // final transactions =
  //     jsonList
  //         .map(
  //           (item) => TransactionEntity.fromMap(item as Map<String, dynamic>),
  //         )
  //         .toList();

  // print(transactions);

  runApp(
    MaterialApp(
      title: 'Financial Tracking App',
      debugShowCheckedModeBanner: false,
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    ),
  );
}
