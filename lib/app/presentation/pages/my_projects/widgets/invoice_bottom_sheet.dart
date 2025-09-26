import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/my_projects/my_projects_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class InvoiceBottomSheet extends StatefulWidget {
  final int projectId;
  final String projectName;
  const InvoiceBottomSheet({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<InvoiceBottomSheet> createState() => _InvoiceBottomSheetState();
}

class _InvoiceBottomSheetState extends State<InvoiceBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final invoiceNumber = TextEditingController();
  final invoiceDate = TextEditingController();
  final dueDate = TextEditingController();
  final consultantName = TextEditingController();
  final consultantAddress = TextEditingController();
  final consultantPhone = TextEditingController();
  final consultantEmail = TextEditingController();
  final serviceDescription = TextEditingController();
  final hoursWorked = TextEditingController();
  final hourlyRate = TextEditingController();
  final subtotal = TextEditingController();
  final discount = TextEditingController();
  final tax = TextEditingController();
  final totalAmount = TextEditingController();
  final paymentTerms = TextEditingController();
  final bankDetails = TextEditingController();
  final upi = TextEditingController();

  String? filePath;
  bool attachFile = true;
  bool submitting = false;
  final RegExp _emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[A-Za-z]{2,}$'); 

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    invoiceDate.text = _fmtDate(today);
    _attachListeners();
  }

  @override
  void dispose() {
    for (final c in [
      invoiceNumber,
      invoiceDate,
      dueDate,
      consultantName,
      consultantAddress,
      consultantPhone,
      consultantEmail,
      serviceDescription,
      hoursWorked,
      hourlyRate,
      subtotal,
      discount,
      tax,
      totalAmount,
      paymentTerms,
      bankDetails,
      upi,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _attachListeners() {
    hoursWorked.addListener(_recalc);
    hourlyRate.addListener(_recalc);
    discount.addListener(_recalc);
    tax.addListener(_recalc);
  }

  String _fmtDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate(TextEditingController target) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) target.text = _fmtDate(picked);
  }

  void _recalc() {
    final h = double.tryParse(hoursWorked.text.trim()) ?? 0;
    final r = double.tryParse(hourlyRate.text.trim()) ?? 0;
    final base = h * r;
    subtotal.text = base.toStringAsFixed(2);
    final disc = double.tryParse(discount.text.trim()) ?? 0;
    final tx = double.tryParse(tax.text.trim()) ?? 0;
    final total = base - disc + tx;
    totalAmount.text = total.toStringAsFixed(2);
    setState(() {});
  }

  InputDecoration _deco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: Colors.black45,
      fontWeight: FontWeight.w600,
    ),
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

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      filePath = result.files.single.path!;
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (submitting) return;
    // If user has not filled any field (except the auto-filled invoice date), prompt to fill the form
    final controllers = [
      invoiceNumber,
      dueDate,
      consultantName,
      consultantAddress,
      consultantPhone,
      consultantEmail,
      serviceDescription,
      hoursWorked,
      hourlyRate,
      subtotal,
      discount,
      tax,
      totalAmount,
      paymentTerms,
      bankDetails,
      upi,
    ];
    final hasAnyInput = controllers.any((c) => c.text.trim().isNotEmpty);
    if (!hasAnyInput) {
      Get.snackbar('Invoice', 'Please fill in the form before submitting');
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (attachFile && (filePath == null || !File(filePath!).existsSync())) {
      Get.snackbar('Invoice', 'Please select a PDF file');
      return;
    }
    submitting = true;
    setState(() {});
    try {
      final ctrl = Get.find<MyProjectsController>();
      final fields = <String, String>{
        'projectId': widget.projectId.toString(),
        'invoiceNumber': invoiceNumber.text.trim(),
        'invoiceDate': invoiceDate.text.trim(),
        'dueDate': dueDate.text.trim(),
        'consultantName': consultantName.text.trim(),
        'consultantAddress': consultantAddress.text.trim(),
        'consultantPhone': consultantPhone.text.trim(),
        'consultantEmail': consultantEmail.text.trim(),
        'serviceDescription': serviceDescription.text.trim(),
        'hoursWorked': (double.tryParse(hoursWorked.text.trim()) ?? 0)
            .toString(),
        'hourlyRate': (double.tryParse(hourlyRate.text.trim()) ?? 0).toString(),
        'subtotal': (double.tryParse(subtotal.text.trim()) ?? 0).toString(),
        'discount': (double.tryParse(discount.text.trim()) ?? 0).toString(),
        'tax': (double.tryParse(tax.text.trim()) ?? 0).toString(),
        'totalAmount': (double.tryParse(totalAmount.text.trim()) ?? 0)
            .toString(),
        'paymentTerms': paymentTerms.text.trim(),
        'bankDetails': bankDetails.text.trim(),
        'upi': upi.text.trim(),
      };
      final ok = await ctrl.uploadInvoice(fields: fields, filePath: filePath);
      if (ok) {
        Get.back();
        await ctrl.fetchData();
        Get.snackbar(
          'Invoice',
          'Invoice submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Invoice',
          'Failed to submit invoice',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Invoice',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      submitting = false;
      setState(() {});
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                    const CommonText(
                      'Create Invoice',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0B2944),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // First row: Invoice Number and Date
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: invoiceNumber,
                        decoration: _deco('Invoice Number *'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: invoiceDate,
                        readOnly: true,
                        onTap: () => _pickDate(invoiceDate),
                        decoration: _deco('Date *').copyWith(
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Due Date and Consultant Name
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: dueDate,
                        readOnly: true,
                        onTap: () => _pickDate(dueDate),
                        decoration: _deco('Due Date').copyWith(
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: consultantName,
                        decoration: _deco('Consultant Name'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Address
                TextFormField(
                  controller: consultantAddress,
                  decoration: _deco('Consultant Address'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                // Phone and Email
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: consultantPhone,
                        decoration: _deco(
                          'Consultant Phone',
                        ).copyWith(counterText: ''),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) {
                          final t = v?.trim() ?? '';
                          if (t.isEmpty) return 'Phone is required';
                          final phoneRegex = RegExp(r'^\d{10}$');
                          if (!phoneRegex.hasMatch(t))
                            return 'Enter a valid phone number';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: consultantEmail,
                        decoration: _deco('Consultant Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          final t = v?.trim() ?? '';
                          if (t.isEmpty) return 'Email is required';
                          if (!_emailRegex.hasMatch(t))
                            return 'Enter a valid email';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Description
                TextFormField(
                  controller: serviceDescription,
                  maxLines: 3,
                  decoration: _deco('Descriptions of Services'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                // Hours and Rate
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: hoursWorked,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _deco('Hours Worked'),
                        validator: (v) {
                          final t = v?.trim() ?? '';
                          if (t.isEmpty) return 'Required';
                          if (double.tryParse(t) == null)
                            return 'Enter a number';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: hourlyRate,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _deco('Hourly Rate'),
                        validator: (v) {
                          final t = v?.trim() ?? '';
                          if (t.isEmpty) return 'Required';
                          if (double.tryParse(t) == null)
                            return 'Enter a number';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Subtotal and Total Amount
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: subtotal,
                        readOnly: true,
                        decoration: _deco('Subtotal'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: totalAmount,
                        readOnly: true,
                        decoration: _deco('Total Amount'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Taxes and Total (we already show totalAmount; keeping optional tax field)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: tax,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _deco('Taxes (optional)'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: discount,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _deco('Total Tax Amount'),
                        validator: (v) {
                          final t = v?.trim() ?? '';
                          if (t.isEmpty) return 'Required';
                          if (double.tryParse(t) == null)
                            return 'Enter a number';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: paymentTerms,
                  decoration: _deco('Payment Terms'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: bankDetails,
                  maxLines: 2,
                  decoration: _deco('Bank Details'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: upi,
                  decoration: _deco('UPI / Other'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: attachFile,
                      onChanged: (v) {
                        setState(() {
                          attachFile = v ?? true;
                          if (!attachFile) filePath = null;
                        });
                      },
                    ),
                    const CommonText('Attach Invoice File'),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: attachFile ? _pickFile : null,
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload'),
                    ),
                  ],
                ),
                if (filePath != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonText(
                      File(filePath!).path.split('/').last,
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: width,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B2944),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: CommonText(
                      submitting ? 'Submitting...' : 'Submit Invoice',
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
