import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/icons/app_svg_icons.dart';
import '../data/models/models.dart';
import '../data/services/api_service.dart';

class CommandPaletteModal extends StatefulWidget {
  final Function(String query) onSearchIssues;
  final VoidCallback onCreateIssue;
  final VoidCallback onFilterAssigned;
  final Function(String taskId)? onOpenTask;

  const CommandPaletteModal({
    super.key,
    required this.onSearchIssues,
    required this.onCreateIssue,
    required this.onFilterAssigned,
    this.onOpenTask,
  });

  @override
  State<CommandPaletteModal> createState() => _CommandPaletteModalState();
}

class _CommandPaletteModalState extends State<CommandPaletteModal> {
  final TextEditingController _controller = TextEditingController();
  final ApiService _apiService = ApiService();

  List<TaskModel> _liveTasks = [];
  bool _isSearching = false;

  final List<Map<String, dynamic>> _quickCommands = [
    {
      'title': 'Create new issue',
      'shortcut': 'C',
      'icon': AppSvgIcons.plus,
      'color': AppColors.primaryHover,
      'action': 'create',
    },
    {
      'title': 'Filter assigned to me',
      'shortcut': 'A',
      'icon': AppSvgIcons.navTasks,
      'color': AppColors.priorityHigh,
      'action': 'assigned',
    },
    {
      'title': 'View unread notifications',
      'shortcut': 'I',
      'icon': AppSvgIcons.bell,
      'color': AppColors.primaryLight,
      'action': 'inbox',
    },
    {
      'title': 'Cycle sprint view',
      'shortcut': 'S',
      'icon': AppSvgIcons.sync,
      'color': AppColors.priorityMedium,
      'action': 'sprint',
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) async {
    widget.onSearchIssues(query);

    if (query.trim().isEmpty) {
      setState(() {
        _liveTasks = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    try {
      final results = await _apiService.searchMobile(query.trim());
      if (mounted) {
        setState(() {
          _liveTasks = results.tasks;
          _isSearching = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 520),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(color: AppColors.borderDefault),
          boxShadow: const [
            BoxShadow(
              color: Color(0xCC000000),
              blurRadius: 32,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  const AppSvg(
                    AppSvgIcons.search,
                    size: 18,
                    color: AppColors.primaryHover,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      onChanged: _onQueryChanged,
                      style: AppTheme.bodyMd.copyWith(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Type a command or search issues...',
                        hintStyle: AppTheme.bodyMd.copyWith(color: AppColors.textMuted),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  if (_isSearching)
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryHover),
                    )
                  else
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const AppSvg(
                        AppSvgIcons.close,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.surface4),

            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  // Live Search Results
                  if (_liveTasks.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                      child: Text(
                        'MATCHING ISSUES',
                        style: AppTheme.labelMonoSm.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.1,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                    ..._liveTasks.map((t) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          widget.onOpenTask?.call(t.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Text(
                                t.identifier,
                                style: AppTheme.labelMonoSm.copyWith(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  t.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTheme.bodyMd.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const Divider(height: 12, color: AppColors.surface4),
                  ],

                  // Command section label
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                    child: Text(
                      'QUICK ACTIONS',
                      style: AppTheme.labelMonoSm.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),

                  // Quick commands list
                  ..._quickCommands.map((cmd) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (cmd['action'] == 'create') {
                          widget.onCreateIssue();
                        } else if (cmd['action'] == 'assigned') {
                          widget.onFilterAssigned();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            AppSvg(
                              cmd['icon'] as String,
                              size: 16,
                              color: cmd['color'] as Color,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                cmd['title'] as String,
                                style: AppTheme.bodyMd.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surface3,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppColors.borderDefault),
                              ),
                              child: Text(
                                cmd['shortcut'] as String,
                                style: AppTheme.labelMonoSm.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Footer tips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: AppColors.surface1,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppTheme.radiusLg)),
                border: Border(top: BorderSide(color: AppColors.borderDefault)),
              ),
              child: Row(
                children: [
                  Text(
                    'Search issues across workspace',
                    style: AppTheme.bodySm.copyWith(fontSize: 11, color: AppColors.textMuted),
                  ),
                  const Spacer(),
                  Text(
                    'ESC to close',
                    style: AppTheme.labelMonoSm.copyWith(fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
