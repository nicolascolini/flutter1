/// Interface abstrata que define o contrato para casos de uso (UseCases).
/// 
/// Ela é genérica, recebendo o tipo de retorno [T] e o 
/// tipo dos parâmetros [Params].
/// [Params] deve estender [Object?], podendo ser qualquer tipo ou nulo.
/// 
/// O método [call] representa a execução do caso de uso, 
/// que recebe os parâmetros
/// e retorna um [Future] com o resultado do tipo [T].
abstract interface class IUseCaseContract<T, Params extends Object?> {
  
  /// Executa o caso de uso com os parâmetros fornecidos.
  /// 
  /// Recebe um objeto do tipo [Params] e retorna um [Future] com o resultado do tipo [T].
  Future<T> call(Params params);
}