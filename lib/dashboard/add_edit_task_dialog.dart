import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/utils/toast_utils.dart';
import 'package:task_manager/utils/validators.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
            ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.2, end: 0),
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
            ).animate().fadeIn(delay: 100.ms, duration: 300.ms).slideY(begin: 0.1, end: 0),

            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: _AnimatedButton(
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
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _AnimatedButton(
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
                ),
              ],
            ).animate().fadeIn(delay: 200.ms, duration: 300.ms).slideY(begin: 0.2, end: 0),
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
    transitionAnimationController: AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 400),
    ),
    builder: (context) => AddEditTaskDialog(task: task),
  );
}

// Animated Button Wrapper
class _AnimatedButton extends StatefulWidget {
  final Widget child;

  const _AnimatedButton({required this.child});

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _isPressed = true),
      onPointerUp: (_) => setState(() => _isPressed = false),
      onPointerCancel: (_) => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: widget.child,
      ),
    );
  }
}
