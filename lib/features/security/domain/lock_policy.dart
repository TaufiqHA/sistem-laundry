const lockTimeout = Duration(minutes: 5);

/// Aplikasi dikunci lagi hanya jika benar-benar lama di latar belakang.
bool shouldLockAfterResume(
  DateTime? pausedAt,
  DateTime resumedAt, {
  Duration timeout = lockTimeout,
}) {
  if (pausedAt == null) {
    return false;
  }
  return resumedAt.difference(pausedAt) >= timeout;
}
