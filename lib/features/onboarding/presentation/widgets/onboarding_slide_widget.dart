import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

class OnboardingSlideWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const OnboardingSlideWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        key: ValueKey(title),
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => AppRouter.router.go(AppRouter.kLogin),
                child: const Text('Skip', style: AppStyles.styleMedium16Dark),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutBack,
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(icon, size: 50, color: color),
            ),
            const SizedBox(height: 30),
            Text(
              title,
              style: AppStyles.styleBold24Dark,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: AppStyles.styleRegular16Muted,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
