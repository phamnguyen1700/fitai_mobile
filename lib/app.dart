// lib/app.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_links/app_links.dart';

import 'core/config/theme/app_theme.dart';
import 'core/router/app_router.dart';

class FitAIApp extends ConsumerStatefulWidget {
  const FitAIApp({super.key});

  @override
  ConsumerState<FitAIApp> createState() => _FitAIAppState();
}

class _FitAIAppState extends ConsumerState<FitAIApp> {
  StreamSubscription<Uri>? _sub;
  late AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _handleInitialUri();
    _listenIncomingLinks();
  }

  void _listenIncomingLinks() {
    _sub = _appLinks.uriLinkStream.listen(
      (uri) {
        _handlePaymentUri(uri);
      },
      onError: (err) {
        // nếu muốn log thì print(err);
      },
    );
  }

  Future<void> _handleInitialUri() async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _handlePaymentUri(uri);
      }
    } on PlatformException {
      // ignore / log nếu cần
    } on FormatException {
      // ignore / log nếu cần
    }
  }

  void _handlePaymentUri(Uri uri) {
    if (uri.scheme != 'fitaiplanning') return;
    if (uri.host != 'payment') return;

    String? status;

    final statusParam = uri.queryParameters['status'];
    if (statusParam != null) {
      status = statusParam;
    } else {
      final segments = uri.pathSegments; // ['result', 'success']
      if (segments.length >= 2 && segments[0] == 'result') {
        status = segments[1];
      }
    }

    if (status != 'success' && status != 'failed') {
      return;
    }

    final router = ref.read(goRouterProvider);
    router.go('/payment/result/$status');
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      builder: (context, child) {
        final media = MediaQuery.of(context);
        final size = media.size;

        final height = size.height;
        final shortestSide = size.shortestSide;

        double scale = 1.0;
        if (shortestSide < 340) {
          scale = 0.85;
        } else if (shortestSide < 380 || height < 700) {
          scale = 0.9;
        } else {
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
