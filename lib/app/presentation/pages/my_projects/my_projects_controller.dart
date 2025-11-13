import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mavx_flutter/app/data/repositories/my_projects_repository_impl.dart';
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
  final TextEditingController date = TextEditingController();
  final TextEditingController task = TextEditingController();
  final TextEditingController start = TextEditingController();
  final TextEditingController end = TextEditingController();
  final TextEditingController hours = TextEditingController();
  final TextEditingController rate = TextEditingController();
  final TextEditingController amount = TextEditingController();

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
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      final resp = await _expenseUseCase.getExpenses(projectId, expertId);
      if (Get.isDialogOpen == true) Get.back();
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
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );
        final ok = await _expenseUseCase.upsertExpenses(enriched);
        if (Get.isDialogOpen == true) Get.back();
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
      if (Get.isDialogOpen == true) Get.back();
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
        if (Get.isDialogOpen == true) Get.back();
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
      final profile = Get.find<ProfileController>(tag: null);
      final expertId = profile.preferences.value.userId ?? 0;
     
      if (expertId == 0) {
        Get.snackbar(
          'Invoice',
          'Expert ID not found. Please relogin.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
      final payload = Map<String, String>.from(fields);
      payload['expertId'] = expertId.toString();
      // projectId is expected already in fields from UI. Ensure present
      if ((payload['projectId'] ?? '').isEmpty) {
        Get.snackbar(
          'Invoice',
          'Project ID missing',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
      final projectId = int.tryParse(payload['projectId']!.toString()) ?? 0;
      if (projectId == 0) {
        Get.snackbar(
          'Invoice',
          'Invalid Project ID',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // Server requires a timesheet reference. Find a FINAL_APPROVED timesheet for this project.
      final timesheets = await _usecase.getTimesheets(projectId, expertId);
      var approvedId = 0;
      for (final t in timesheets) {
        if ((t.status) == 'final_approved' || (t.status) == 'client_approved') {
          approvedId = t.id;
          break;
        }
      }
      print("expertId: $expertId");
      if (approvedId == 0) {
        Get.snackbar(
          'Invoice',
          'No FINAL_APPROVED timesheet found for this project. Please get a timesheet approved before submitting an invoice.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
      // Attach both variants to be safe
      payload['timesheet_id'] = approvedId.toString();
      payload['timesheetId'] = approvedId.toString();

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
      Get.snackbar(
        'Invoice',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
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
    // Get expert id
    final profile = Get.find<ProfileController>(tag: null);
    final expertId = profile.preferences.value.userId ?? 0;
    print("expertId: $expertId");
    if (expertId == 0) {
      Get.snackbar('Profile', 'Expert ID not found. Please relogin.');
      return 0;
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
      // If editing, pass id so backend updates instead of inserting a duplicate
      final idVal = e['id'];
      if (idVal != null) {
        final idInt = int.tryParse(idVal.toString());
        if (idInt != null && idInt > 0) {
          payload['id'] = idInt;
          // Also include common variants in case backend expects a different key
          payload['timesheetId'] = idInt;
          payload['timesheet_id'] = idInt;
        }
      }
      final ok = await _usecase.createProjectSchedule(payload);
      if (ok) success++;
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
      final profile = Get.find<ProfileController>(tag: null);
      final expertId = profile.registeredProfile.value.id ?? 0;
      if (expertId == 0) return;
      // Clear previous
      finalApproved.clear();
      for (final p in projects) {
        final pid = p.projectId ?? p.id ?? 0;
        if (pid == 0) continue;
        try {
          final ts = await _usecase.getTimesheets(pid, expertId);
          finalApproved[pid] = ts.any((t) {
            final s = (t.status).toString().toLowerCase();
            return s == 'final_approved' || s == 'client_approved';
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
    try {
      // Allow submissions only in 4th week of the month
      // final now = DateTime.now();
      // if (!_isFourthWeekNow(now)) {
      //   Get.defaultDialog(
      //     title: 'Create Timesheet',
      //     content: const Padding(
      //       padding: EdgeInsets.all(8.0),
      //       child: Text(
      //         'Timesheet submissions are only available during the 4th week of each month.',
      //         textAlign: TextAlign.center,
      //       ),
      //     ),
      //     textConfirm: 'Close',
      //     onConfirm: () => Get.back(),
      //   );
      //   return;
      // } 
      
      final profile = Get.find<ProfileController>(tag: null);
      final expertId = profile.preferences.value.userId ?? 0;
      print("expertId: $expertId");
      if (expertId == 0) {
        Get.snackbar('Profile', 'Expert ID not found. Please relogin.');
        return;
      }
      // Show a quick loading indicator while fetching existing timesheets
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      // Fetch existing timesheets
      final existing = await _usecase.getTimesheets(projectId, expertId);
      if (Get.isDialogOpen == true) Get.back();
      // Open bottom sheet with existing data
      Get.bottomSheet(
        TimesheetBottomSheet(
          projectId: projectId,
          projectName: projectName,
          existingTimesheets: existing,
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      // Show rule message on failure too
      Get.defaultDialog(
        title: 'Create Timesheet',
        content: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Timesheet submissions are only available during the 4th week of each month.',
            textAlign: TextAlign.center,
          ),
        ),
        textConfirm: 'Close',
        onConfirm: () => Get.back(),
      );
    }
  }
}
