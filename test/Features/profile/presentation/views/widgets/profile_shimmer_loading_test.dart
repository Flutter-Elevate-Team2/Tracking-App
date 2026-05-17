import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/Features/profile/presentation/views/widgets/profile_shimmer_loading.dart';
import 'package:tracking_app/core/widget/app_shimmer.dart';

void main() {
  testWidgets('ProfileShimmerLoading renders AppShimmer widgets', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ProfileShimmerLoading())),
    );

    // It should render multiple AppShimmers
    expect(find.byType(AppShimmer), findsAtLeastNWidgets(4));
  });
}
