import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/dashboard/task_model.dart';

void main() {
  test('Task model serialization works correctly', () {
    final json = {
      'id': '123',
      'user_id': 'user_1',
      'title': 'Test Task',
      'is_completed': false,
      'created_at': '2024-01-01T12:00:00.000Z',
    };

    // JSON → Model
    final task = Task.fromJson(json);

    expect(task.id, '123');
    expect(task.userId, 'user_1');
    expect(task.title, 'Test Task');
    expect(task.isCompleted, false);
    expect(task.createdAt, DateTime.parse('2024-01-01T12:00:00.000Z'));

    // Model → JSON
    final convertedJson = task.toJson();

    expect(convertedJson['id'], json['id']);
    expect(convertedJson['user_id'], json['user_id']);
    expect(convertedJson['title'], json['title']);
    expect(convertedJson['is_completed'], json['is_completed']);
    expect(convertedJson['created_at'], json['created_at']);
  });
}
