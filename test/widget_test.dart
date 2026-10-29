import 'package:flutter_test/flutter_test.dart';
import 'package:eunomia/app/data/services/api_service.dart';
import 'package:eunomia/app/data/models/models.dart';

void main() {
  test('ApiService initializes with correct default base URL', () {
    final api = ApiService();
    expect(api.baseUrl.value, 'https://eunomiaapi.motionlaboratory.com');
  });

  test('TaskStatusEnum converts properly from string and keys', () {
    expect(TaskStatusEnum.fromString('TODO'), TaskStatusEnum.todo);
    expect(TaskStatusEnum.fromString('IN_PROGRESS'), TaskStatusEnum.inProgress);
    expect(TaskStatusEnum.fromString('DONE'), TaskStatusEnum.done);
  });
}
