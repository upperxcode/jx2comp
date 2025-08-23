
import 'models/http_response.dart';

abstract class HttpClient {
  Future<HttpResponse> get(String url, {Map<String, dynamic>? queryParameters, dynamic options});
  Future<HttpResponse> post(String url, {dynamic data, Map<String, dynamic>? queryParameters, dynamic options});
  Future<HttpResponse> put(String url, {dynamic data, Map<String, dynamic>? queryParameters, dynamic options});
  Future<HttpResponse> delete(String url, {dynamic data, Map<String, dynamic>? queryParameters, dynamic options});
  Future<HttpResponse> patch(String url, {dynamic data, Map<String, dynamic>? queryParameters, dynamic options});
  Future<HttpResponse> head(String url, {Map<String, dynamic>? queryParameters, dynamic options});
  Future<HttpResponse> options(String url, {Map<String, dynamic>? queryParameters, dynamic options});
}
