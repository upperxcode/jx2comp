import 'package:dio/dio.dart';
import '../models/http_response.dart';
import 'http_client.dart';

class DioHttpClient implements HttpClient {
  final Dio _dio;

  // Construtor que permite configuração personalizada
  DioHttpClient({
    Dio? dio,
    BaseOptions? baseOptions,
    List<Interceptor>? interceptors,
  }) : _dio = dio ?? Dio(baseOptions) {
    // Adiciona interceptors personalizados, se fornecidos
    if (interceptors != null) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  Dio get dio => _dio;

  void configureLogging(bool enableLogging) {
    if (enableLogging) {
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📤 HTTP Request: ${options.method} ${options.path}');
          print('Headers: ${options.headers}');
          print('Data: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('📥 HTTP Response: ${response.statusCode}');
          print('Data: ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('❌ HTTP Error: ${e.message}');
          print('Response: ${e.response?.data}');
          return handler.next(e);
        },
      ));
    }
  }

  @override
  Future<HttpResponse> get(String url,
      {dynamic options, Map<String, dynamic>? queryParameters}) async {
    final response =
        await _dio.get(url, queryParameters: queryParameters, options: options);
    return _convertResponse(response);
  }

  @override
  Future<HttpResponse> post(String url,
      {data,
      Map<String, dynamic>? queryParameters,
      options,
      Map<String, dynamic>? headers}) async {
    final response = await _dio.post(url,
        data: data, queryParameters: queryParameters, options: options);
    return _convertResponse(response);
  }

  @override
  Future<HttpResponse> put(String url,
      {data,
      Map<String, dynamic>? queryParameters,
      options,
      Map<String, dynamic>? headers}) async {
    final response = await _dio.put(url,
        data: data, queryParameters: queryParameters, options: options);
    return _convertResponse(response);
  }

  @override
  Future<HttpResponse> delete(String url,
      {data,
      Map<String, dynamic>? queryParameters,
      options,
      Map<String, dynamic>? headers}) async {
    final response = await _dio.delete(url,
        data: data, queryParameters: queryParameters, options: options);
    return _convertResponse(response);
  }

  @override
  Future<HttpResponse> patch(String url,
      {data,
      Map<String, dynamic>? queryParameters,
      options,
      Map<String, dynamic>? headers}) async {
    final response = await _dio.patch(url,
        data: data, queryParameters: queryParameters, options: options);
    return _convertResponse(response);
  }

  @override
  Future<HttpResponse> head(String url,
      {data,
      Map<String, dynamic>? queryParameters,
      options,
      Map<String, dynamic>? headers}) async {
    final response = await _dio.head(url,
        queryParameters: queryParameters, options: options);
    return _convertResponse(response);
  }

  @override
  Future<HttpResponse> options(String url,
      {data,
      Map<String, dynamic>? queryParameters,
      options,
      Map<String, dynamic>? headers}) async {
    final response = await _dio.request(url,
        queryParameters: queryParameters, options: Options(method: 'OPTIONS'));
    return _convertResponse(response);
  }

  HttpResponse _convertResponse(Response dioResponse) {
    return HttpResponse(
      data: dioResponse.data,
      statusCode: dioResponse.statusCode,
      headers: dioResponse.headers.map,
      requestOptions: dioResponse.requestOptions,
    );
  }
}
