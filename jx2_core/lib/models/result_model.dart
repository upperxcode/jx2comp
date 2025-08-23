import '../enums/result_status.dart';
import 'package:equatable/equatable.dart';

/// Classe que representa o resultado de uma operação.
///
/// Esta classe é usada para encapsular os resultados das operações,
/// incluindo status, dados, mensagens e erros.
class Jx2ResultModel<T> extends Equatable {
  /// Status do resultado da operação.
  final Jx2ResultStatus status;

  /// Dados retornados pela operação (opcional).
  final T? data;

  /// Mensagem associada ao resultado (opcional).
  final String? message;

  /// Erro associado ao resultado (opcional).
  final dynamic error;

  /// Construtor para criar uma instância de Jx2ResultModel.
  ///
  /// @param status Status do resultado da operação.
  /// @param data Dados retornados pela operação (opcional).
  /// @param message Mensagem associada ao resultado (opcional).
  /// @param error Erro associado ao resultado (opcional).
  const Jx2ResultModel({
    required this.status,
    this.data,
    this.message,
    this.error,
  });

  /// Fábrica para criar uma instância de Jx2ResultModel com status de sucesso.
  /// @param data Dados retornados pela operação.
  /// @return Uma instância de Jx2ResultModel com status de sucesso.
  /// @note O status é definido como Jx2ResultStatus.success.
  factory Jx2ResultModel.success(T data) => Jx2ResultModel(
        status: Jx2ResultStatus.success,
        data: data,
      );

  /// Fábrica para criar uma instância de Jx2ResultModel com status de erro.
  /// @param message Mensagem associada ao erro (opcional).
  /// @param error Erro associado ao resultado (opcional).
  /// @param status Status do resultado (opcional).
  /// @return Uma instância de Jx2ResultModel com status de erro.
  /// @note O status é definido como Jx2ResultStatus.error, a menos que especificado de outra forma.
  factory Jx2ResultModel.error({
    String? message,
    dynamic error,
    Jx2ResultStatus? status,
  }) =>
      Jx2ResultModel(
        status: status ?? Jx2ResultStatus.error,
        message: message,
        error: error,
      );

  /// Fábrica para criar uma instância de Jx2ResultModel com status de carregamento.
  /// @return Uma instância de Jx2ResultModel com status de carregamento.
  /// @note O status é definido como Jx2ResultStatus.loading.
  factory Jx2ResultModel.loading() => Jx2ResultModel(
        status: Jx2ResultStatus.loading,
      );

  /// Fábrica para criar uma instância de Jx2ResultModel com status vazio.
  /// @return Uma instância de Jx2ResultModel com status vazio.
  /// @note O status é definido como Jx2ResultStatus.empty.
  /// @note Os dados, mensagem e erro são definidos como nulos.
  /// @note Esta fábrica é útil para representar um estado inicial ou vazio.
  factory Jx2ResultModel.empty() => Jx2ResultModel(
        status: Jx2ResultStatus.empty,
      );

  bool get isSuccess => status == Jx2ResultStatus.success;
  bool get isError => status == Jx2ResultStatus.error;
  bool get isLoading => status == Jx2ResultStatus.loading;
  bool get isEmpty => status == Jx2ResultStatus.empty;

  /// Método para converter a instância atual em um mapa JSON.
  /// @return Um mapa JSON representando a instância atual.
  /// @note Este método é útil para serializar a instância para armazenamento ou transmissão.
  @override
  List<Object?> get props => [status, data, message, error];

  /// Método para converter a instância atual em um mapa JSON.
  /// @return Um mapa JSON representando a instância atual.
  /// @note Este método é útil para serializar a instância para armazenamento ou transmissão.
  factory Jx2ResultModel.fromJson(Map<String, dynamic> json) {
    return Jx2ResultModel(
      status: Jx2ResultStatus.values.firstWhere((e) => e.name == json['status'],
          orElse: () => Jx2ResultStatus.error),
      data: json['data'],
      message: json['message'],
      error: json['error'],
    );
  }

  /// Método para converter a instância atual em um mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'data': data,
      'message': message,
      'error': error,
    };
  }
}
