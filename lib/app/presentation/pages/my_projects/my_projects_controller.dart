import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mavx_flutter/app/data/repositories/my_projects_repository_impl.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/data/models/completed_projects_model.dart'
    as confirmed;
import 'package:mavx_flutter/app/domain/usecases/my_project_usecase.dart';
import 'package:mavx_flutter/app/presentation/pages/my_projects/widgets/invoice_bottom_sheet.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/my_projects/widgets/timesheet_bottom_sheet.dart';
import 'package:mavx_flutter/app/domain/usecases/expense_usecase.dart';
import 'package:mavx_flutter/app/data/repositories/expense_repository_impl.dart';
import 'package:mavx_flutter/app/presentation/pages/my_projects/widgets/expenses_bottom_sheet.dart';

class MyProjectsController extends GetxController {
  MyProjectsController({MyProjectUsecase? usecase, ExpenseUseCase? expenseUseCase})
      : _usecase = usecase ?? _ensureUsecase(),
        _expenseUseCase = expenseUseCase ?? _ensureExpenseUsecase();

  final MyProjectUsecase _usecase;
  final ExpenseUseCase _expenseUseCase;
  // Session-scoped persistence to keep submitted invoice state across
  // controller/widget recreations within the same app session
  static final Set<int> _invoicedProjectsStatic = <int>{};
  static const String _kInvoicedPrefsKey = 'invoiced_projects';

  final RxBool loading = false.obs;
  final RxString error = ''.obs;
  final RxList<confirmed.ProjectModel> projects =
      <confirmed.ProjectModel>[].obs;
  // projectId -> has any FINAL_APPROVED timesheet
  final RxMap<int, bool> finalApproved = <int, bool>{}.obs;
  // projectIds for which invoice has been submitted in this session
  final RxSet<int> invoicedProjects = <int>{}.obs;
  int? timesheetId; // holds existing timesheet id for editing
  int? _currentTimesheetExpertId; // cached expert id for currently open timesheet sheet
  final TextEditingController date = TextEditingController();
  final TextEditingController task = TextEditingController();
  final TextEditingController start = TextEditingController();
  final TextEditingController end = TextEditingController();
  final TextEditingController hours = TextEditingController();
  final TextEditingController rate = TextEditingController();
  final TextEditingController amount = TextEditingController();

  bool _isTimesheetApprovedStatus(String status) {
    final s = status.toString().toLowerCase().replaceAll(' ', '_');
    if (s.isEmpty) return false;
    if (s.contains('reject')) return false;
    if (s == 'final_approved' || s == 'client_approved') return true;
    if (s.contains('approved')) return true;
    return false;
  }

  Future<int> _resolveExpertId() async {
    int id = 0;

    // 1) Try ProfileController sources
    try {
      final profile = Get.find<ProfileController>(tag: null);
      final regId = profile.registeredProfile.value.id ?? 0;
      final prefUserId = profile.preferences.value.userId ?? 0;
      log('resolveExpertId -> registeredProfile.id=$regId, preferences.userId=$prefUserId');
      id = regId != 0 ? regId : prefUserId;
    } catch (e) {
      log('resolveExpertId -> ProfileController not available: $e');
    }

    // 2) Fallback to AuthRepository (same source used by login/chat)
    if (id == 0) {
      try {
        final auth = Get.find<AuthRepository>();
        final user = await auth.getCurrentUser();
        final fromAuth = user?.data.id ?? 0;
        log('resolveExpertId -> auth user id=$fromAuth');
        if (fromAuth > 0) {
          id = fromAuth;
        }
      } catch (e) {
        log('resolveExpertId -> AuthRepository failed: $e');
      }
    }

    log('resolveExpertId -> final id=$id');
    return id;
  }

  static MyProjectUsecase _ensureUsecase() {
    try {
      return Get.find<MyProjectUsecase>();
    } catch (_) {
      return Get.put(MyProjectUsecase(Get.put(MyProjectsRepositoryImpl())));
    }
  }

