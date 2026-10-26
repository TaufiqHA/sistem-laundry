/// Asal perubahan status, untuk jejak audit dan laporan.
enum StatusChangeSource {
  manual('Manual'),
  scan('Scan'),
  urungkan('Urungkan');

  const StatusChangeSource(this.label);

  final String label;
}
