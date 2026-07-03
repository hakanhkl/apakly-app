import 'dart:async';

import 'package:apakly/login/login_screen.dart';
import 'package:apakly/music_player/song_repository.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'audio_handler.dart';
import 'constants.dart';
import 'home/blocs/music_player/music_player_bloc.dart';
import '../http/auth.dart';
import 'package:go_router/go_router.dart';
import 'home/homescreen.dart';
import 'l10n/l10n.dart';
import 'marketplace/components/marketplace_item_preview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// used to save user login
late final bool isJwtValidVar;
Timer? timer;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AudioHandler audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(),
  );

  // required to disable screen recording
  // disabled for test reviews
  FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);

  isJwtValidVar = await isJwtValid();

  runApp(
    RestartWidget(
      child: MyApp(audioHandler: audioHandler),
    ),
  );
  // runApp(MyApp(audioHandler: audioHandler));

  timer = Timer.periodic(
      const Duration(seconds: 1), (Timer t) => pauseIfScreenRecording(audioHandler));
}

// Pauses playback whenever the screen is being recorded/captured, to prevent
// protected audio from being screen-recorded. The native side reports the
// capture state over the platform channel.
void pauseIfScreenRecording(AudioHandler audioHandler) async {
  const platform = MethodChannel('samples.flutter.dev/screenRecording');
  try {
    final isScreenCaptured =
        await platform.invokeMethod<bool>('isScreenCaptured');
    if (isScreenCaptured!) {
      audioHandler.pause();
    }
  } on PlatformException catch (e) {
    debugPrint("Failed to read screen capture state: '${e.message}'.");
  } on MissingPluginException catch (e) {
    debugPrint("Screen capture check not implemented: '${e.message}'.");
  }
}

// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          isJwtValidVar ? const HomeScreen() : const LoginScreen(),
      routes: [
        GoRoute(
            path: 'login', builder: (context, state) => const LoginScreen()),
        GoRoute(
          path: 'sharesong/:id',
          builder: (context, state) =>
              MarketplaceItemPreview(id: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key, required AudioHandler audioHandler})
      : _audioHandler = audioHandler;

  final AudioHandler _audioHandler;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SongRepository>(
          create: (context) => SongRepository(audioHandler: _audioHandler),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MusicPlayerBloc(
              songRepository: context.read<SongRepository>(),
            )..add(MusicPlayerStarted()),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'apakly',
          scrollBehavior: MyBehavior(),
          theme: themeData,
          routerConfig: _router,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            String languageCode = locale!.languageCode;
            if (supportedLocales.contains(Locale(languageCode))) {
              return Locale(languageCode);
            }
            return const Locale('en'); // Fallback auf Englisch
          },
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
    while (context.canPop()) {
      context.pop();
    }
    context.go("/login");
    // Navigator.pushNamed(context, "/login");
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
