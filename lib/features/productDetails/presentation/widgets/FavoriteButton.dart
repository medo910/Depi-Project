import 'package:flutter/material.dart';
import 'package:depi_app/features/productDetails/data/FavoriteService.dart';

class FavoriteButton extends StatefulWidget {
  final String userId;
  final String productId;
  final Function(String productId)? onFavoritePressed;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? size;

  const FavoriteButton({
    super.key,
    required this.productId,
    required this.userId,
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
  bool? isFavorite;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _loadFavoriteStatus() async {
    bool fav = await FavoriteService().isFavorite(
      widget.userId,
      widget.productId,
    );
    setState(() {
      isFavorite = fav;
    });
  }

  void _toggleFavorite() async {
    if (isFavorite == null) return; // لو البيانات لسه محملة
    setState(() {
      isFavorite = !isFavorite!;
    });

    _controller.forward().then((_) => _controller.reverse());

    // تحديث Firebase
    await FavoriteService().toggleFavorite(widget.userId, widget.productId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      child:
          isFavorite == null
              ? SizedBox(
                width: widget.size ?? 24,
                height: widget.size ?? 24,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
              : ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(
                  isFavorite! ? Icons.favorite : Icons.favorite_border,
                  color:
                      isFavorite!
                          ? (widget.activeColor ?? Colors.red)
                          : (widget.inactiveColor ?? Colors.grey),
                  size: widget.size ?? 24,
                ),
              ),
    );
  }
}
