import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jx2_http_client/connectvity_helper.dart';
import 'package:jx2_http_client/core/http_method.dart';
import 'package:jx2_http_client/http_client.dart';
import 'package:jx2_http_client/models/http_request_config.dart';
import 'package:jx2_http_client/models/http_response.dart';
import 'package:jx2_http_client/models/result_model.dart';
import 'package:jx2_http_client/services/http_client_service.dart';
import 'package:mocktail/mocktail.dart';

// Crie mocks para as dependências
class MockHttpClient extends Mock implements HttpClient {}

class MockConnectivityHelper extends Mock implements Jx2ConnectivityHelper {}

class MockHttpService extends Mock implements Jx2HttpClientService {}

void main() {
  group('Jx2HttpClientService Tests', () {
    late MockHttpClient mockHttpClient;
    late MockConnectivityHelper mockConnectivityHelper;
    late Jx2HttpClientService service;
    late Jx2HttpRequestConfig mockConfig;
    final MockHttpService mockHttpService = MockHttpService();

    setUp(() {
      mockHttpClient = MockHttpClient();
      mockConnectivityHelper = MockConnectivityHelper();
      service = Jx2HttpClientService(
        httpClient: mockHttpClient,
        connectivityHelper: mockConnectivityHelper,
      );
      mockConfig = Jx2HttpRequestConfig(
        url: 'https://example.com/api',
        method: Jx2HttpMethod.get,
      );
    });

    // Função de parser de exemplo
    T _mockParser<T>(dynamic data) {
      if (T == String) {
        return data as T;
      } else if (T == Map<String, dynamic>) {
        return (data as Map).cast<String, dynamic>() as T;
      }
      throw Exception('Unsupported type for mock parser');
    }

    // ***************************
    test(
        'request should return success with parsed data on successful GET request',
        () async {
      mockConfig = mockConfig.copyWith(method: Jx2HttpMethod.get);

      when(() => mockConnectivityHelper.checkInternetConnection())
          .thenAnswer((_) async => true);
      when(() => mockHttpClient.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => HttpResponse(
              data: {"key": "value"},
              statusCode: 200,
              headers: {},
              requestOptions: RequestOptions(path: mockConfig.url)));

      final result = await service.request<Map<String, dynamic>>(
        config: mockConfig,
        parser: _mockParser,
      );

      print(result.data.toString());

      expect(result.isSuccess, isTrue);
      expect(result.data, isA<Map<String, dynamic>>());
      expect(result.data, {'key': 'value'});
      verify(() => mockConnectivityHelper.checkInternetConnection()).called(1);
      verify(() => mockHttpClient.get(mockConfig.url,
          queryParameters: mockConfig.queryParameters)).called(1);
    });
    // ***************************
    test(
        'request should return error on failed GET request with no internet connection',
        () async {
      mockConfig = mockConfig.copyWith(method: Jx2HttpMethod.get);

      when(() => mockConnectivityHelper.checkInternetConnection())
          .thenAnswer((_) async => false);

      final result = await service.request<Map<String, dynamic>>(
        config: mockConfig,
        parser: _mockParser,
      );

      expect(result.isSuccess, isFalse);
      expect(result.message, 'Sem conexão com a internet');
      verify(() => mockConnectivityHelper.checkInternetConnection()).called(1);
    });
    // ***************************

    test(
        'request should return success with parsed data on successful POST request',
        () async {
      mockConfig = mockConfig.copyWith(method: Jx2HttpMethod.post);

      when(() => mockConnectivityHelper.checkInternetConnection())
          .thenAnswer((_) async => true);

      when(() => mockHttpService.request<Map<String, dynamic>>(
              config: mockConfig, parser: _mockParser))
          .thenAnswer((_) async => Jx2ResultModel<Map<String, dynamic>>(
                Jx2ResultStatus.success,
                {'key': 'value'},
                'Error',
                'Sem conexão com a internet',
              ));

      final result = await mockHttpService.request<Map<String, dynamic>>(
        config: mockConfig,
        parser: _mockParser,
      );

      //print(result);

      expect(result.isSuccess, isTrue);
      expect(result.data, isA<Map<String, dynamic>>());
      expect(result.data, {'key': 'value'});
    });
    // ***************************
    test(
        'request should return error on failed POS request with no internet connection',
        () async {
      mockConfig = mockConfig.copyWith(method: Jx2HttpMethod.post);

      when(() => mockConnectivityHelper.checkInternetConnection())
          .thenAnswer((_) async => false);

      final result = await service.request<Map<String, dynamic>>(
        config: mockConfig,
        parser: _mockParser,
      );

      expect(result.isSuccess, isFalse);
      expect(result.message, 'Sem conexão com a internet');
      verify(() => mockConnectivityHelper.checkInternetConnection()).called(1);
    });
    // ***************************
  });
}
