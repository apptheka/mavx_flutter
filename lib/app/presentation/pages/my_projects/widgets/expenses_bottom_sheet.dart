import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/data/models/expense_model.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ExpensesBottomSheet extends StatefulWidget {
  const ExpensesBottomSheet({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.existingExpenses,
  });

  final int projectId;
  final String projectName;
  final List<Expense> existingExpenses;

  @override
  State<ExpensesBottomSheet> createState() => _ExpensesBottomSheetState();
}

class _ExpensesBottomSheetState extends State<ExpensesBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // One entry = a set of controllers for a single expense
  late List<_ExpenseEntry> _entries;

  double _computeTotal() {
    double sum = 0.0;
    for (final e in _entries) {
      final t = e.amountCtrl.text.trim();
      final v = double.tryParse(t.replaceAll(',', ''));
      if (v != null) sum += v;
    }
    return sum;
  }

  @override
  void initState() {
    super.initState();
    // Seed entries from existing expenses, or one empty row
    _entries = (widget.existingExpenses.isNotEmpty)
        ? widget.existingExpenses
              .map((e) => _ExpenseEntry.fromExpense(e))
              .toList()
        : [_ExpenseEntry.empty()];
  }

  @override
  void dispose() {
    for (final e in _entries) {
      e.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight = media.size.height * 0.9;

    return Material(
      color: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          height: maxHeight,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText(
                            'Add Expenses · ${widget.projectName}',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                          const SizedBox(height: 6),
                          const CommonText(
                            'Log your expenses for this project',
                            color: AppColors.textSecondaryColor,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < _entries.length; i++) ...[
                            _ExpenseSection(
                              index: i,
                              entry: _entries[i],
                              onAmountChanged: () => setState(() {}),
                            ),
                            const SizedBox(height: 16),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [ 
                              OutlinedButton.icon(
                                onPressed: () {
                                  final now = DateTime.now();
                                  final d =
                                      '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
                                  setState(() {
                                    final newEntry = _ExpenseEntry.empty();
                                    newEntry.dateCtrl.text = d;
                                    _entries.add(newEntry);
                                  });
                                },
                                icon: const Icon(Icons.add),
                                label: const CommonText(
                                  'Add Expense',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: CommonText(
                        'Total: ₹ ${_computeTotal().toStringAsFixed(2)}',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 160,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState?.validate() != true) return;
                          final payloads = _entries
                              .map((e) => e.toPayload())
                              .toList();
                          Navigator.of(context).maybePop(payloads);
                        },
                        child: const CommonText(
                          'Submit',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExpenseEntry {
  final int? id;
  final TextEditingController dateCtrl;
  final TextEditingController categoryCtrl;
  final TextEditingController descriptionCtrl;
  final TextEditingController amountCtrl;

  _ExpenseEntry({
    this.id,
    required this.dateCtrl,
    required this.categoryCtrl,
    required this.descriptionCtrl,
    required this.amountCtrl,
  });

  factory _ExpenseEntry.empty() => _ExpenseEntry(
    dateCtrl: TextEditingController(),
    categoryCtrl: TextEditingController(),
    descriptionCtrl: TextEditingController(),
    amountCtrl: TextEditingController(),
  );

  factory _ExpenseEntry.fromExpense(Expense e) => _ExpenseEntry(
    id: e.id,
    dateCtrl: TextEditingController(text: e.date),
    categoryCtrl: TextEditingController(text: e.category),
    descriptionCtrl: TextEditingController(text: e.description),
    amountCtrl: TextEditingController(text: e.amount),
  );

  Map<String, dynamic> toPayload() {
    final map = <String, dynamic>{
      'date': dateCtrl.text.trim(),
      'category': categoryCtrl.text.trim(),
      'description': descriptionCtrl.text.trim(),
      'amount': amountCtrl.text.trim(),
    };
    if (id != null && id! > 0) map['id'] = id;
    return map;
  }

  void dispose() {
    dateCtrl.dispose();
    categoryCtrl.dispose();
    descriptionCtrl.dispose();
    amountCtrl.dispose();
  }
}

class _ExpenseSection extends StatelessWidget {
  const _ExpenseSection({required this.index, required this.entry, this.onAmountChanged});

  final int index;
  final _ExpenseEntry entry;
  final VoidCallback? onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Expense #${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: entry.dateCtrl,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: (entry.categoryCtrl.text.isEmpty)
                    ? null
                    : entry.categoryCtrl.text.toLowerCase(),
                items: const [
                  DropdownMenuItem(
                    value: 'travel',
                    child: Text(
                      'Travel',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'accommodation',
                    child: Text(
                      'Accommodation',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'medical',
                    child: Text(
                      'Medical',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'food',
                    child: Text(
                      'Food',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'stationary',
                    child: Text(
                      'Stationary',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'subscription',
                    child: Text(
                      'Subscription',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'miscellaneous',
                    child: Text(
                      'Miscellaneous',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                selectedItemBuilder: (context) {
                  const labels = [
                    'Travel',
                    'Accommodation',
                    'Medical',
                    'Food',
                    'Stationary',
                    'Subscription',
                    'Miscellaneous',
                  ];
                  return labels
                      .map(
                        (label) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      )
                      .toList();
                },
                onChanged: (val) {
                  entry.categoryCtrl.text = val ?? '';
                },
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: entry.descriptionCtrl,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          minLines: 3,
          maxLines: 4,
          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: entry.amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Amount (INR)',
            border: OutlineInputBorder(),
          ),
          onChanged: (_) => onAmountChanged?.call(),
          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
        ),
      ],
    );
  }
}
