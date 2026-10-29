import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/icons/app_svg_icons.dart';
import '../data/models/models.dart';
import 'priority_badge.dart';
import 'status_badge.dart';

class CreateTaskSheet extends StatefulWidget {
  final Function({
    required String title,
    String? description,
    String? status,
    String? priority,
    String? projectId,
    List<String>? labels,
  }) onCreate;

  const CreateTaskSheet({super.key, required this.onCreate});

  @override
  State<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<CreateTaskSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  TaskStatusEnum _selectedStatus = TaskStatusEnum.todo;
  TaskPriorityEnum _selectedPriority = TaskPriorityEnum.high;
  final List<String> _selectedLabels = ['Feature'];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    widget.onCreate(
      title: title,
      description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      status: _selectedStatus.apiKey,
      priority: _selectedPriority.apiKey,
      labels: _selectedLabels,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface1,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
        border: Border(
          top: BorderSide(color: AppColors.borderDefault, width: 1),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surface4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Text(
                'New Issue',
                style: AppTheme.headlineSm.copyWith(fontSize: 18),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const AppSvg(
                  AppSvgIcons.close,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Issue Title Input
          TextField(
            controller: _titleController,
            autofocus: true,
            style: AppTheme.bodyLg.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: 'Issue title',
              hintStyle: AppTheme.bodyLg.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.surface2,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                borderSide: const BorderSide(color: AppColors.borderDefault),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                borderSide: const BorderSide(color: AppColors.borderDefault),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                borderSide: const BorderSide(color: AppColors.primaryHover),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Description Input
          TextField(
            controller: _descController,
            maxLines: 3,
            style: AppTheme.bodyMd.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Add description (Markdown supported)...',
              hintStyle: AppTheme.bodyMd.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.surface2,
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                borderSide: const BorderSide(color: AppColors.borderDefault),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                borderSide: const BorderSide(color: AppColors.borderDefault),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                borderSide: const BorderSide(color: AppColors.primaryHover),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Triage Selector Row (Status & Priority)
          Row(
            children: [
              PopupMenuButton<TaskStatusEnum>(
                initialValue: _selectedStatus,
                color: AppColors.surface2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                  side: const BorderSide(color: AppColors.borderDefault),
                ),
                onSelected: (val) => setState(() => _selectedStatus = val),
                itemBuilder: (context) => TaskStatusEnum.values.map((s) {
                  return PopupMenuItem(
                    value: s,
                    child: Row(
                      children: [
                        AppSvg(s.svgIcon, size: 16, color: s.color),
                        const SizedBox(width: 8),
                        Text(s.label, style: AppTheme.bodyMd),
                      ],
                    ),
                  );
                }).toList(),
                child: StatusBadge(
                  status: _selectedStatus,
                  showDropdownArrow: true,
                ),
              ),
              const SizedBox(width: 10),

              PopupMenuButton<TaskPriorityEnum>(
                initialValue: _selectedPriority,
                color: AppColors.surface2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                  side: const BorderSide(color: AppColors.borderDefault),
                ),
                onSelected: (val) => setState(() => _selectedPriority = val),
                itemBuilder: (context) => TaskPriorityEnum.values.map((p) {
                  return PopupMenuItem(
                    value: p,
                    child: Row(
                      children: [
                        AppSvg(p.svgIcon, size: 16, color: p.color),
                        const SizedBox(width: 8),
                        Text(p.label, style: AppTheme.bodyMd),
                      ],
                    ),
                  );
                }).toList(),
                child: PriorityBadge(
                  priority: _selectedPriority,
                ),
              ),
              const Spacer(),

              // Submit Button
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusDefault),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppSvg(AppSvgIcons.plus, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'Create Issue',
                      style: AppTheme.labelAction.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
