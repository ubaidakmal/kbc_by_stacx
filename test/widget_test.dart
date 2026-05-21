import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kbc_by_stacx/core/constants/app_constants.dart';
import 'package:kbc_by_stacx/main.dart';

void main() {
  testWidgets('Splash screen shows brand and loading content', (tester) async {
    await tester.pumpWidget(const BiryaniHouseApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text(AppConstants.brandName), findsOneWidget);
    expect(find.text(AppConstants.splashHeadline), findsOneWidget);
    expect(find.text(AppConstants.splashSubheading), findsOneWidget);
    expect(find.text(AppConstants.locationLabel.toUpperCase()), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('Splash screen lays out across common viewport sizes', (
    tester,
  ) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    final sizes = <Size>[
      const Size(320, 568),
      const Size(390, 844),
      const Size(768, 1024),
      const Size(1440, 900),
    ];

    addTearDown(() async {
      await binding.setSurfaceSize(null);
    });

    for (final size in sizes) {
      await binding.setSurfaceSize(size);
      await tester.pumpWidget(const BiryaniHouseApp());
      await tester.pump(const Duration(seconds: 1));

      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    }
  });
}
