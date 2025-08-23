import 'package:jx2_http_client/core/http_method.dart';

/// Configuração para requisições HTTP.
/// Esta classe é usada para definir os parâmetros de uma requisição HTTP,
/// incluindo URL, método, cabeçalhos, corpo, parâmetros de consulta e tempo limite.
/// A classe é imutável e fornece um método `copyWith` para criar
/// uma nova instância com valores modificados.
/// A classe é usada em conjunto com o cliente HTTP [DioHttpClient].
/// A classe é usada para encapsular as configurações de requisição
/// e facilitar a criação de requisições HTTP.
/// A classe é usada em conjunto com o cliente HTTP [DioHttpClient].
/// A classe é usada para encapsular as configurações de requisição
/// e facilitar a criação de requisições HTTP.
class Jx2HttpRequestConfig {
  final String url;
  final Jx2HttpMethod method;
  final Map<String, dynamic>? headers;
  final dynamic body;
  final Map<String, dynamic>? queryParameters;
  final Duration? timeout;

  const Jx2HttpRequestConfig({
    required this.url,
    required this.method,
    this.headers,
    this.body,
    this.queryParameters,
    this.timeout = const Duration(seconds: 30),
  });

  Jx2HttpRequestConfig copyWith({
    String? url,
    Jx2HttpMethod? method,
    Map<String, dynamic>? headers,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) {
    return Jx2HttpRequestConfig(
      url: url ?? this.url,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      queryParameters: queryParameters ?? this.queryParameters,
      timeout: timeout ?? this.timeout,
    );
  }
}
