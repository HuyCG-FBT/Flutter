import 'package:flutter_test/flutter_test.dart';
import 'package:smart_registration_app/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('required validator', () {
      expect(Validators.required(null), 'Field is required');
      expect(Validators.required(''), 'Field is required');
      expect(Validators.required('   '), 'Field is required');
      expect(Validators.required('John Doe'), isNull);
    });

    test('email validator', () {
      expect(Validators.email(null), 'Email required');
      expect(Validators.email(''), 'Email required');
      expect(Validators.email('invalid-email'), 'Invalid email format');
      expect(Validators.email('user@'), 'Invalid email format');
      expect(Validators.email('user@domain'), 'Invalid email format');
      expect(Validators.email('user@test.com'), isNull);
    });

    test('password validator', () {
      expect(Validators.password(null), 'Password must be at least 6 characters');
      expect(Validators.password('12345'), 'Password must be at least 6 characters');
      expect(Validators.password('123456'), isNull);
      expect(Validators.password('strongPassword123'), isNull);
    });
  });
}
