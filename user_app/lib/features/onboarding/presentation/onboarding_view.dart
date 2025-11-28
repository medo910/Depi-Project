import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/features/onboarding/presentation/widgets/custom_elevated_button.dart';
import 'package:depi_app/features/onboarding/presentation/widgets/onboarding_slide_widget.dart';
import 'package:depi_app/features/onboarding/presentation/widgets/page_indicator_widget.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final theme=Theme.of(context);

  late final List<OnboardingSlideWidget> _slides =  [
    OnboardingSlideWidget(
      icon: Icons.shopping_bag_outlined,
      title: 'Shop Easily',
      subtitle: 'Browse thousands of products with just a few taps',
      color: theme.primaryColor,
    ),
    OnboardingSlideWidget(
      icon: Icons.shield_outlined,
      title: 'Secure Payments',
      subtitle: 'Your payments are safe and protected with us',
      color: theme.primaryColor,
    ),
    OnboardingSlideWidget(
      icon: Icons.chat_bubble_outline,
      title: 'Live Support',
      subtitle: 'Get help from our team anytime you need it',
      color: theme.primaryColor,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _skip();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() => AppRouter.router.go(AppRouter.kLogin);

  @override
  Widget build(BuildContext context) {
    late final theme=Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            PageIndicatorsWidget(total: _slides.length, current: _currentPage),
            const SizedBox(height: 30),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (_, index) => _slides[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton.icon(
                      onPressed: _prevPage,
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 16,
                      ),
                      label:  Text(
                        'Back',
                        style: theme.textTheme.bodyLarge,
                      ),
                    )
                  else
                    const SizedBox(width: 64),
                  CustomElevatedButton(
                    onPressed: _nextPage,
                    slides: _slides.length,
                    currentPage: _currentPage,
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
