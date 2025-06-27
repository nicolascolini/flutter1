import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import 'result.dart';

/// Define o tipo de função assíncrona sem argumentos,
/// que retorna um resultado genérico (sucesso ou erro).
typedef CommandAction0<Success, Error> = Future<Result<Success, Error>> Function();

/// Define o tipo de função assíncrona com um argumento do tipo A.
typedef CommandAction1<Success, Error, A> = Future<Result<Success, Error>> Function(A);

/// Define o tipo de função assíncrona com 2 argumentos do tipo A1 e A2.
typedef CommandAction2<Success, Error, A1, A2> = Future<Result<Success, Error>> Function(A1,A2);

/// Classe base que executa ações assíncronas e permite reagir às mudanças.
/// Usa sinais para notificar a interface automaticamente.
abstract class Command<Success, Error> {
  Command() {
    // Inicia o sinal de "executando" como falso
    _running = signal<bool>(false);

    // Inicia o sinal com o resultado como nulo (nada executado ainda)
    _result = signal<Result<Success, Error>?>(null);
  }

  // Sinal que indica se a ação está em execução
  late final Signal<bool> _running;
  bool get running => _running.value; // Acesso direto ao valor (true/false)

  // Sinal que armazena o último resultado da ação
  late final Signal<Result<Success, Error>?> _result;
  Result<Success, Error>? get result => _result.value;

  // Retorna true se o último resultado foi erro
  bool get error => result?.isFailure ?? false;

  // Retorna true se o último resultado foi sucesso
  bool get completed => result?.isSuccess ?? false;

  // Retorna o sinal somente leitura de "executando"
  // (para observar mudanças na interface)
  ReadonlySignal<bool> get runningSignal => _running.readonly();

  // Retorna o sinal somente leitura do resultado
  ReadonlySignal<Result<Success, Error>?> get resultSignal => _result.readonly();

  /// Limpa o resultado anterior
  void clearResult() {
    _result.value = null;
  }

  /// Executa uma função assíncrona (ação)
  /// Atualiza o estado antes, durante e depois da execução
  Future<void> _execute(Future<Result<Success, Error>> Function() action) async {
    if (_running.value) return; // evita execução duplicada

    _running.value = true; // indica que está rodando
    _result.value = null;  // limpa resultado anterior

    _result.value = await action(); // executa a ação

    _running.value = false; // indica que terminou
  }
}

/// Comando para ações sem argumentos
class Command0<Success, Error> extends Command<Success, Error> {
  Command0(this._action);
  final CommandAction0<Success, Error> _action;

  /// Executa a ação sem argumentos
  Future<void> execute() async {
    await _execute(_action);
  }
}

/// Comando para ações com um argumento do tipo A
class Command1<Success, Error, A> extends Command<Success, Error> {
  Command1(this._action);
  final CommandAction1<Success, Error, A> _action;

  /// Executa a ação passando um argumento
  Future<void> execute(A argument) async {
    await _execute(() => _action(argument));
  }
}

/// Comando para ações com 2 argumentos do tipo A1 e A2
class Command2<Success, Error, A1, A2> extends Command<Success, Error> {
  Command2(this._action);
  final CommandAction2<Success, Error, A1, A2> _action;

  /// Executa a ação passando 2 argumentos
  Future<void> execute(A1 argument1, A2 argment2) async {
    await _execute(() => _action(argument1, argment2));
  }
}
