import 'package:flutter_test/flutter_test.dart';
import 'package:smart_profile_editor/models/profile_model.dart';

void main() {
  group('Profile Model Tests', () {
    test('fromJson and toJson', () {
      final json = {
        'name': 'Leanne Graham',
        'email': 'Sincere@april.biz',
        'phone': '1-770-736-8031 x56442',
      };

      final profile = Profile.fromJson(json);

      expect(profile.name, 'Leanne Graham');
      expect(profile.email, 'Sincere@april.biz');
      expect(profile.phone, '1-770-736-8031 x56442');

      final outputJson = profile.toJson();
      expect(outputJson['name'], 'Leanne Graham');
      expect(outputJson['email'], 'Sincere@april.biz');
      expect(outputJson['phone'], '1-770-736-8031 x56442');
    });

    test('copyWith works correctly', () {
      const original = Profile(
        name: 'Alice',
        email: 'alice@example.com',
        phone: '12345678',
      );

      final modified = original.copyWith(name: 'Bob');
      expect(modified.name, 'Bob');
      expect(modified.email, 'alice@example.com');
      expect(modified.phone, '12345678');
    });

    test('equality and hashCode', () {
      const p1 = Profile(name: 'Alice', email: 'alice@example.com', phone: '12345678');
      const p2 = Profile(name: 'Alice', email: 'alice@example.com', phone: '12345678');
      const p3 = Profile(name: 'Bob', email: 'alice@example.com', phone: '12345678');

      expect(p1 == p2, isTrue);
      expect(p1.hashCode, p2.hashCode);
      expect(p1 == p3, isFalse);
    });
  });
}
