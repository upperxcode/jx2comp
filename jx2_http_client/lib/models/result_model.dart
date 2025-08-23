enum Jx2ResultStatus {
  success,
  error,
  networkError,
  unauthorized,
  notFound,
  badRequest,
  unexpectedError,
  methodNotAllowed,
  badCertificate,
}

/// Modelo de resultado genérico para operações assíncronas.
/// Este modelo encapsula o status da operação, os dados retornados,
/// mensagens de erro e outros detalhes relevantes.
/// É usado para representar o resultado de operações que podem
/// ter sucesso, falhar ou estar em andamento.
/// O modelo é genérico, permitindo que seja usado com diferentes tipos de dados.
/// O modelo é usado em conjunto com o cliente HTTP [DioHttpClient].
/// O modelo é usado para encapsular os resultados das operações,
/// incluindo status, dados, mensagens e erros.

class Jx2ResultModel<T> {
  final Jx2ResultStatus status;
  final T? data;
  final dynamic _error;
  final String? message;

  const Jx2ResultModel(this.status, this.data, [this._error, this.message]);

  bool get isSuccess => status == Jx2ResultStatus.success;
  bool get isError => status != Jx2ResultStatus.success;

  // Getter para erro
  dynamic get error => _error;

  // Métodos de fábrica
  factory Jx2ResultModel.success(T data) {
    return Jx2ResultModel(Jx2ResultStatus.success, data);
  }

  factory Jx2ResultModel.error(
      {String? message,
      dynamic error,
      Jx2ResultStatus status = Jx2ResultStatus.error}) {
    return Jx2ResultModel(status, null, error, message);
  }

  // Método para conversão para JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status.toString(),
      'data': data,
      'error': error?.toString(),
      'message': message,
    };
  }

  @override
  String toString() {
    return 'Jx2ResultModel(status: $status, data: $data, error: $error, message: $message)';
  }
}
