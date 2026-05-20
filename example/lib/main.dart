import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:liquid_glass_widgets_example/constants/glass_settings.dart';
import 'package:liquid_glass_widgets_example/pages/containers_page.dart';
import 'package:liquid_glass_widgets_example/pages/feedback_page.dart';
import 'package:liquid_glass_widgets_example/pages/interactive_page.dart';
import 'package:liquid_glass_widgets_example/pages/overlays_page.dart';

void main() async {
  // Ensure Flutter bindings are initialized before loading shaders
  WidgetsFlutterBinding.ensureInitialized();

  // Initializes the Liquid Glass library.
  await LiquidGlassWidgets.initialize();

  // wrap() puts a GlassBackdropScope at the root so every glass surface in the
  // app (GlassBottomBar, GlassAppBar, GlassCard, etc.) shares a single GPU
  // backdrop capture on Impeller.
  runApp(LiquidGlassWidgets.wrap(child: const AppleLiquidGlassShowcaseApp()));
}

/// An InheritedWidget to share the active locale and toggle controller across the app.
class LocaleController extends InheritedWidget {
  const LocaleController({
    super.key,
    required this.locale,
    required this.toggleLocale,
    required super.child,
  });

  final Locale locale;
  final VoidCallback toggleLocale;

  static LocaleController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocaleController>()!;
  }

  @override
  bool updateShouldNotify(LocaleController oldWidget) {
    return locale != oldWidget.locale;
  }
}

class AppleLiquidGlassShowcaseApp extends StatefulWidget {
  const AppleLiquidGlassShowcaseApp({super.key});

  @override
  State<AppleLiquidGlassShowcaseApp> createState() =>
      _AppleLiquidGlassShowcaseAppState();
}

