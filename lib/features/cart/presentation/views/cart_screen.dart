import 'package:depi_app/core/utils/app_styles.dart';
import 'package:depi_app/features/checkout/presentation/views/checkout_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_router.dart';
import '../../../../core/widgets/custom_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  double total = 0;
  double withoutTax = 0;
  double tax = 0;

  final List<Map<String, dynamic>> items = [
    {
      'name': 'Wireless Headphones',
      'company': 'TechSound',
      'color': 'Silver',
      'price': 159,
      'quantity': 2,
      'icon': Icons.headphones,
    },
    {
      'name': 'Comfort Running Shoes',
      'company': 'SportMax',
      'color': 'White',
      'size': 40,
      'price': 89,
      'quantity': 1,
      'icon': Icons.directions_run,
    },
    // {
    //   'name': 'Wireless Headphones',
    //   'company': 'TechSound',
    //   'color': 'Silver',
    //   'price': 159,
    //   'quantity': 2,
    //   'icon': Icons.headphones,
    // },
    // {
    //   'name': 'Comfort Running Shoes',
    //   'company': 'SportMax',
    //   'color': 'White',
    //   'size': 40,
    //   'price': 89,
    //   'quantity': 1,
    //   'icon': Icons.directions_run,
    // },
    // {
    //   'name': 'Wireless Headphones',
    //   'company': 'TechSound',
    //   'color': 'Silver',
    //   'price': 159,
    //   'quantity': 2,
    //   'icon': Icons.headphones,
    // },
    // {
    //   'name': 'Comfort Running Shoes',
    //   'company': 'SportMax',
    //   'color': 'White',
    //   'size': 40,
    //   'price': 89,
    //   'quantity': 1,
    //   'icon': Icons.directions_run,
    // },
    // {
    //   'name': 'Wireless Headphones',
    //   'company': 'TechSound',
    //   'color': 'Silver',
    //   'price': 159,
    //   'quantity': 2,
    //   'icon': Icons.headphones,
    // },
    // {
    //   'name': 'Comfort Running Shoes',
    //   'company': 'SportMax',
    //   'color': 'White',
    //   'size': 40,
    //   'price': 89,
    //   'quantity': 1,
    //   'icon': Icons.directions_run,
    // },
    // {
    //   'name': 'Wireless Headphones',
    //   'company': 'TechSound',
    //   'color': 'Silver',
    //   'price': 159,
    //   'quantity': 2,
    //   'icon': Icons.headphones,
    // },
    // {
    //   'name': 'Comfort Running Shoes',
    //   'company': 'SportMax',
    //   'color': 'White',
    //   'size': 40,
    //   'price': 89,
    //   'quantity': 1,
    //   'icon': Icons.directions_run,
    // },
  ];

  @override
  void initState() {
    super.initState();
    calculateTotals();
  }

  void calculateTotals() {
    double newWithoutTax = 0;
    for (var item in items) {
      newWithoutTax += item['price'] * item['quantity'];
    }
    setState(() {
      withoutTax = newWithoutTax;
      tax = withoutTax * 0.08;
      total = withoutTax + tax;
    });
  }

  void removeItem(int index) {
    setState(() {
      items.removeAt(index);
      calculateTotals();
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFD6EFD8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Shopping Cart',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("🛒", style: TextStyle(fontSize: 100)),
            const SizedBox(height: 8),
            Text("Your cart is empty", style: AppStyles.styleBold24Dark),
            const SizedBox(height: 12),
            Text(
              "Looks like you haven't added anything to your cart yet",
              style: AppStyles.styleRegular16Muted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF80AF81),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 8),
              ),
              child: const Text(
                "Start Shopping",
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFF80AF81),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item['icon'],
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                item['company'],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  if (item.containsKey('size'))
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      margin:
                                      const EdgeInsets.only(right: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD6EFD8),
                                        borderRadius:
                                        BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Size: ${item['size']}',
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12),
                                      ),
                                    ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD6EFD8),
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Color: ${item['color']}',
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '\$${item['price']}',
                                    style: const TextStyle(
                                        color: Color(0xFF80AF81),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color:
                                              Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.remove),
                                              onPressed: () {
                                                setState(() {
                                                  if (item['quantity'] > 1) {
                                                    item['quantity']--;
                                                    calculateTotals();
                                                  }
                                                });
                                              },
                                              iconSize: 18,
                                            ),
                                            Text(item['quantity']
                                                .toString()),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () {
                                                setState(() {
                                                  item['quantity']++;
                                                  calculateTotals();
                                                });
                                              },
                                              iconSize: 18,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.redAccent),
                                        onPressed: () {
                                          removeItem(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.discount_outlined,
                              color: Color(0xFF80AF81)),
                          SizedBox(width: 6),
                          Text(
                            "Discount Coupon",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter coupon code (try SAVE1)',
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 13),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            flex: 0,
                            child: CustomButton(
                              onPressed: () {},
                              text: "Apply",
                              backgroundColor: const Color(0xFFD6EFD8),
                              textColor: const Color(0xFF80AF81),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),

              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Order Summary",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Subtotal"),
                          Text("\$${withoutTax.toStringAsFixed(2)}"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Shipping"),
                          Text("Free",
                              style: TextStyle(
                                  color: Color(0xFF80AF81),
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Tax"),
                          Text("\$${tax.toStringAsFixed(2)}"),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "\$${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: items.isNotEmpty?
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: CustomButton(
                  onPressed: () {
                    AppRouter.router.go(AppRouter.kCheckout);
                    },
                 text: 'Checkout • \$${total.toStringAsFixed(2)}',
                   backgroundColor:const Color(0xFF80AF81),
                 textColor: Colors.white,
               ),

         )
      : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
