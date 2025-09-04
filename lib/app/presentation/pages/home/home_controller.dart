import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/data/models/user_model.dart';

class HomeController extends GetxController {
  HomeController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? Get.find<AuthRepository>();

  final AuthRepository _authRepository;

  // Reactive user data for header
  final Rxn<UserData> user = Rxn<UserData>();
  final RxString greeting = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _computeGreeting();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final model = await _authRepository.getCurrentUser();
      user.value = model?.data;
    } catch (_) {
      // ignore error, keep null user
    }
  }

  void _computeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Good Morning';
    } else if (hour < 17) {
      greeting.value = 'Good Afternoon';
    } else {
      greeting.value = 'Good Evening';
    }
  }

  String get firstName {
    final data = user.value;
    if (data == null) return '';
    final name = data.fullName.trim().isNotEmpty ? data.fullName.trim() : data.email;
    final parts = name.split(' ');
    return parts.isNotEmpty ? parts.first : name;
  }

  String get fullName {
    final data = user.value;
    if (data == null) return '';
    return data.fullName.trim().isNotEmpty ? data.fullName.trim() : data.email;
  }

  String? get avatarUrl {
    final p = user.value?.profile.trim();
    if (p == null || p.isEmpty) return null;
    final uri = Uri.tryParse(p);
    if (uri == null) return null;
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') return null;
    return p;
  }
}