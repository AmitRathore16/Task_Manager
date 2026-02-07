import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/providers/task_provider.dart';
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

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task deleted'),
                duration: Duration(seconds: 2),
              ),
            );

            return true; // allow animation
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error deleting task: $e'),
              ),
            );
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
            /// Checkbox
            InkWell(
              onTap: () async {
                try {
                  await taskOps.toggleTaskCompletion(task);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? AppTheme.secondaryGold
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: task.isCompleted
                        ? AppTheme.secondaryGold
                        : (isDark
                        ? AppTheme.textMutedGray
                        : const Color(0xFFCCCCCC)),
                    width: 2,
                  ),
                ),
                child: task.isCompleted
                    ? const Icon(
                  Icons.check,
                  size: 16,
                  color: AppTheme.pureBlack,
                )
                    : null,
              ),
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

            /// Edit Button
            IconButton(
              onPressed: () {
                showAddEditTaskDialog(context, task: task);
              },
              icon: Icon(
                Icons.edit_outlined,
                size: 20,
                color: isDark
                    ? AppTheme.textLightGray
                    : const Color(0xFF666666),
              ),
              tooltip: 'Edit task',
            ),
          ],
        ),
      ),
    );
  }
}