  Future<void> openExpensesBottomSheet({
    required int projectId,
    required String projectName,
  }) async {
    int expertId = 0;
    BuildContext? _initialLoadDialogContext;
    BuildContext? _submitDialogContext;
    try {
      for (final p in projects) {
        final pid = p.projectId ?? p.id ?? 0;
        if (pid == projectId) {
          expertId = p.expertId ?? 0;
          break;
        }
      }
      if (expertId == 0) {
        final profile = Get.find<ProfileController>(tag: null);
        expertId = profile.registeredProfile.value.id ?? 0;
      }
      log("expertId used for expenses: $expertId");
      if (expertId == 0) {
        Get.snackbar('Profile', 'Expert ID not found. Please relogin.');
        return;
      }

      // Cache expert id for this project so saveTimesheetEntries can reuse it
      _currentTimesheetExpertId = expertId;
      log('openTimesheetBottomSheet -> using expertId=$_currentTimesheetExpertId for projectId=$projectId');
      Get.dialog(
        Builder(
          builder: (context) {
            _initialLoadDialogContext = context;
            return const Center(child: CircularProgressIndicator());
          },
        ),
        barrierDismissible: false,
      );
      final resp = await _expenseUseCase.getExpenses(projectId, expertId);
      if (_initialLoadDialogContext != null) {
        Navigator.of(_initialLoadDialogContext!).pop();
        _initialLoadDialogContext = null;
      }
      
      final result = await Get.bottomSheet(
        ExpensesBottomSheet(
          projectId: projectId,
          projectName: projectName,
          existingExpenses: resp.data,
        ),
        isScrollControlled: true,
      );

      // Handle submit from bottom sheet
      if (result is List<Map<String, dynamic>>) {
        // Enrich payloads
        final enriched = result.map((p) {
          final map = Map<String, dynamic>.from(p);
          map['projectId'] = projectId;
          map['expertId'] = expertId;
          // Coerce amount to number if string
          final amt = map['amount'];
          if (amt is String) {
            final v = double.tryParse(amt.trim());
            if (v != null) map['amount'] = v;
          }
          return map;
        }).toList();

        Get.dialog(
          Builder(
            builder: (context) {
              _submitDialogContext = context;
              return const Center(child: CircularProgressIndicator());
            },
          ),
          barrierDismissible: false,
        );
        final ok = await _expenseUseCase.upsertExpenses(enriched);
        if (_submitDialogContext != null) {
          Navigator.of(_submitDialogContext!).pop();
          _submitDialogContext = null;
        }
        if (ok) {
          // Refresh and optionally show a toast
          final refreshed = await _expenseUseCase.getExpenses(projectId, expertId);
          // No dedicated state holder here; rely on reopening or caller refreshing
          Get.snackbar('Expenses', 'Expenses saved successfully');
        } else {
          Get.snackbar('Expenses', 'Failed to save expenses');
        }
      }
    } catch (_) {
      if (_initialLoadDialogContext != null) {
        Navigator.of(_initialLoadDialogContext!).pop();
        _initialLoadDialogContext = null;
      }
      if (_submitDialogContext != null) {
        Navigator.of(_submitDialogContext!).pop();
        _submitDialogContext = null;
      }
      final result = await Get.bottomSheet(
        ExpensesBottomSheet(
          projectId: projectId,
          projectName: projectName,
          existingExpenses: const [],
        ),
        isScrollControlled: true,
      );
      if (result is List<Map<String, dynamic>>) {
        final enriched = result.map((p) {
          final map = Map<String, dynamic>.from(p);
          map['projectId'] = projectId;
          map['expertId'] = expertId;
          final amt = map['amount'];
          if (amt is String) {
            final v = double.tryParse(amt.trim());
            if (v != null) map['amount'] = v;
          }
          return map;
        }).toList();

        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );
        final ok = await _expenseUseCase.upsertExpenses(enriched);
        if (Get.isDialogOpen == true) {
          Navigator.of(Get.context!).pop();
        }
        if (ok) {
          Get.snackbar('Expenses', 'Expenses saved successfully');
        } else {
          Get.snackbar('Expenses', 'Failed to save expenses');
        }
      }
    }
  }

  static ExpenseUseCase _ensureExpenseUsecase() {
    try {
      return Get.find<ExpenseUseCase>();
    } catch (_) {
      return Get.put(ExpenseUseCase(expenseRepository: Get.put(ExpenseRepositoryImpl())));
    }
  }

  Future<bool> uploadInvoice({
    required Map<String, String> fields,
    String? filePath,
  }) async {
    try {
      final payload = Map<String, String>.from(fields);
      // projectId is expected already in fields from UI. Ensure present
      if ((payload['projectId'] ?? '').isEmpty) {
        throw Exception('Project ID missing');
      }

      final projectId = int.tryParse(payload['projectId']!.toString()) ?? 0;
      if (projectId == 0) {
        throw Exception('Invalid Project ID');
      }

      // Resolve expertId similar to timesheet flow: prefer project expertId, then fallback
      int expertId = 0;
      for (final p in projects) {
        final pid = p.projectId ?? p.id ?? 0;
        if (pid == projectId) {
          expertId = p.expertId ?? 0;
          break;
        }
      }
      if (expertId == 0) {
        expertId = await _resolveExpertId();
      }

      log('uploadInvoice -> resolved expertId=$expertId for projectId=$projectId');
      if (expertId == 0) {
        throw Exception('Expert ID not found. Please relogin.');
      }

      payload['expertId'] = expertId.toString();

      // Server requires a timesheet reference. Find a FINAL_APPROVED timesheet for this project.
      final timesheets = await _usecase.getTimesheets(projectId, expertId);
      if (timesheets.isEmpty) {
        throw Exception('No timesheet found for this project. Please submit timesheet before invoice.');
      }

      var selectedTimesheetId = 0;
      for (final t in timesheets) {
        if (_isTimesheetApprovedStatus(t.status)) {
          selectedTimesheetId = t.id;
          break;
        }
      }
      if (selectedTimesheetId == 0) {
        // Fallback: still attempt invoice upload with the latest timesheet id
        // (backend will validate status requirements and return proper message).
        selectedTimesheetId = timesheets
            .map((e) => e.id)
            .fold<int>(0, (prev, id) => id > prev ? id : prev);
      }
      if (selectedTimesheetId == 0) {
        throw Exception('Timesheet ID missing for this project.');
      }

      // Attach both variants to be safe
      payload['timesheet_id'] = selectedTimesheetId.toString();
      payload['timesheetId'] = selectedTimesheetId.toString();

      // filePath is optional; UI enforces requirement when checkbox is checked
      final ok = await _usecase.uploadInvoice(fields: payload, filePath: filePath);
      if (ok) {
        invoicedProjects.add(projectId);
        invoicedProjects.refresh();
        _invoicedProjectsStatic.add(projectId);
        _saveInvoicedToPrefs();
      }
      return ok;
    } catch (e) {
      rethrow;
    }
  }

  void openInvoiceBottomSheet({
    required int projectId,
    required String projectName,
  }) {
    Get.bottomSheet(
      InvoiceBottomSheet(projectId: projectId, projectName: projectName),
    );
  }

  Future<int> saveTimesheetEntries({
    required int projectId,
    required String projectName,
    required List<Map<String, dynamic>> entries,
  }) async {
    // Prefer expert id cached when opening the bottom sheet; fall back to global resolver
    final resolved = _currentTimesheetExpertId ?? await _resolveExpertId();
    print("expertId: $resolved");
    log('saveTimesheetEntries -> cached=$_currentTimesheetExpertId');
    final expertId = resolved;
    if (expertId == 0) {
      throw Exception('Expert ID not found. Please relogin.');
    }

    int success = 0;
    for (final e in entries) {
      final payload = <String, dynamic>{
        'expertId': expertId,
        'projectId': projectId,
        'projectName': projectName,
        'workDate': (e['workDate'] ?? '').toString(),
        'taskDescription': (e['taskDescription'] ?? 'Work log').toString(),
        'startTime': (e['startTime'] ?? '').toString(),
        'endTime': (e['endTime'] ?? '').toString(),
        'totalHours': double.tryParse(e['totalHours']?.toString() ?? '') ?? 0.0,
        'hourlyRate': double.tryParse(e['hourlyRate']?.toString() ?? '') ?? 0.0,
        'amount': double.tryParse(e['amount']?.toString() ?? '') ?? 0.0,
      };
      final idVal = e['id'];
      if (idVal != null) {
        final idInt = int.tryParse(idVal.toString());
        if (idInt != null && idInt > 0) {
          payload['id'] = idInt;
          payload['timesheetId'] = idInt;
          payload['timesheet_id'] = idInt;
        }
      }
      final ok = await _usecase.createProjectSchedule(payload);
      if (ok) success++;
    }

    if (success > 0) {
      try {
        final ts = await _usecase.getTimesheets(projectId, expertId);
        final hasApproved = ts.any((t) {
          final s = (t.status).toString().toLowerCase();
          return s == 'final_approved' || s == 'client_approved';
        });
        finalApproved[projectId] = hasApproved;
        finalApproved.refresh();
      } catch (_) {}
    }

    return success;
  }

  @override
  void onInit() {
    super.onInit();
    // Seed from static cache to survive page recreations
    if (_invoicedProjectsStatic.isNotEmpty) {
      invoicedProjects.addAll(_invoicedProjectsStatic);
      invoicedProjects.refresh();
    }
    // Also load from SharedPreferences (persisted across app restarts)
    _loadInvoicedFromPrefs();
    fetchData();
  }

  Future<void> _loadInvoicedFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_kInvoicedPrefsKey) ?? const <String>[];
      if (list.isNotEmpty) {
        final ids = list.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0);
        if (ids.isNotEmpty) {
          invoicedProjects.addAll(ids);
          _invoicedProjectsStatic.addAll(ids);
          invoicedProjects.refresh();
        }
      }
    } catch (_) {
      // ignore
    }
  }

  Future<void> _saveInvoicedToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = invoicedProjects.map((e) => e.toString()).toList();
      await prefs.setStringList(_kInvoicedPrefsKey, list);
    } catch (_) {
      // ignore
    }
  }

  Future<void> fetchData() async {
    loading.value = true;
    error.value = '';
    try {
      final list = await _usecase.getMyConfirmedProjects();
      projects.assignAll(list);
      // After loading projects, prefetch FINAL_APPROVED status for invoice button
      await prefetchTimesheetStatuses();
    } catch (e) {
      error.value = 'Something went wrong'; 
    } finally {
      loading.value = false;
    }
  }

  Future<void> prefetchTimesheetStatuses() async {
    try {
      final expertId = await _resolveExpertId();
      log('prefetchTimesheetStatuses -> expertId=$expertId');
      if (expertId == 0) return;
      // Clear previous
      finalApproved.clear();
      for (final p in projects) {
        final pid = p.projectId ?? p.id ?? 0;
        if (pid == 0) continue;
        try {
          final ts = await _usecase.getTimesheets(pid, expertId);
          log('prefetchTimesheetStatuses -> projectId=$pid, timesheets=${ts.length}');
          finalApproved[pid] = ts.any((t) {
            final raw = (t.status).toString();
            log('prefetchTimesheetStatuses -> projectId=$pid, timesheetId=${t.id}, status=${raw.toLowerCase()}');
            return _isTimesheetApprovedStatus(raw);
          });
        } catch (_) {
          // ignore failures per project
        }
      }
      finalApproved.refresh();
    } catch (_) {
      // ignore
    }
  }

  // bool _isFourthWeekNow(DateTime d) {
  //   // Week of month: 1..5 using 7-day buckets; 4th week ~ days 22-28
  //   final week = ((d.day - 1) ~/ 7) + 1;
  //   return week == 4;
  // }

  Future<void> openTimesheetBottomSheet({
    required int projectId,
    required String projectName,
  }) async {
    BuildContext? _timesheetDialogContext;
    try {
      // Prefer expert id attached to the project; fall back to global resolver
      int expertId = 0;
      for (final p in projects) {
        final pid = p.projectId ?? p.id ?? 0;
        if (pid == projectId) {
          expertId = p.expertId ?? 0;
          break;
        }
      }
      log('openTimesheetBottomSheet -> project expertId=$expertId for projectId=$projectId');

      if (expertId == 0) {
        expertId = await _resolveExpertId();
        log('openTimesheetBottomSheet -> fallback resolved expertId=$expertId');
      }

      if (expertId == 0) {
        Get.snackbar('Profile', 'Expert ID not found. Please relogin.');
        return;
      }

      // Cache expert id for this sheet session so saveTimesheetEntries can reuse it
      _currentTimesheetExpertId = expertId;
      log('openTimesheetBottomSheet -> using expertId=$_currentTimesheetExpertId for projectId=$projectId');

      Get.dialog(
        Builder(
          builder: (context) {
            _timesheetDialogContext = context;
            return const Center(child: CircularProgressIndicator());
          },
        ),
        barrierDismissible: false,
      );

      final existing = await _usecase.getTimesheets(projectId, expertId);

      if (_timesheetDialogContext != null) {
        Navigator.of(_timesheetDialogContext!).pop();
        _timesheetDialogContext = null;
      }

      await Get.bottomSheet(
        TimesheetBottomSheet(
          projectId: projectId,
          projectName: projectName,
          existingTimesheets: existing,
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      if (_timesheetDialogContext != null) {
        Navigator.of(_timesheetDialogContext!).pop();
        _timesheetDialogContext = null;
      }
      await Get.bottomSheet(
        TimesheetBottomSheet(
          projectId: projectId,
          projectName: projectName,
          existingTimesheets: const [],
        ),
        isScrollControlled: true,
      );
    }
  }
}
