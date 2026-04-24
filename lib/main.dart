  import 'package:provider/provider.dart';
  import 'package:flutter/gestures.dart';
  import 'package:flutter/material.dart';

  import 'package:flutter_localizations/flutter_localizations.dart';
  import 'package:flutter_web_plugins/url_strategy.dart';
  import 'package:firebase_messaging/firebase_messaging.dart';

  import 'auth/custom_auth/auth_util.dart';
  import 'auth/custom_auth/custom_auth_user_provider.dart';

  import 'backend/firebase/firebase_config.dart';
  import '/flutter_flow/flutter_flow_theme.dart';
  import 'flutter_flow/flutter_flow_util.dart';
  import 'flutter_flow/internationalization.dart';
  import 'package:google_fonts/google_fonts.dart';
  import 'flutter_flow/nav/nav.dart';
  import 'index.dart';

  // FCM + Call + Queue services
  import 'services/fcm_service.dart';
  import 'services/call_service.dart';
  import 'services/queue_service.dart';
  import 'package:onesignal_flutter/onesignal_flutter.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    GoRouter.optionURLReflectsImperativeAPIs = true;
    usePathUrlStrategy();

    await initFirebase();

    // Register the background message handler BEFORE any other FCM calls.
    // This MUST be a top-level function, and must be set before runApp().
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final appState = FFAppState(); // Initialize FFAppState
    await appState.initializePersistedState();

    // Initialize OneSignal
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("df0df6f7-a9b1-49da-84fa-b9e4300210c1");
    OneSignal.Notifications.requestPermission(true);

    // Initialize services in order:
    // 1. CallService sets up EventChannel listeners (native → Flutter bridge)
    // 2. QueueService restores persisted state and listens to CallService events
    // 3. FcmService sets up foreground FCM listener and restores background orders
    CallService().initialize();
    await QueueService.instance.restoreState();
    await FcmService().initialize();

    runApp(ChangeNotifierProvider(
      create: (context) => appState,
      child: MyApp(),
    ));
  }

  class MyApp extends StatefulWidget {
  const MyApp({super.key});

    // This widget is the root of your application.
    @override
    State<MyApp> createState() => _MyAppState();

    static _MyAppState of(BuildContext context) =>
        context.findAncestorStateOfType<_MyAppState>()!;
  }

  class MyAppScrollBehavior extends MaterialScrollBehavior {
    @override
    Set<PointerDeviceKind> get dragDevices => {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        };
  }

  class _MyAppState extends State<MyApp> {
    Locale? _locale;

    ThemeMode _themeMode = ThemeMode.system;

    late AppStateNotifier _appStateNotifier;
    late GoRouter _router;
    String getRoute([RouteMatch? routeMatch]) {
      final RouteMatch lastMatch =
          routeMatch ?? _router.routerDelegate.currentConfiguration.last;
      final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
          ? lastMatch.matches
          : _router.routerDelegate.currentConfiguration;
      return matchList.uri.toString();
    }

    List<String> getRouteStack() =>
        _router.routerDelegate.currentConfiguration.matches
            .map((e) => getRoute(e))
            .toList();
    late Stream<QmanjaRiderAuthUser> userStream;

    @override
    void initState() {
      super.initState();

      _appStateNotifier = AppStateNotifier.instance;
      _router = createRouter(_appStateNotifier);
      userStream = qmanjaRiderAuthUserStream()
        ..listen((user) {
        _appStateNotifier.update(user);
      });

    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Qmanja Rider',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({
    super.key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  });

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'home';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'home': const HomeWidget(),
      'orderHistory': const OrderHistoryWidget(),
      'ProfilePage': const ProfilePageWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => safeSetState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        selectedItemColor: FlutterFlowTheme.of(context).primary,
        unselectedItemColor: FlutterFlowTheme.of(context).secondaryText,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event_note_outlined,
              size: 24.0,
            ),
            label: 'Active Orders',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.history,
              size: 24.0,
            ),
            label: 'Order History',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_sharp,
            ),
            label: 'Profile',
            tooltip: '',
          )
        ],
      ),
    );
  }
}
