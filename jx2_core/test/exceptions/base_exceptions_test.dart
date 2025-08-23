import 'package:jx2_core/exceptions/base_exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('ErrorCode', () {
    test('should return the correct string representation', () {
      print(ErrorCode.NOT_FOUND.value);
      expect(ErrorCode.NOT_FOUND.value, equals('Not Found'));
    });
  });

  group('Jx2BaseException', () {
    test(
        'constructor should create an exception with a message and status code',
        () {
      final exception = Jx2NetworkException('Erro genérico', statusCode: 500);
      expect(exception.message, equals('Erro genérico'));
      expect(exception.statusCode, equals(500));
    });

    test('fromError should create an exception from another Jx2BaseException',
        () {
      final innerException = Jx2NetworkException('Erro Jx2', statusCode: 500);
      final exception = Jx2BaseException.fromError(innerException);
      expect(exception.message, equals('Erro Jx2'));
      expect(exception.statusCode, equals(500));
    });
  });

  group('Jx2NetworkException', () {
    test('should create an exception with a message and status code', () {
      final exception = Jx2NetworkException(
        'Erro de rede',
        statusCode: 404,
      );
      expect(exception.message, equals('Erro de rede'));
      expect(exception.statusCode, equals(404));
    });
  });

  group('Jx2ValidationException', () {
    test('should create an exception with a message and validation errors', () {
      final exception = Jx2ValidationException(
        'Validação falhou',
        ['Campo obrigatório não preenchido', 'Email inválido'],
      );
      expect(exception.message, equals('Validação falhou'));
      expect(exception.errors,
          equals(['Campo obrigatório não preenchido', 'Email inválido']));
    });
  });

  group('Jx2AuthenticationException', () {
    test('should create an exception with a message and error code', () {
      final exception = Jx2AuthenticationException(
        'Autenticação falhou',
        errorCode: ErrorCode.UNAUTHORIZED,
      );
      expect(exception.message, equals('Autenticação falhou'));
      expect(exception.errorCode, equals(ErrorCode.UNAUTHORIZED));
    });
  });

  group('Jx2ResourceNotFoundException', () {
    test('should create an exception with a resource ID and message', () {
      final exception = Jx2ResourceNotFoundException(
        'id_do_recurso',
        'Recurso não encontrado',
      );
      expect(exception.resourceId, equals('id_do_recurso'));
      expect(exception.message, equals('Recurso não encontrado'));
    });
  });
}
