import 'package:jx2_core/enums/result_status.dart';
import 'package:jx2_core/models/result_model.dart';
import 'package:test/test.dart';
// Certifique-se de que o caminho está correto

void main() {
  group('Jx2ResultModel', () {
    test('should create a success result with data', () {
      final result = Jx2ResultModel.success(42);
      expect(result.status, Jx2ResultStatus.success);
      expect(result.data, 42);
      expect(result.message, null);
      expect(result.error, null);
    });

    test('should create an error result with message and optional status', () {
      final result = Jx2ResultModel.error(message: 'An error occurred');
      expect(result.status, Jx2ResultStatus.error);
      expect(result.data, null);
      expect(result.message, 'An error occurred');
      expect(result.error, null);
    });

    test('should create a loading result', () {
      final result = Jx2ResultModel.loading();
      expect(result.status, Jx2ResultStatus.loading);
      expect(result.data, null);
      expect(result.message, null);
      expect(result.error, null);
    });

    test('should create an empty result', () {
      final result = Jx2ResultModel.empty();
      expect(result.status, Jx2ResultStatus.empty);
      expect(result.data, null);
      expect(result.message, null);
      expect(result.error, null);
    });

    test('should have the correct getters', () {
      final successResult = Jx2ResultModel.success(42);
      final errorResult = Jx2ResultModel.error(message: 'An error occurred');
      final loadingResult = Jx2ResultModel.loading();
      final emptyResult = Jx2ResultModel.empty();

      expect(successResult.isSuccess, true);
      expect(successResult.isError, false);
      expect(successResult.isLoading, false);
      expect(successResult.isEmpty, false);

      expect(errorResult.isSuccess, false);
      expect(errorResult.isError, true);
      expect(errorResult.isLoading, false);
      expect(errorResult.isEmpty, false);

      expect(loadingResult.isSuccess, false);
      expect(loadingResult.isError, false);
      expect(loadingResult.isLoading, true);
      expect(loadingResult.isEmpty, false);

      expect(emptyResult.isSuccess, false);
      expect(emptyResult.isError, false);
      expect(emptyResult.isLoading, false);
      expect(emptyResult.isEmpty, true);
    });

    test('should convert to and from JSON', () {
      final result = Jx2ResultModel.success(42);
      final json = result.toJson();
      expect(json['status'], 'success');
      expect(json['data'], 42);
      expect(json['message'], null);
      expect(json['error'], null);

      final newResult = Jx2ResultModel.fromJson(json);
      expect(newResult.status, Jx2ResultStatus.success);
      expect(newResult.data, 42);
      expect(newResult.message, null);
      expect(newResult.error, null);
    });
  });
}