class _AppleLiquidGlassShowcaseAppState
    extends State<AppleLiquidGlassShowcaseApp> {
  Locale _locale = const Locale('ar'); // Default to Arabic as requested!

  void _toggleLocale() {
    setState(() {
      _locale = _locale.languageCode == 'ar'
          ? const Locale('en')
          : const Locale('ar');
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocaleController(
      locale: _locale,
      toggleLocale: _toggleLocale,
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Apple Liquid Glass Showcase',
          theme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorScheme: const ColorScheme.dark(
              primary: Colors.blue,
              surface: Colors.black,
            ),
          ),
          locale: LocaleController.of(context).locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar'),
            Locale('en'),
          ],
          home: const ShowcaseHomePage(),
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}

class ShowcaseHomePage extends StatefulWidget {
  const ShowcaseHomePage({super.key});

  @override
  State<ShowcaseHomePage> createState() => _ShowcaseHomePageState();
}

class _ShowcaseHomePageState extends State<ShowcaseHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ContainersPage(),
    InteractivePage(),
    FeedbackPage(),
    OverlaysPage(),
  ];

  List<GlassBottomBarTab> _buildTabs(BuildContext context) {
    return [
      GlassBottomBarTab(
        label: _Loc.tabHome(context),
        icon: const Icon(CupertinoIcons.home),
        activeIcon: const Icon(CupertinoIcons.house_fill),
      ),
      GlassBottomBarTab(
        label: _Loc.tabContainers(context),
        icon: const Icon(CupertinoIcons.square_stack_3d_up),
        activeIcon: const Icon(CupertinoIcons.square_stack_3d_up_fill),
      ),
      GlassBottomBarTab(
        label: _Loc.tabInteractive(context),
        icon: const Icon(CupertinoIcons.hand_point_right),
        activeIcon: const Icon(CupertinoIcons.hand_point_right_fill),
      ),
      GlassBottomBarTab(
        label: _Loc.tabFeedback(context),
        icon: const Icon(CupertinoIcons.hourglass),
        activeIcon: const Icon(CupertinoIcons.hourglass),
      ),
      GlassBottomBarTab(
        label: _Loc.tabOverlays(context),
        icon: const Icon(CupertinoIcons.square_stack),
        activeIcon: const Icon(CupertinoIcons.square_stack_fill),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _buildTabs(context);
    return LiquidGlassScope.stack(
      background: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper_dark.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      content: Positioned.fill(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: _pages[_selectedIndex],
          bottomNavigationBar: GlassBottomBar(
            quality: GlassQuality.premium,
            indicatorColor: Colors.black26,
            glassSettings: RecommendedGlassSettings.bottomBar,
            unselectedIconColor: Colors.white38,
            selectedIconColor: Colors.white,
            tabs: tabs,
            selectedIndex: _selectedIndex,
            onTabSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLiquidGlassLayer(
      settings: RecommendedGlassSettings.standard,
      quality: GlassQuality.standard, // Scrollable content - use standard
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _Loc.title(context),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _Loc.subtitle(context),
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Glass language toggle button
                        Semantics(
                          button: true,
                          label: 'Language Toggle',
                          child: GlassCard(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: InkWell(
                              onTap: () =>
                                  LocaleController.of(context).toggleLocale(),
                              borderRadius: BorderRadius.circular(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(CupertinoIcons.globe,
                                      color: Colors.white, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    LocaleController.of(context)
                                                .locale
                                                .languageCode ==
                                            'ar'
                                        ? 'English'
                                        : 'العربية',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    GlassCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.sparkles,
                                color: Colors.white,
                                size: 32,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _Loc.welcome(context),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _Loc.explore(context),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            Colors.white.withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _Loc.description(context),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _Loc.categories(context),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _CategoryCard(
                      icon: const Icon(CupertinoIcons.square_stack_3d_up_fill,
                          color: Colors.white),
                      title: _Loc.tabContainers(context),
                      description: _Loc.descContainers(context),
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 12),
                    _CategoryCard(
                      icon: const Icon(CupertinoIcons.hand_point_right_fill,
                          color: Colors.white),
                      title: _Loc.tabInteractive(context),
                      description: _Loc.descInteractive(context),
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                    _CategoryCard(
                      icon: const Icon(CupertinoIcons.hourglass,
                          color: Colors.white),
                      title: _Loc.tabFeedback(context),
                      description: _Loc.descFeedback(context),
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 12),
                    _CategoryCard(
                      icon: const Icon(CupertinoIcons.square_stack_fill,
                          color: Colors.white),
                      title: _Loc.tabOverlays(context),
                      description: _Loc.descOverlays(context),
                      color: Colors.cyan,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  final Widget icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: icon),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper translations class for easy multi-lingual support
class _Loc {
  static String welcome(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'أهلاً بك'
          : 'Welcome';

  static String explore(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'استكشف مجموعة عناصر الزجاج'
          : 'Explore the glass widget collection';

  static String description(BuildContext context) => LocaleController.of(
                  context)
              .locale
              .languageCode ==
          'ar'
      ? 'يستعرض هذا المعرض عناصر أبل الزجاج السائل المعتمدة على فلسفة تصميم أبل للعناصر البرمجية القابلة للتركيب.'
      : 'This showcase demonstrates Apple Liquid Glass widgets following Apple\'s design philosophy of composable primitives.';

  static String categories(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'فئات العناصر'
          : 'Widget Categories';

  static String title(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'أبل الزجاج السائل'
          : 'Apple Liquid Glass';

  static String subtitle(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'معرض العناصر'
          : 'Widget Showcase';

  // Tabs
  static String tabHome(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'الرئيسية'
          : 'Home';

  static String tabContainers(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'الحاويات'
          : 'Containers';

  static String tabInteractive(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'تفاعلي'
          : 'Interactive';

  static String tabFeedback(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'التقييم'
          : 'Feedback';

  static String tabOverlays(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'التراكبات'
          : 'Overlays';

  // Category descriptions
  static String descContainers(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'بطاقات ولوحات زجاجية لتنظيم المحتوى'
          : 'GlassCard, GlassPanel, and GlassContainer for content';

  static String descInteractive(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'أزرار ومفاتيح تحكم زجاجية تفاعلية'
          : 'GlassButton, GlassSwitch, and GlassSegmentedControl';

  static String descFeedback(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'مؤشرات تقدم زجاجية للتحميل والتقييم'
          : 'GlassProgressIndicator for loading and progress';

  static String descOverlays(BuildContext context) =>
      LocaleController.of(context).locale.languageCode == 'ar'
          ? 'صفائح ونوافذ زجاجية منبثقة تفاعلية'
          : 'GlassSheet for modal dialogs and bottom sheets';
}
