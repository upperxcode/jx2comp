/// Exceções personalizadas para o JX2
/// Este arquivo contém definições de exceções personalizadas
/// para o JX2, incluindo exceções para erros de rede,
/// validação, autenticação e recursos não encontrados.
enum ErrorCode {
  UNAUTHORIZED('Unauthorized'),
  FORBIDDEN('Forbidden'),
  NOT_FOUND('Not Found');

  final String description;

  const ErrorCode(this.description);

  @override
  String toString() => name;

  String get value => description;
}

/// Exceções personalizadas para o JX2
/// Este arquivo contém definições de exceções personalizadas
/// para o JX2, incluindo exceções para erros de rede,
/// validação, autenticação e recursos não encontrados.
/// Essas exceções estendem a classe base Jx2BaseException
/// e podem ser usadas para capturar e tratar erros específicos
/// que podem ocorrer durante a execução do aplicativo.
/// As exceções personalizadas incluem:
/// - Jx2NetworkException: Para erros de rede.
/// - Jx2ValidationException: Para erros de validação.
/// - Jx2AuthenticationException: Para erros de autenticação.
/// - Jx2ResourceNotFoundException: Para recursos não encontrados.
/// - UnknownJx2Exception: Para erros desconhecidos.
/// Essas exceções podem ser lançadas em diferentes partes do código
/// e podem ser capturadas e tratadas de forma adequada.
/// A classe base Jx2BaseException é a superclasse de todas as
/// exceções personalizadas e fornece uma estrutura comum
/// para lidar com mensagens de erro e rastreamentos de pilha.
abstract class Jx2BaseException implements Exception {
  final String message;
  final StackTrace? stackTrace;
  final int? statusCode;

  /// Construtor da classe Jx2BaseException.
  /// @param message Mensagem de erro associada à exceção.
  /// @param stackTrace Rastreamento de pilha opcional.
  /// @note O rastreamento de pilha é opcional e pode ser usado
  /// para depuração.
  /// @note A mensagem de erro é obrigatória e deve descrever
  /// o erro ocorrido.
  /// @note O construtor é privado para evitar a criação de instâncias
  /// diretamente da classe base.
  /// @note As subclasses devem chamar este construtor para
  /// inicializar a mensagem e o rastreamento de pilha.
  /// @note As subclasses devem fornecer suas próprias mensagens
  /// de erro específicas.
  /// @note As subclasses devem fornecer suas próprias implementações
  /// do método toString() para exibir informações específicas
  /// sobre a exceção.
  /// @note As subclasses devem fornecer suas próprias implementações
  /// do método fromError() para criar exceções a partir de erros.
  /// @note As subclasses devem fornecer suas próprias implementações
  /// do método fromJson() para criar exceções a partir de dados JSON.
  /// @note As subclasses devem fornecer suas próprias implementações
  /// do método toJson() para serializar exceções em JSON.
  /// @note As subclasses devem fornecer suas próprias implementações
  /// do método toMap() para serializar exceções em um mapa.
  /// @note As subclasses devem fornecer suas próprias implementações
  /// do método fromMap() para criar exceções a partir de um mapa.
  /// @note As subclasses devem fornecer suas próprias implementações
  /// do método toString() para exibir informações específicas
  /// sobre a exceção.
  const Jx2BaseException(this.message, this.statusCode, [this.stackTrace]);

  /// Fábrica para criar uma instância de Jx2BaseException a partir de um erro.
  /// @param error O erro a ser convertido em uma exceção.
  /// @return Uma instância de Jx2BaseException correspondente ao erro.
  /// @note Esta fábrica é útil para converter erros genéricos
  /// em exceções específicas do JX2.
  factory Jx2BaseException.fromError(Object error) {
    if (error is Jx2BaseException) return error;
    return UnknownJx2Exception('Erro desconhecido: $error');
  }

  @override
  String toString() => '$runtimeType: $message';
}

// Exceção para erros desconhecidos
class UnknownJx2Exception extends Jx2BaseException {
  const UnknownJx2Exception(String message, [StackTrace? stackTrace])
      : super(message, null, stackTrace);
}

// Exceção para erros de rede
class Jx2NetworkException extends Jx2BaseException {
  final int? statusCode;
  const Jx2NetworkException(
    String message, {
    this.statusCode,
    StackTrace? stackTrace,
  }) : super(message, statusCode, stackTrace);
}

// Exceção para erros de validação
class Jx2ValidationException extends Jx2BaseException {
  final List<String> errors;

  const Jx2ValidationException(
    String message,
    this.errors, [
    StackTrace? stackTrace,
  ]) : super(message, null, stackTrace);
}

// Exceção para erros de autenticação
class Jx2AuthenticationException extends Jx2BaseException {
  final ErrorCode errorCode;

  const Jx2AuthenticationException(
    String message, {
    this.errorCode = ErrorCode.UNAUTHORIZED,
    StackTrace? stackTrace,
  }) : super(message, null, stackTrace);
}

// Exceção para recursos não encontrados
class Jx2ResourceNotFoundException extends Jx2BaseException {
  final String resourceId;

  const Jx2ResourceNotFoundException(
    this.resourceId,
    String message, [
    StackTrace? stackTrace,
  ]) : super(message, null, stackTrace);
}
