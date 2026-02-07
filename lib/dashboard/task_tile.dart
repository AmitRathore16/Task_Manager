import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/task_provider.dart';
import 'package:task_manager/utils/toast_utils.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../app/theme.dart';
import 'task_model.dart';
import 'add_edit_task_dialog.dart';

class TaskTile extends ConsumerWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final taskOps = ref.read(taskOperationsProvider);

    return Dismissible(
      key: ValueKey(task.id), // IMPORTANT
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),

      /// Handle deletion safely BEFORE animation
      confirmDismiss: (direction) async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor:
            isDark ? AppTheme.darkBackground : AppTheme.textWhite,
            title: Text(
              'Delete Task',
              style: theme.textTheme.titleLarge,
            ),
            content: Text(
              'Are you sure you want to delete this task?',
              style: theme.textTheme.bodyLarge,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        );

        if (confirm == true) {
          try {
            await taskOps.deleteTask(task.id);

            if (context.mounted) {
              ToastUtils.showSuccess(context, 'Task deleted successfully');
            }

            return true; // allow animation
          } catch (e) {
            if (context.mounted) {
              ToastUtils.showError(context, 'Error deleting task: ${e.toString()}');
            }
            return false;
          }
        }

        return false;
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.inputFieldBgDark : AppTheme.lightBg2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppTheme.dividerColor : AppTheme.lightBg4,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            /// Animated Checkbox
            _AnimatedCheckbox(
              isCompleted: task.isCompleted,
              isDark: isDark,
              onTap: () async {
                try {
                  await taskOps.toggleTaskCompletion(task);
                  if (context.mounted) {
                    ToastUtils.showSuccess(
                      context,
                      task.isCompleted ? 'Task marked as pending' : 'Task completed!',
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ToastUtils.showError(context, 'Error: ${e.toString()}');
                  }
                }
              },
            ),

            const SizedBox(width: 12),

            /// Task Title
            Expanded(
              child: Text(
                task.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                  color: task.isCompleted
                      ? (isDark
                      ? AppTheme.textMutedGray
                      : const Color(0xFF999999))
                      : (isDark
                      ? AppTheme.textWhite
                      : AppTheme.pureBlack),
                ),
              ),
            ),

            /// Animated Edit Button
            _AnimatedEditButton(
              isDark: isDark,
              onPressed: () {
                showAddEditTaskDialog(context, task: task);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Animated Checkbox with completion animation
class _AnimatedCheckbox extends StatefulWidget {
  final bool isCompleted;
  final bool isDark;
  final VoidCallback onTap;

  const _AnimatedCheckbox({
    required this.isCompleted,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_AnimatedCheckbox> createState() => _AnimatedCheckboxState();
}

class _AnimatedCheckboxState extends State<_AnimatedCheckbox> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _checkController;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );
    if (widget.isCompleted) {
      _checkController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_AnimatedCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCompleted != widget.isCompleted) {
      if (widget.isCompleted) {
        _checkController.forward();
      } else {
        _checkController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(6),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: widget.isCompleted
                  ? AppTheme.secondaryGold
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: widget.isCompleted
                    ? AppTheme.secondaryGold
                    : (widget.isDark
                    ? AppTheme.textMutedGray
                    : const Color(0xFFCCCCCC)),
                width: 2,
              ),
            ),
            child: ScaleTransition(
              scale: _checkAnimation,
              child: widget.isCompleted
                  ? const Icon(
                Icons.check,
                size: 16,
                color: AppTheme.pureBlack,
              )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

// Animated Edit Button
class _AnimatedEditButton extends StatefulWidget {
  final bool isDark;
  final VoidCallback onPressed;

  const _AnimatedEditButton({
    required this.isDark,
    required this.onPressed,
  });

  @override
  State<_AnimatedEditButton> createState() => _AnimatedEditButtonState();
}

class _AnimatedEditButtonState extends State<_AnimatedEditButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.85 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: IconButton(
          onPressed: widget.onPressed,
          icon: Icon(
            Icons.edit_outlined,
            size: 20,
            color: widget.isDark
                ? AppTheme.textLightGray
                : const Color(0xFF666666),
          ),
          tooltip: 'Edit task',
        ),
      ),
    );
  }
}
