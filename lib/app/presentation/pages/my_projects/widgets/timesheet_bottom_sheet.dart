
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/repositories/file_repository_impl.dart';
import 'package:mavx_flutter/app/domain/usecases/my_project_usecase.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class TimesheetBottomSheet extends StatefulWidget {
  final int projectId;
  final String projectName;

  const TimesheetBottomSheet({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<TimesheetBottomSheet> createState() => _TimesheetBottomSheetState();
}

class _TimesheetBottomSheetState extends State<TimesheetBottomSheet>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  // Manual form controllers
  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _taskCtrl = TextEditingController();
  final TextEditingController _startCtrl = TextEditingController();
  final TextEditingController _endCtrl = TextEditingController();
  final TextEditingController _hoursCtrl = TextEditingController();
  final TextEditingController _rateCtrl = TextEditingController();
  final TextEditingController _amountCtrl = TextEditingController();

  // Upload tab
  String? _pickedFilePath;
  String? _uploadedUrl;
  bool _uploading = false;

  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Listen to tab changes and clear form data
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _clearFormData();
      }
    });
    
    // Default date today
    final now = DateTime.now();
    _dateCtrl.text = _yyyyMmDd(now);
    _recalc();
  }

  void _clearFormData() {
    // Clear time and calculation fields when switching tabs
    _startCtrl.clear();
    _endCtrl.clear();
    _hoursCtrl.clear();
    _rateCtrl.clear();
    _amountCtrl.clear();
    _taskCtrl.clear();
    
    // Reset upload state
    _pickedFilePath = null;
    _uploadedUrl = null;
    _uploading = false;
    
    // Keep the date as it's common for both tabs
    final now = DateTime.now();
    _dateCtrl.text = _yyyyMmDd(now);
    
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dateCtrl.dispose();
    _taskCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    _hoursCtrl.dispose();
    _rateCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  String _yyyyMmDd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _recalc() {
    DateTime? parseTime(String t) {
      if (t.isEmpty) return null;
      final parts = t.split(':');
      if (parts.length < 3) return null;
      final h = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final s = int.tryParse(parts[2]);
      if (h == null || m == null || s == null || h < 0 || h > 23 || m < 0 || m > 59 || s < 0 || s > 59) return null;
      return DateTime(2024, 1, 1, h, m, s);
    }

    final startTime = parseTime(_startCtrl.text.trim());
    final endTime = parseTime(_endCtrl.text.trim());
    final rate = double.tryParse(_rateCtrl.text.trim());
    
    if (startTime != null && endTime != null) {
      // Calculate duration in seconds
      Duration duration;
      if (endTime.isAfter(startTime)) {
        duration = endTime.difference(startTime);
      } else {
        // Handle overnight shifts (end time next day)
        final nextDayEnd = endTime.add(const Duration(days: 1));
        duration = nextDayEnd.difference(startTime);
      }
      
      final hours = duration.inSeconds / 3600.0;
      _hoursCtrl.text = hours.toStringAsFixed(2);
      
      if (rate != null && rate > 0) {
        _amountCtrl.text = (hours * rate).toStringAsFixed(2);
      }
    }
    setState(() {});
  }

  Future<void> _pickTime(TextEditingController controller, String label) async {
    final currentTime = TimeOfDay.now();
    TimeOfDay? initialTime = currentTime;
    
    // Parse existing time if available (HH:MM:SS format)
    if (controller.text.isNotEmpty) {
      final parts = controller.text.split(':');
      if (parts.length >= 2) {
        final h = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        if (h != null && m != null && h >= 0 && h <= 23 && m >= 0 && m <= 59) {
          initialTime = TimeOfDay(hour: h, minute: m);
        }
      }
    }
    
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      // Format as HH:MM:SS (defaulting seconds to 00)
      controller.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00';
      _recalc();
    }
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _pickedFilePath = result.files.single.path!;
      });
    }
  }

  Future<void> _uploadPdf() async {
    if (_pickedFilePath == null) return;
    setState(() => _uploading = true);
    try {
      final repo = FileRepositoryImpl();
      final url = await repo.uploadFile(
        fieldName: 'file',
        filePath: _pickedFilePath!,
      );
      setState(() => _uploadedUrl = url);
      Get.snackbar(
        'Upload',
        'PDF uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Upload Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _uploading = false);
    }
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      final profile = Get.find<ProfileController>(tag: null);
      final expertId = profile.registeredProfile.value.id ?? 0;
      if (expertId == 0) {
        Get.snackbar(
          'Profile',
          'Expert ID not found. Please relogin.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final payload = <String, dynamic>{
        'expertId': expertId,
        'projectId': widget.projectId,
        'projectName': widget.projectName,
        'workDate': _dateCtrl.text.trim(),
        // Tab index 0 = Upload PDF, 1 = Manual
        'taskDescription': _tabController.index == 1
            ? (_taskCtrl.text.trim().isNotEmpty
                  ? _taskCtrl.text.trim()
                  : 'Work log')
            : (_uploadedUrl != null
                  ? 'Timesheet PDF: $_uploadedUrl'
                  : 'Timesheet PDF attached'),
        'startTime': _startCtrl.text.trim(),
        'endTime': _endCtrl.text.trim(),
        'totalHours': double.tryParse(_hoursCtrl.text.trim()) ?? 0,
        'hourlyRate': double.tryParse(_rateCtrl.text.trim()) ?? 0,
        'amount': double.tryParse(_amountCtrl.text.trim()) ?? 0,
      };

      // If upload tab (index 0), include documentUrl for backend that supports it
      if (_tabController.index == 0 && _uploadedUrl != null) {
        payload['documentUrl'] = _uploadedUrl;
      }

      final usecase = Get.find<MyProjectUsecase>();
      final ok = await usecase.createProjectSchedule(payload);
      if (ok) {
        Get.back();
        Get.snackbar(
          'Timesheet',
          'Saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Timesheet',
          'Save failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Timesheet',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6E9EF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: const Color(0xFF0B2944),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const CommonText(
                  'Timesheet Entry',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0B2944),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6FA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close, size: 20),
                    color: const Color(0xFF0B2944),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFD),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE6E9EF)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.work_outline_rounded,
                    color: const Color(0xFF0B2944),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CommonText(
                      widget.projectName,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0B2944),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: const Color(0xFF0B2944),
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorPadding: const EdgeInsets.all(4),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF0B2944),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  SizedBox(width: 160, child: Tab(text: 'Upload PDF')),
                  SizedBox(width: 160, child: Tab(text: 'Manual')),
                ],  
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 360,
              child: TabBarView(
                controller: _tabController,
                children: [_uploadForm(context), _manualForm(context)],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: width,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0B2944), Color(0xFF1A3A5C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF0B2944).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_submitting) ...[
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ] else ...[
                      const Icon(Icons.save_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    CommonText(
                      _submitting ? 'Saving Timesheet...' : 'Save Timesheet',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _manualForm(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    InputDecoration deco(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE6E9EF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE6E9EF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0B2944), width: 1.6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _dateCtrl,
                  decoration: deco('Work Date (YYYY-MM-DD)'),
                  readOnly: true,
                  onTap: () async {
                    final now = DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(now.year - 1),
                      lastDate: DateTime(now.year + 1),
                    );
                    if (picked != null) {
                      _dateCtrl.text = _yyyyMmDd(picked);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _taskCtrl,
            decoration: deco('Task Description'),
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _startCtrl,
                  decoration: deco('Start Time').copyWith(
                    prefixIcon: const Icon(Icons.access_time, size: 20),
                  ),
                  readOnly: true,
                  onTap: () => _pickTime(_startCtrl, 'Start Time'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _endCtrl,
                  decoration: deco('End Time').copyWith(
                    prefixIcon: const Icon(Icons.access_time_filled, size: 20),
                  ),
                  readOnly: true,
                  onTap: () => _pickTime(_endCtrl, 'End Time'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hoursCtrl,
                  decoration: deco('Total Hours').copyWith(
                    prefixIcon: const Icon(Icons.schedule, size: 20),
                  ),
                  readOnly: true,
                  style: const TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _rateCtrl,
                  decoration: deco('Hourly Rate').copyWith(
                    prefixIcon: const Icon(Icons.attach_money, size: 20),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => _recalc(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountCtrl,
                  decoration: deco('Total Amount').copyWith(
                    prefixIcon: const Icon(Icons.payments, size: 20),
                  ),
                  readOnly: true,
                  style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _uploadForm(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Column(
      children: [  
        Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFD),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE6E9EF)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: InkWell(
            onTap: _uploading
                ? null
                : (_pickedFilePath == null ? _pickPdf : _uploadPdf),
            child: Center(
              child: _uploading
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(strokeWidth: 2),
                        SizedBox(height: 8),
                        CommonText(
                          'Uploading...',
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _uploadedUrl != null
                              ? Icons.check_circle
                              : Icons.picture_as_pdf,
                          size: 36,
                          color: Colors.black45,
                        ),
                        const SizedBox(height: 8),
                        CommonText(
                          _uploadedUrl != null
                              ? 'Uploaded successfully'
                              : (_pickedFilePath != null
                                    ? 'Tap to upload PDF'
                                    : 'Tap to pick a PDF'),
                          color: Colors.black54,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
            ),
          ),
        ), 
         
      ],
    );
  }
}
