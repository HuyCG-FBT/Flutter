import 'dart:async';
import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';
import '../services/draft_service.dart';

class ProfileScreen extends StatefulWidget {
  final ProfileRepository? repository;
  final DraftService? draftService;

  const ProfileScreen({
    super.key,
    this.repository,
    this.draftService,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();

  late final ProfileRepository _repository;
  late final DraftService _draftService;

  bool _loading = false;
  String? _errorText;
  Profile? _originalProfile;

  // Chống save draft quá dày: debounce 400ms
  Timer? _draftDebounce;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? ProfileRepository();
    _draftService = widget.draftService ?? DraftService();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      // 1) Ưu tiên draft trước (nếu có)
      final draft = await _draftService.loadDraft();
      if (draft != null) {
        _applyProfileToForm(draft);
      } else {
        // 2) Không có draft => gọi API lấy profile
        final profile = await _repository.getProfile();
        _applyProfileToForm(profile);
      }
    } catch (e) {
      setState(() {
        _errorText = "Không tải được dữ liệu. Thử lại.\nChi tiết: $e";
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _applyProfileToForm(Profile p) {
    _originalProfile = p;
    _nameCtrl.text = p.name;
    _emailCtrl.text = p.email;
    _phoneCtrl.text = p.phone;
  }

  Profile _currentProfile() {
    return Profile(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );
  }

  bool get _isDirty {
    if (_originalProfile == null) return false;
    return _originalProfile != _currentProfile();
  }

  // Validation đơn giản, phù hợp chuẩn đề bài
  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) return "Không được để trống";
    return null;
  }

  String? _validateEmail(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return "Không được để trống";
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v);
    if (!ok) return "Email không hợp lệ (ví dụ: a@b.com)";
    return null;
  }

  String? _validatePhone(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return "Không được để trống";
    final ok = RegExp(r'^[0-9+\-\s()]{8,}$').hasMatch(v);
    if (!ok) return "SĐT không hợp lệ (ít nhất 8 ký tự số)";
    return null;
  }

  void _scheduleDraftSave() {
    setState(() {}); // trigger rebuild để cập nhật trạng thái _isDirty nếu cần
    _draftDebounce?.cancel();
    _draftDebounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        await _draftService.saveDraft(_currentProfile());
      } catch (e) {
        // ignore: avoid_print
        print("Save draft error: $e");
      }
    });
  }

  Future<void> _submit() async {
    // 1) Đóng keyboard
    FocusScope.of(context).unfocus();

    // 2) Validate
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      final updated = _currentProfile();
      await _repository.updateProfile(updated);
      await _draftService.clearDraft();
      _originalProfile = updated;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật thành công")),
      );
    } catch (e) {
      setState(() {
        _errorText = "Cập nhật thất bại.\nChi tiết: $e";
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật thất bại")),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<bool> _showExitConfirmDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Bạn chưa lưu"),
        content: const Text("Bạn có thay đổi chưa lưu. Bạn có chắc muốn thoát không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Ở lại"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Thoát"),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  void dispose() {
    _draftDebounce?.cancel();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : _errorText != null
            ? _ErrorView(
                message: _errorText!,
                onRetry: _bootstrap,
              )
            : _buildForm();

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmDialog();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Smart Profile Editor"),
          actions: [
            IconButton(
              onPressed: _loading ? null : _bootstrap,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SafeArea(child: body),
      ),
    );
  }

  Widget _buildForm() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                focusNode: _nameFocus,
                decoration: const InputDecoration(
                  labelText: "Họ tên",
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: _validateRequired,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                onChanged: (_) => _scheduleDraftSave(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                focusNode: _emailFocus,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_phoneFocus),
                onChanged: (_) => _scheduleDraftSave(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneCtrl,
                focusNode: _phoneFocus,
                decoration: const InputDecoration(
                  labelText: "Số điện thoại",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                validator: _validatePhone,
                onFieldSubmitted: (_) => _submit(),
                onChanged: (_) => _scheduleDraftSave(),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: const Text("Lưu cập nhật"),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Gợi ý: nhập thử sai email/phone để xem validation.\n"
                "Thoát app mở lại để kiểm tra Draft.",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => onRetry(),
              child: const Text("Thử lại"),
            ),
          ],
        ),
      ),
    );
  }
}
