import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kbc_by_stacx/core/constants/app_constants.dart';
import 'package:kbc_by_stacx/main.dart';

void main() {
  testWidgets('Splash screen shows brand and loading content', (tester) async {
    await tester.pumpWidget(const BiryaniHouseApp());
    await tester.pump(const Duration(seconds: 5));

    expect(find.text(AppConstants.brandName), findsOneWidget);
    expect(
      find.text('Cooking the next hot', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('batch'), findsOneWidget);
    expect(
      find.text(AppConstants.splashSubheading, findRichText: true),
      findsOneWidget,
    );

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
      const Size(680, 783),
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

      final exception = tester.takeException();
      expect(exception, isNull, reason: 'Viewport size: $size');

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    }
  });

  testWidgets('Home hero appears after splash completes', (tester) async {
    await tester.pumpWidget(const BiryaniHouseApp());
    await tester.pump(AppConstants.splashDuration);
    await tester.pump(const Duration(seconds: 5));

    expect(find.text('KBC'), findsOneWidget);
    expect(
      find.text(AppConstants.heroHeadline, findRichText: true),
      findsOneWidget,
    );
    expect(find.text(AppConstants.heroDescription), findsOneWidget);
    expect(find.text(AppConstants.heroCta), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('Home hero lays out across common viewport sizes', (
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
      await tester.pump(AppConstants.splashDuration);
      await tester.pump(const Duration(seconds: 5));

      final exception = tester.takeException();
      expect(exception, isNull, reason: 'Viewport size: $size');

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    }
  });
}
