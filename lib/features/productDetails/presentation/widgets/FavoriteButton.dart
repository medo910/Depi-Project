import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  final String productId;
  final bool initialIsFavorite;
  final Function(String productId)? onFavoritePressed;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? size;

  const FavoriteButton({
    super.key,
    required this.productId,
    this.initialIsFavorite = false,
    this.onFavoritePressed,
    this.activeColor,
    this.inactiveColor,
    this.size,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late bool isFavorite;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initialIsFavorite;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    // تشغيل الانيميشن
    _controller.forward().then((_) => _controller.reverse());

    // استدعاء الـ callback
    if (widget.onFavoritePressed != null) {
      widget.onFavoritePressed!(widget.productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color:
              isFavorite
                  ? (widget.activeColor ?? Colors.red)
                  : (widget.inactiveColor ?? Colors.grey),
          size: widget.size ?? 24,
        ),
      ),
    );
  }
}
