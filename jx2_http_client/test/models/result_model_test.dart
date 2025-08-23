import 'package:flutter_test/flutter_test.dart';
import 'package:jx2_http_client/models/result_model.dart';

void main() {
  test('should create Jx2ResultModel instances correctly', () {
    // Teste de criação de instância de sucesso
    final successResult = Jx2ResultModel<Map<String, dynamic>>(
      Jx2ResultStatus.success,
      {'key': 'value'},
      'error',
      'Success',
    );

    expect(successResult.isSuccess, isTrue);
    expect(successResult.isError, isFalse);
    expect(successResult.data, isA<Map<String, dynamic>>());
    expect(successResult.data, {'key': 'value'});
    expect(successResult.message, 'Success');
  });
  // Teste de criação de instância de erro
  test('should create Jx2ResultModel instances correctly', () {
    final errorResult = Jx2ResultModel<String>(
      Jx2ResultStatus.error,
      null,
      'Error',
      'Sem conexão com a internet',
    );

    expect(errorResult.isSuccess, isFalse);
    expect(errorResult.isError, isTrue);
    expect(errorResult.data, isNull);
    expect(errorResult.message, 'Sem conexão com a internet');
  });
}
