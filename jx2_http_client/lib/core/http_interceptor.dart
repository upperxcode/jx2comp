import 'package:dio/dio.dart';
import 'package:jx2_platform/jx2_platform.dart';

//// Interceptor para adicionar informações do dispositivo e registrar requisições
/// e respostas HTTP.
/// Este interceptor é usado para adicionar informações do dispositivo
/// (como plataforma e modelo) aos cabeçalhos das requisições HTTP.
/// Além disso, ele registra as requisições e respostas HTTP no console
/// para fins de depuração.
/// O interceptor pode ser habilitado ou desabilitado através do parâmetro
/// [enableLogging].
/// O interceptor é uma subclasse de [Interceptor] do pacote Dio.
/// O interceptor é usado em conjunto com o cliente HTTP [DioHttpClient].
/// O interceptor é configurado para adicionar informações do dispositivo
/// e registrar requisições e respostas HTTP.
/// O interceptor é usado em conjunto com o cliente HTTP [DioHttpClient].
/// O interceptor é configurado para adicionar informações do dispositivo
/// e registrar requisições e respostas HTTP.
/// O interceptor é usado em conjunto com o cliente HTTP [DioHttpClient].
/// O interceptor é configurado para adicionar informações do dispositivo
/// e registrar requisições e respostas HTTP.
class Jx2HttpInterceptor extends Interceptor {
  final bool enableLogging;

  Jx2HttpInterceptor({this.enableLogging = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enableLogging) {
      _logRequest(options);
    }
    _addDeviceInfo(options);
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enableLogging) {
      _logResponse(response);
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enableLogging) {
      _logError(err);
    }
    return handler.next(err);
  }

  void _logRequest(RequestOptions options) {
    print('🚀 HTTP Request');
    print('URL: ${options.path}');
    print('Method: ${options.method}');
    print('Headers: ${options.headers}');
    print('Query Params: ${options.queryParameters}');
    print('Body: ${options.data}');
  }

  void _logResponse(Response response) {
    print('✅ HTTP Response');
    print('URL: ${response.requestOptions.path}');
    print('Status Code: ${response.statusCode}');
    print('Data: ${response.data}');
  }

  void _logError(DioException err) {
    print('❌ HTTP Error');
    print('URL: ${err.requestOptions.path}');
    print('Error: ${err.message}');
    print('Status Code: ${err.response?.statusCode}');
  }

  Future<void> _addDeviceInfo(RequestOptions options) async {
    try {
      final deviceInfo = await Jx2DeviceInfoHelper.getDeviceDetails();

      options.headers.addAll({
        'X-Device-Platform': deviceInfo['platform'],
        'X-Device-Model': deviceInfo['model'] ?? 'unknown',
      });
    } catch (e) {
      // Silenciosamente ignora erros de adição de informações do dispositivo
    }
  }
}
