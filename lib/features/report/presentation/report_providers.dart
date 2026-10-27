import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sistem_manajemen_laundry/core/database/database_provider.dart';
import 'package:sistem_manajemen_laundry/features/report/data/report_repository.dart';
import 'package:sistem_manajemen_laundry/features/report/domain/report_data.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(ref.watch(databaseProvider));
});

typedef ReportQuery = ({DateTime start, DateTime end});

final reportProvider = FutureProvider.autoDispose
    .family<ReportData, ReportQuery>((ref, query) async {
      return ref
          .watch(reportRepositoryProvider)
          .load(start: query.start, end: query.end);
    });
