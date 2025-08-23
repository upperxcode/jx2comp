import 'package:jx2_http_client/core/http_method.dart';
import 'package:jx2_http_client/models/http_request_config.dart';
import 'package:jx2_http_client/models/result_model.dart';
import 'package:jx2_http_client/models/http_response.dart';
import '../http_client.dart';
import '../http_dio.dart' show DioHttpClient;

import '../connectvity_helper.dart';

/// Serviço de cliente HTTP
/// Esta classe é responsável por realizar requisições HTTP.
/// Ela utiliza o cliente HTTP [DioHttpClient] e a classe de configuração
/// [Jx2HttpRequestConfig] para definir os parâmetros da requisição.
/// O serviço também verifica a conectividade antes de realizar a requisição.
/// O serviço é configurável para habilitar ou desabilitar o logging das requisições.
/// O serviço é usado em conjunto com o cliente HTTP [DioHttpClient].
/// O serviço é usado para encapsular a lógica de requisição HTTP
/// e facilitar a realização de requisições HTTP.
class Jx2HttpClientService {
  final HttpClient _httpClient;
  final Jx2ConnectivityHelper _connectivityHelper;
  final bool _enableLogging;

  Jx2HttpClientService({
    HttpClient? httpClient,
    Jx2ConnectivityHelper? connectivityHelper,
    bool enableLogging = false,
  })  : _httpClient = httpClient ?? DioHttpClient(),
        _connectivityHelper = connectivityHelper ?? TestConnectivityHelper(),
        _enableLogging = enableLogging {
    _configureHttpClient();
  }

  void _configureHttpClient() {
    if (_httpClient is DioHttpClient) {
      final dioHttpClient = _httpClient as DioHttpClient;
      dioHttpClient.configureLogging(_enableLogging);
    }
  }

  /// Método para realizar requisições HTTP
  /// @param config Configuração da requisição HTTP
  /// @param parser Função para parsear a resposta
  /// @return Retorna um [Jx2ResultModel] com o resultado da requisição
  /// @note O método verifica a conectividade antes de realizar a requisição
  /// @note O método trata exceções e retorna um [Jx2ResultModel] com o erro
  /// @note O método suporta diferentes métodos HTTP (GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS)
  /// @note O método suporta parâmetros de consulta e corpo da requisição
  /// exemplo:
  /// ```dart
  /// final result = await httpClientService.request(
  ///   config: Jx2HttpRequestConfig(
  ///     url: 'https://example.com/api',
  ///     method: Jx2HttpMethod.get,
  ///     queryParameters: {'param1': 'value1'},
  ///   ),
  ///   parser: (data) => MyModel.fromJson(data),
  /// );
  /// ```
  Future<Jx2ResultModel<T>> request<T>({
    required Jx2HttpRequestConfig config,
    required T Function(dynamic) parser,
  }) async {
    try {
      // Verificar conectividade
      final hasConnection = await _connectivityHelper.checkInternetConnection();
      if (!hasConnection) {
        return Jx2ResultModel.error(
          message: 'Sem conexão com a internet',
          status: Jx2ResultStatus.networkError,
        );
      }

      // Realizar requisição baseada no método
      late HttpResponse response;
      switch (config.method) {
        case Jx2HttpMethod.get:
          response = await _httpClient.get(
            config.url,
            queryParameters: config.queryParameters,
          );

          break;
        case Jx2HttpMethod.post:
          response = await _httpClient.post(
            config.url,
            data: config.body,
            queryParameters: config.queryParameters,
          );
          break;
        case Jx2HttpMethod.put:
          response = await _httpClient.put(
            config.url,
            data: config.body,
            queryParameters: config.queryParameters,
          );
          break;
        case Jx2HttpMethod.delete:
          response = await _httpClient.delete(
            config.url,
            data: config.body,
            queryParameters: config.queryParameters,
          );
          break;
        case Jx2HttpMethod.patch:
          response = await _httpClient.patch(
            config.url,
            data: config.body,
            queryParameters: config.queryParameters,
          );
          break;
        case Jx2HttpMethod.head:
          response = await _httpClient.head(
            config.url,
            queryParameters: config.queryParameters,
          );
          break;
        case Jx2HttpMethod.options:
          response = await _httpClient.options(
            config.url,
            queryParameters: config.queryParameters,
          );
          break;
      }

      // Parsear e retornar resultado
      return Jx2ResultModel.success(
        parser(response.data),
      );
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return Jx2ResultModel.error(
          message: 'Erro de rede: ${e.toString()}',
          status: Jx2ResultStatus.networkError,
        );
      }
      ;
      return Jx2ResultModel.error(
        message: e.toString(),
        status: Jx2ResultStatus.unexpectedError,
      );
    }
  }
}
