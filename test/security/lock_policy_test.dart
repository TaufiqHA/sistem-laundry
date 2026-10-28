import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/features/security/domain/lock_policy.dart';

void main() {
  test('kunci lagi setelah 5 menit di latar belakang', () {
    final paused = DateTime(2026, 10, 28, 10);
    expect(
      shouldLockAfterResume(paused, paused.add(const Duration(minutes: 4))),
      isFalse,
    );
    expect(
      shouldLockAfterResume(paused, paused.add(const Duration(minutes: 5))),
      isTrue,
    );
    expect(
      shouldLockAfterResume(paused, paused.add(const Duration(hours: 1))),
      isTrue,
    );
  });

  test('tanpa waktu jeda tidak mengunci', () {
    expect(shouldLockAfterResume(null, DateTime.now()), isFalse);
  });
}
