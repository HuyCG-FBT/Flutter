import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_profile_editor/models/profile_model.dart';
import 'package:smart_profile_editor/services/draft_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DraftService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('saveDraft, loadDraft, and clearDraft workflow', () async {
      final draftService = DraftService();

      // Initially no draft
      final initialDraft = await draftService.loadDraft();
      expect(initialDraft, isNull);

      // Save draft
      const profile = Profile(
        name: 'Huy Chau',
        email: 'huy@fpt.edu.vn',
        phone: '0901234567',
      );
      await draftService.saveDraft(profile);

      // Load draft
      final loaded = await draftService.loadDraft();
      expect(loaded, isNotNull);
      expect(loaded!.name, 'Huy Chau');
      expect(loaded.email, 'huy@fpt.edu.vn');
      expect(loaded.phone, '0901234567');

      // Clear draft
      await draftService.clearDraft();
      final afterClear = await draftService.loadDraft();
      expect(afterClear, isNull);
    });
  });
}
