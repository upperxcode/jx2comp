import 'package:jx2_core/utils/value_validators.dart';
import 'package:test/test.dart';

void main() {
  group('isValidEmail', () {
    test('should return true for valid emails', () {
      expect(Jx2Validators.isValidEmail('test@example.com'), isTrue);
      expect(Jx2Validators.isValidEmail('user.name@domain.co.uk'), isTrue);
    });

    test('should return false for invalid emails', () {
      expect(Jx2Validators.isValidEmail('invalid-email'), isFalse);
      expect(Jx2Validators.isValidEmail('no-at-sign.com'), isFalse);
      expect(Jx2Validators.isValidEmail('@missingusername.com'), isFalse);
    });
  });
}
