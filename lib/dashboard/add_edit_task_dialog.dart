import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/utils/toast_utils.dart';
import 'package:task_manager/utils/validators.dart';
import '../app/theme.dart';
import '../providers/task_provider.dart';
import 'task_model.dart';

class AddEditTaskDialog extends ConsumerStatefulWidget {
  final Task? task; // null for add, non-null for edit

  const AddEditTaskDialog({super.key, this.task});

  @override
  ConsumerState<AddEditTaskDialog> createState() => _AddEditTaskDialogState();
}

class _AddEditTaskDialogState extends ConsumerState<AddEditTaskDialog> {
  late TextEditingController _controller;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task?.title ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final validation = Validators.validateTaskTitle(_controller.text);
    if (validation != null) {
      ToastUtils.showError(context, validation);
      return;
    }

    setState(() => _loading = true);

    try {
      final taskOps = ref.read(taskOperationsProvider);

      if (widget.task == null) {
        // Add new task
        await taskOps.addTask(_controller.text);
        if (mounted) {
          Navigator.of(context).pop();
          ToastUtils.showSuccess(context, 'Task added successfully!');
        }
      } else {
        // Edit existing task
        await taskOps.editTask(widget.task!.id, _controller.text);
        if (mounted) {
          Navigator.of(context).pop();
          ToastUtils.showSuccess(context, 'Task updated successfully!');
        }
      }
    }  catch (e) {
      if (mounted) {
        ToastUtils.showError(context, 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkBackground : AppTheme.textWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              widget.task == null ? 'Add Task' : 'Edit Task',
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 24),

            // Task input field
            TextField(
              controller: _controller,
              autofocus: true,
              maxLines: 3,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Enter task title...',
                filled: true,
                fillColor: isDark ? AppTheme.inputFieldBg : AppTheme.lightBg3,
              ),
              onSubmitted: (_) => _submit(),
            ),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _loading ? null : () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark ? AppTheme.textLightGray : const Color(0xFFCCCCCC),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.pureBlack),
                      ),
                    )
                        : Text(widget.task == null ? 'Add' : 'Update'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showAddEditTaskDialog(BuildContext context, {Task? task}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AddEditTaskDialog(task: task),
  );
}
