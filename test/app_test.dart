import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sistem_manajemen_laundry/app.dart';

void main() {
  testWidgets('empat tab, scan, dan pengaturan bisa dibuka', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LaundryApp()));
    await tester.pumpAndSettle();

    expect(find.text('Belum ada aktivitas'), findsOneWidget);

    await tester.tap(find.text('Order'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada order'), findsOneWidget);

    await tester.tap(find.text('Pelanggan'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada pelanggan'), findsOneWidget);

    await tester.tap(find.text('Laporan'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada laporan'), findsOneWidget);

    await tester.tap(find.text('Scan'));
    await tester.pumpAndSettle();
    expect(find.text('Pemindai belum aktif'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada laporan'), findsOneWidget);

    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Pengaturan belum tersedia'), findsOneWidget);
  });
}
