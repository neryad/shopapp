import 'package:flutter/material.dart';
import 'package:pocketlist/src/Shared_Prefs/Preferencias_user.dart';
import 'package:pocketlist/src/localization/localization_constant.dart';
import 'package:pocketlist/src/pages/home_page.dart';
import 'package:pocketlist/src/pages/onboarding/onboarding_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final prefs = PreferenciasUsuario();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      icon: Icons.shopping_cart,
      titleKey: 'onboardingTitle1',
      descriptionKey: 'onboardingDesc1',
    ),
    _OnboardingData(
      icon: Icons.account_balance_wallet,
      titleKey: 'onboardingTitle2',
      descriptionKey: 'onboardingDesc2',
    ),
    _OnboardingData(
      icon: Icons.file_download,
      titleKey: 'onboardingTitle3',
      descriptionKey: 'onboardingDesc3',
    ),
    _OnboardingData(
      icon: Icons.palette,
      titleKey: 'onboardingTitle4',
      descriptionKey: 'onboardingDesc4',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onComplete() {
    prefs.onboardingSeen = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _onComplete,
                child: Text(
                  getTranslated(context, 'onboardingSkip'),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingScreen(
                    icon: page.icon,
                    titleKey: page.titleKey,
                    descriptionKey: page.descriptionKey,
                  );
                },
              ),
            ),
            // Indicators and button
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicators
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Next or Start button
                  _currentPage == _pages.length - 1
                      ? SizedBox(
                          width: 160,
                          child: ElevatedButton(
                            onPressed: _onComplete,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              getTranslated(context, 'onboardingStart'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : IconButton(
                          onPressed: _nextPage,
                          icon: Icon(
                            Icons.arrow_forward,
                            color: Theme.of(context).colorScheme.primary,
                            size: 32,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  final IconData icon;
  final String titleKey;
  final String descriptionKey;

  _OnboardingData({
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
  });
}
