import 'package:dio/src/options.dart';

/// classe para representar a resposta HTTP
/// Esta classe é usada para encapsular os dados retornados por uma requisição HTTP,
/// incluindo o corpo da resposta, o código de status e os cabeçalhos.
/// A classe é usada em conjunto com o cliente HTTP [DioHttpClient].
/// A classe é usada para encapsular os dados retornados por uma requisição HTTP,
/// incluindo o corpo da resposta, o código de status e os cabeçalhos.
/// A classe é usada em conjunto com o cliente HTTP [DioHttpClient].
/// A classe é usada para encapsular os dados retornados por uma requisição HTTP,
class HttpResponse {
  final dynamic data;
  final int? statusCode;
  final Map<String, List<String>> headers;

  HttpResponse({
    required this.data,
    required this.statusCode,
    required this.headers,
    required RequestOptions requestOptions,
  });
}
