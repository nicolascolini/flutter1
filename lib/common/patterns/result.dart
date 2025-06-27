// Classe selada (sealed) que representa um resultado que pode ser sucesso ou erro.
// TOk: tipo do valor em caso de sucesso.
// TError: tipo do valor em caso de erro.

sealed class Result<TOk, TError> {
  const Result();

  // Indica se o resultado é sucesso
  bool get isSuccess => this is Success;

  // Indica se o resultado é erro
  bool get isFailure => this is Error;

  // Retorna o valor de sucesso ou null
  TOk? get successValueOrNull => isSuccess ? (this as Success)._value : null;

  // Retorna o valor de erro ou null
  TError? get failureValueOrNull => isFailure ? (this as Error)._value : null;

  // Função que trata ambos os casos (sucesso e erro)
  // R: tipo de retorno após o fold
  R fold<R>({
    required R Function(TOk okValue) onSuccess,
    required R Function(TError errorValue) onFailure,
  }) {
    if (this is Success) {
      return onSuccess((this as Success)._value);
    } else if (this is Error) {
      return onFailure((this as Error)._value);
    }
    throw Exception('Unreachable code'); // segurança extra
  }
}

// Representa um sucesso com valor do tipo TOk
final class Success<TOk, TError> extends Result<TOk, TError> {
  final TOk _value;
  const Success(this._value);
}

// Representa uma falha com valor do tipo TError
final class Error<TOk, TError> extends Result<TOk, TError> {
  final TError _value;
  const Error(this._value);
}
