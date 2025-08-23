abstract class Jx2BaseException {
  final String message;

  const Jx2BaseException(this.message);
  @override
  String toString() {
    return '$runtimeType: $message';
  }
}

/// Exceção para erros de rede
class Jx2HttpNetworkException extends Jx2BaseException {
  final int? statusCode;
  final dynamic originalException;

  const Jx2HttpNetworkException(
    String message, {
    this.statusCode,
    this.originalException,
  }) : super(message);

  @override
  String toString() {
    return 'Jx2HttpNetworkException: $message '
        '(Status Code: ${statusCode ?? "N/A"})';
  }
}

/// Exceção para erros de validação
class Jx2HttpClientException extends Jx2BaseException {
  final int? statusCode;
  final dynamic originalException;

  const Jx2HttpClientException(
    String message, {
    this.statusCode,
    this.originalException,
  }) : super(message);

  @override
  String toString() {
    return 'Jx2HttpClientException: $message '
        '(Status Code: ${statusCode ?? "N/A"})';
  }
}

/// Exceção para erros de autenticação
class Jx2HttpTimeoutException extends Jx2BaseException {
  final int? statusCode;
  final dynamic originalException;

  const Jx2HttpTimeoutException(
    String message, {
    this.statusCode,
    this.originalException,
  }) : super(message);

  @override
  String toString() {
    return 'Jx2HttpTimeoutException: $message '
        '(Status Code: ${statusCode ?? "N/A"})';
  }
}
