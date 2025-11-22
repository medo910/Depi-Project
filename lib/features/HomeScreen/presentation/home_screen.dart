import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/utils/app_router.dart';
import 'package:depi_app/features/chat/repositories/chat_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:depi_app/core/utils/app_colors.dart';
import 'package:depi_app/core/utils/app_styles.dart';
import 'package:depi_app/features/HomeScreen/presentation/widgets/HorizontalCategoryButtons.dart';
import 'package:depi_app/features/HomeScreen/presentation/widgets/product_item.dart';
import 'package:depi_app/features/HomeScreen/data/repos/ProductService.dart';
import 'package:depi_app/core/models/product.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  List<Product> allProducts = [];
  final user = FirebaseAuth.instance.currentUser;
  final double maxPrice = 2000;
  RangeValues _currentRangeValues = const RangeValues(0, 2000);
  String? selectedValue;
  static const String _sortKey = 'selected_sort_value';
  static const String _minPriceKey = 'min_price_value';
  static const String _maxPriceKey = 'max_price_value';

  @override
  void initState() {
    super.initState();
    listenForIncomingMessages();
    _loadFilterState();
  }

  void listenForIncomingMessages() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('chats')
        .doc(userId)
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: 'sent')
        .snapshots()
        .listen((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.update({'status': 'delivered'});
          }
        });
  }

  Future<void> _saveFilterState() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_sortKey, selectedValue ?? "Newest");

    await prefs.setDouble(_minPriceKey, _currentRangeValues.start);
    await prefs.setDouble(_maxPriceKey, _currentRangeValues.end);
  }

  Future<void> _loadFilterState() async {
    final prefs = await SharedPreferences.getInstance();

    final sort = prefs.getString(_sortKey);
    final minPrice = prefs.getDouble(_minPriceKey);
    final maxPriceFromPrefs = prefs.getDouble(_maxPriceKey);

    setState(() {
      selectedValue = sort ?? "Newest";

      _currentRangeValues = RangeValues(
        minPrice ?? 0.0,
        maxPriceFromPrefs ?? maxPrice,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 15.0,
              ),
              child: Row(
                children: [
                   Text(
                    'Kite',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).primaryColor)
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(Iconsax.setting_2_copy),
                    onPressed: () {
                      GoRouter.of(context).push(AppRouter.kSettings);
                    },
                  ),
                  StreamBuilder<int>(
                    stream: ChatRepository().getUnreadCountStream(),
                    builder: (context, snapshot) {
                      final count = snapshot.data ?? 0;
                      return IconButton(
                        onPressed: () {
                          GoRouter.of(context).push(AppRouter.kUserChat);
                        },
                        icon: Badge(
                          isLabelVisible: count > 0,
                          label: Text('$count'),
                          backgroundColor: Colors.red,
                          child: const Icon(Iconsax.message_text_copy),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.search),
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: const Text(
                              'Search for products...',
                              style: AppStyles.styleMedium18Muted,
                            ),
                            onTap: () {},
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.mic_none_rounded),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.camera_alt_outlined),
                        ),
                        Builder(
                          builder: (innerContext) {
                            return IconButton(
                              onPressed: () {
                                Scaffold.of(innerContext).openEndDrawer();
                              },
                              icon: const Icon(
                                Iconsax.filter_edit_copy,
                                color: AppColors.primary,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            HorizontalCategoryButtons(
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: AppColors.accent.withOpacity(0.5),
                child: StreamBuilder<List<Product>>(
                  stream: ProductService().getProductsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products found',
                          style: AppStyles.styleRegular12Muted,
                        ),
                      );
                    }

                    allProducts = snapshot.data!;

                    List<Product> filteredProducts =
                        selectedCategory == 'All'
                            ? allProducts
                            : allProducts
                                .where((p) => p.category == selectedCategory)
                                .toList();

                    if (filteredProducts.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products found in this category',
                          style: AppStyles.styleRegular12Muted,
                        ),
                      );
                    }
                    filteredProducts =
                        filteredProducts
                            .where(
                              (p) =>
                                  p.price >= _currentRangeValues.start &&
                                  p.price <= _currentRangeValues.end,
                            )
                            .toList();
                    if (selectedValue == "Price: Low to High") {
                      filteredProducts.sort(
                        (a, b) => a.price.compareTo(b.price),
                      );
                    } else if (selectedValue == "Price: High to Low") {
                      filteredProducts.sort(
                        (a, b) => b.price.compareTo(a.price),
                      );
                    } else if (selectedValue == "Rating") {
                      filteredProducts.sort((a, b) => b.rate.compareTo(a.rate));
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];

                        return ProductItem(
                          productId: product.id,
                          userId: user!.uid,
                          productImage: product.photoUrl,
                          productName: product.name,
                          productRating: product.rate,
                          productReviews: product.reviews,
                          productPrice: product.price,
                          productType: product.category,
                          onTap: () async {
                            context.push(
                              AppRouter.kProductDetails,
                              extra: product,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accent, AppColors.accent.withOpacity(0.7)],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Filter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // ------- Price Range Section -------
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Price Range: \$${_currentRangeValues.start.round()} - \$${_currentRangeValues.end.round()}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  RangeSlider(
                    values: _currentRangeValues,
                    min: 0,
                    max: maxPrice,
                    divisions: 200,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.primary.withOpacity(0.3),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _currentRangeValues = values;
                        _saveFilterState();
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),

            // ------- Stylish Dropdown Section -------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sort",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedValue,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.accent,
                            width: 1.5,
                          ),
                        ),
                      ),
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 28,
                        color: Colors.black,
                      ),
                      menuMaxHeight: 250,
                      items: [
                        DropdownMenuItem(
                          value: "Newest",
                          child: Text("Newest"),
                        ),
                        DropdownMenuItem(
                          value: "Price: Low to High",
                          child: Text("Price: Low to High"),
                        ),
                        DropdownMenuItem(
                          value: "Price: High to Low",
                          child: Text("Price: High to Low"),
                        ),
                        DropdownMenuItem(
                          value: "Rating",
                          child: Text("Rating"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value;
                          _saveFilterState();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // ----------------------------------------
          ],
        ),
      ),
    );
  }
}
