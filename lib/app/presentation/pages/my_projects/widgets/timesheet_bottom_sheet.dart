import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/timesheet_model.dart';
import 'package:mavx_flutter/app/presentation/pages/my_projects/my_projects_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

// Controller group for a single timesheet entry form
 
class TimesheetBottomSheet extends StatefulWidget {
  final int projectId;
  final String projectName;
  final List<Timesheet> existingTimesheets;

  const TimesheetBottomSheet({
    super.key,
    required this.projectId,
    required this.projectName,
    this.existingTimesheets = const [],
  });

  @override
  State<TimesheetBottomSheet> createState() => _TimesheetBottomSheetState();
}

class _TimesheetBottomSheetState extends State<TimesheetBottomSheet> {
  final List<MyProjectsController> _entries = [];
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    // Prefill all entries; if none, add one empty entry
    if (widget.existingTimesheets.isNotEmpty) {
      for (final t in widget.existingTimesheets) {
        final c = MyProjectsController();
        c.timesheetId = t.id; // carry existing id for upsert
        c.date.text = t.workDate;
        c.task.text = t.taskDescription;
        c.start.text = t.startTime;
        c.end.text = t.endTime;
        c.hours.text = t.totalHours;
        c.rate.text = t.hourlyRate;
        c.amount.text = t.amount;
        _attachListeners(c);
        _entries.add(c);
        _recalcEntry(c);
      }
    } else {
      _addEmptyEntry();
    }
  }

  @override
  void dispose() {
    for (final e in _entries) {
      e.dispose();
    }
    super.dispose();
  }

  String _yyyyMmDd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

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
      // Find entry belonging to this controller and recalc
      for (final c in _entries) {
        if (controller == c.start || controller == c.end) {
          _recalcEntry(c);
          break;
        }
      }
    }
  }

  void _addEmptyEntry() {
    final now = DateTime.now();
    final c = MyProjectsController();
    c.date.text = _yyyyMmDd(now);
    _attachListeners(c);
    _entries.add(c);
    setState(() {});
  }

  void _recalcEntry(MyProjectsController c) {
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
    final startTime = parseTime(c.start.text.trim());
    final endTime = parseTime(c.end.text.trim());
    final rate = double.tryParse(c.rate.text.trim());
    if (startTime != null && endTime != null) {
      Duration duration;
      if (endTime.isAfter(startTime)) {
        duration = endTime.difference(startTime);
      } else {
        final nextDayEnd = endTime.add(const Duration(days: 1));
        duration = nextDayEnd.difference(startTime);
      }
      final hours = duration.inSeconds / 3600.0;
      c.hours.text = hours.toStringAsFixed(2);
      if (rate != null && rate > 0) {
        c.amount.text = (hours * rate).toStringAsFixed(2);
      }
    }
    setState(() {});
  }

  void _attachListeners(MyProjectsController c) {
    c.start.addListener(() => _recalcEntry(c));
    c.end.addListener(() => _recalcEntry(c));
    c.rate.addListener(() => _recalcEntry(c));
  }

  Future<void> _submit() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      // Prepare entries payloads for controller
      final entries = _entries.map((c) => {
            'id': c.timesheetId,
            'workDate': c.date.text.trim(),
            'taskDescription': c.task.text.trim().isNotEmpty ? c.task.text.trim() : 'Work log',
            'startTime': c.start.text.trim(),
            'endTime': c.end.text.trim(),
            'totalHours': double.tryParse(c.hours.text.trim()) ?? 0,
            'hourlyRate': double.tryParse(c.rate.text.trim()) ?? 0,
            'amount': double.tryParse(c.amount.text.trim()) ?? 0,
          }).toList();

      final ctrl = Get.find<MyProjectsController>();
      final success = await ctrl.saveTimesheetEntries(
        projectId: widget.projectId,
        projectName: widget.projectName,
        entries: entries,
      );
      if (success > 0) {
        Get.back();
        Get.snackbar(
          'Timesheet',
          'Saved ${success}/${_entries.length} entries',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Timesheet',
          'Save failed for all entries',
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
      child: SizedBox(
        height: 600,
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
            // All entry forms
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _entries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
                        child: CommonText(
                          'Timesheet ${index + 1}',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0B2944),
                        ),
                      ),
                      _manualForm(context, _entries[index]),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: _addEmptyEntry,
                icon: const Icon(Icons.add),
                label: const Text('Add Entry'),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
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

  Widget _manualForm(BuildContext context, MyProjectsController ctrls) {
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
                  controller: ctrls.date,
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
                      ctrls.date.text = _yyyyMmDd(picked);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: ctrls.task,
            decoration: deco('Task Description'),
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ctrls.start,
                  decoration: deco('Start Time').copyWith(
                    prefixIcon: const Icon(Icons.access_time, size: 20),
                  ),
                  readOnly: true,
                  onTap: () => _pickTime(ctrls.start, 'Start Time'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: ctrls.end,
                  decoration: deco('End Time').copyWith(
                    prefixIcon: const Icon(Icons.access_time_filled, size: 20),
                  ),
                  readOnly: true,
                  onTap: () => _pickTime(ctrls.end, 'End Time'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ctrls.hours,
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
                  controller: ctrls.rate,
                  decoration: deco('Hourly Rate').copyWith(
                    prefixIcon: const Icon(Icons.attach_money, size: 20),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => _recalcEntry(ctrls),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ctrls.amount,
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

  // upload form removed per request
}
