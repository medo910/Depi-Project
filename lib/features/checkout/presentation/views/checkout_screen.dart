import 'package:depi_app/core/utils/app_styles.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_button.dart';
import '../widgets/buildtextfield.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneNumController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  final cardholderNameController = TextEditingController();
  bool isCardSelected = false;


  @override
  void dispose() {
    nameController.dispose();
    phoneNumController.dispose();
    addressController.dispose();
    cityController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    cardholderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6EFD8),
      appBar: AppBar(title: Text("Checkout"),centerTitle: true,backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,color: Color(0xFF80AF81),),
                            Text(" Shipping Address",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 17),)
                          ],
                        ),
                        const SizedBox(height: 15,),
                        buildTextField('Full Name','Full Name',nameController),
                        const SizedBox(height: 12,),
                        buildTextField('Phone Number','+20 1234567890',phoneNumController),
                        const SizedBox(height: 12,),
                        buildTextField('Address','Floor, Apartment, Building, Street.',addressController),
                        const SizedBox(height: 12,),
                        buildTextField('City','City/Area',cityController),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            Icon(Icons.credit_card,color: Color(0xFF80AF81),),
                            Text(
                              ' Payment Method',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        InkWell(
                          onTap: () => setState(() => isCardSelected = false),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: !isCardSelected ? Colors.green : Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                !isCardSelected
                                    ? Icon(Icons.circle, color: Color(0xFF80AF81),size: 10,)
                                    : SizedBox.shrink(),
                                Text('  💵',style: TextStyle(fontSize: 20),),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Cash on Delivery',
                                          style: TextStyle(fontWeight: FontWeight.w600)),
                                      const Text('Pay when your order is delivered'),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15),
                                 Expanded(
                                   child: Text(
                                    '• Delivery in 3-5 business days',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600
                                    ),
                                                                   ),
                                 ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        InkWell(
                          onTap: () => setState(() => isCardSelected = true),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isCardSelected ? Colors.green : Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                isCardSelected
                                    ? Icon(Icons.circle, color: Color(0xFF80AF81),size: 10,)
                                    : SizedBox.shrink(),
                                Text('  💳',style: TextStyle(fontSize: 20),),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Credit/Debit Card',
                                          style: TextStyle(fontWeight: FontWeight.w600)),
                                      const Text('Visa, MasterCard, American Express'),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    '• Fast delivery in 1-2 business days',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
            
                        SizedBox(height: 20),

                        if (isCardSelected) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF8EF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                buildTextField('Card Number', '1234 5678 9012 3456', cardNumberController),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(child: buildTextField('Expiry Date', 'MM/YY', expiryDateController)),
                                    const SizedBox(width: 10),
                                    Expanded(child: buildTextField('CVV', '123', cvvController)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                buildTextField('Cardholder Name', 'Name as on card', cardholderNameController),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order Summary",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12,),
                        // لسه هنا هضيف تفاصيل الاوردر
                        Text('''order 
                        details
                        is
                        here'''),
                        Divider(color: Colors.grey[300],),
                        const SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal'),
                            Text('\$ ')
                          ],
                        ),
                        const SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Shipping'),
                            // لسه هعمل لو التوتال اكبر من رقم معين يبقى مجاني غير كده بسعر
                            Text('\$ ')
                          ],
                        ),
                        const SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tax'),
                            //tax = withoutTax * 0.08;
                            Text('\$ ')
                          ],
                        ),
                        Divider(color: Colors.grey[300],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                            Text('\$ ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))
                          ],
                        ),


                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 120,),
              ],
            ),
          ),
        ),
      ),
      // لسه هقول لو حاطت عنوانه والفيزا صح يبقى لونه غامق وينفع يتداس عليه غير كده لا
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),

        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: CustomButton(
            onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckoutScreen())); },
            text: 'Confirm Payment • \$',
            backgroundColor:const Color(0xFFBFD7C0),
            size: 18,
            textColor: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: _CustomFABLocation(),
    );
  }
}

class _CustomFABLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {

    double x = scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width;
    double y = scaffoldGeometry.scaffoldSize.height -
        scaffoldGeometry.floatingActionButtonSize.height;

    return Offset(x, y);
  }
}
