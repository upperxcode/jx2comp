import 'package:dio/dio.dart';
import 'package:jx2_http_client/models/http_response.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jx2_http_client/http_dio.dart';

class MockDio extends Mock implements Dio {}

const jsonResponse = '''
{
  "key": "value"
}
''';

void main() {
  group('DioHttpClient', () {
    late DioHttpClient httpClient;
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      httpClient = DioHttpClient(dio: mockDio);
    });

    test('should create DioHttpClient with default Dio instance', () async {
      final url = 'https://jsonplaceholder.typicode.com/posts/1';
      final dioQueryParameters = {'key': 'value'};
      final dioOptions = Options(responseType: ResponseType.json);

      when(() => mockDio.get(url,
              queryParameters: dioQueryParameters, options: dioOptions))
          .thenAnswer((_) async => Response(
              data: jsonResponse,
              statusCode: 200,
              requestOptions: RequestOptions(path: url),
              headers: Headers.fromMap({})));

      final response = await httpClient.get(url,
          queryParameters: dioQueryParameters, options: dioOptions);
      expect(httpClient.dio, isA<Dio>());
      expect(response, isA<HttpResponse>());
    });

    test('should call Dio get method with correct parameters', () async {
      final url = 'https://example.com';
      final dioQueryParameters = {'key': 'value'};
      final dioOptions = Options(responseType: ResponseType.json);
      final headers = {
        'Content-Type': ['application/json'],
      };

      when(() => mockDio.get(url,
              queryParameters: dioQueryParameters, options: dioOptions))
          .thenAnswer((_) async => Response(
              data: jsonResponse,
              statusCode: 200,
              requestOptions: RequestOptions(path: url),
              headers: Headers.fromMap(headers)));

      final response = await httpClient.get(url,
          queryParameters: dioQueryParameters, options: dioOptions);

      print("resposta " + response.data.toString());

      expect(response.data, jsonResponse);
      expect(response.statusCode, 200);
    });
    test('should call Dio post method with correct parameters', () async {
      final url = 'https://example.com';
      final data = {'key': 'value'};
      final dioOptions = Options(responseType: ResponseType.json);
      final headers = {
        'Content-Type': ['application/json'],
      };

      when(() => mockDio.post(url, data: data, options: dioOptions)).thenAnswer(
          (_) async => Response(
              data: jsonResponse,
              statusCode: 201,
              requestOptions: RequestOptions(path: url),
              headers: Headers.fromMap(headers)));

      final response =
          await httpClient.post(url, data: data, options: dioOptions);

      print("resposta " + response.data.toString());

      expect(response.data, jsonResponse);
      expect(response.statusCode, 201);
    });
    test('should call Dio put method with correct parameters', () async {
      final url = 'https://example.com';
      final data = {'key': 'value'};
      final dioOptions = Options(responseType: ResponseType.json);
      final headers = {
        'Content-Type': ['application/json'],
      };

      when(() => mockDio.put(url, data: data, options: dioOptions)).thenAnswer(
          (_) async => Response(
              data: jsonResponse,
              statusCode: 200,
              requestOptions: RequestOptions(path: url),
              headers: Headers.fromMap(headers)));

      final response =
          await httpClient.put(url, data: data, options: dioOptions);

      print("resposta " + response.data.toString());

      expect(response.data, jsonResponse);
      expect(response.statusCode, 200);
    });
    test('should call Dio delete method with correct parameters', () async {
      final url = 'https://example.com';
      final dioOptions = Options(responseType: ResponseType.json);

      when(() => mockDio.delete(url, options: dioOptions)).thenAnswer(
          (_) async => Response(
              data: jsonResponse,
              statusCode: 204,
              requestOptions: RequestOptions(path: url),
              headers: Headers.fromMap({})));

      final response = await httpClient.delete(url, options: dioOptions);

      print("resposta " + response.data.toString());

      expect(response.data, jsonResponse);
      expect(response.statusCode, 204);
    });
  });
}
