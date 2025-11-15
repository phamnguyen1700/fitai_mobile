import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/theme/app_theme.dart';
import 'core/router/app_router.dart';

class FitAIApp extends ConsumerWidget {
  const FitAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'FitAI Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),

      /// 👇 Global text scaling: dùng cả height + width (shortestSide)
      builder: (context, child) {
        final media = MediaQuery.of(context);
        final size = media.size;

        final height = size.height;
        final shortestSide = size.shortestSide; // cạnh ngắn của màn

        // Buckets cơ bản:
        // - Màn rất nhỏ / rất hẹp → scale mạnh hơn
        // - Màn bình thường / rộng → giữ nguyên
        double scale = 1.0;

        if (shortestSide < 340) {
          // rất hẹp (máy nhỏ, màn dài)
          scale = 0.85;
        } else if (shortestSide < 380 || height < 700) {
          // hơi hẹp hoặc hơi thấp
          scale = 0.9;
        } else {
          // máy tầm trung trở lên
          scale = 1.0;
        }

        final textScaler = TextScaler.linear(scale);

        return MediaQuery(
          data: media.copyWith(textScaler: textScaler),
          child: child!,
        );
      },
    );
  }
}
