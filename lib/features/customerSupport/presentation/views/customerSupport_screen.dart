import 'package:flutter/material.dart';

import '../../../../core/utils/app_styles.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6EFD8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 100,
        leading: GestureDetector(
          child: Row(
            children: [
              const SizedBox(width: 8),
              Icon(Icons.arrow_back,color: Colors.black,),
              const SizedBox(width: 8),
              Text('Profile', style: AppStyles.styleMedium14Dark,)
            ],
          ),
          onTap: (){Navigator.pop(context);},
        ),
        title: Text('Customer Support',style: AppStyles.styleSemiBold18Dark,),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        spacing: 10,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded),
                          Text("Contact Methods")
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Card(
                        elevation: 0.5,
                        color: Colors.white,
                        shadowColor: Colors.grey,
                        child: ListTile(
                          leading: Icon(Icons.chat_bubble_outline_rounded,color: Colors.green,),
                          title: Text("Live Chat"),
                          subtitle: Text("Available 24/7"),
                          trailing: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            color: Color(0xFFDBFCE7),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text("Available",style: TextStyle(color: Color(0xFF1e5e31),fontSize: 12,fontWeight: FontWeight.w500),),
                            ),
                          ),
                        ),
                      ),
                      onTap: (){},
                    ),
                    const SizedBox(height: 12,),
                    Card(
                      elevation: 0.5,
                      color: Colors.white,
                      shadowColor: Colors.grey,
                      child: ListTile(
                        leading: Icon(Icons.local_phone_outlined,color: Colors.blue,),
                        title: Text("Phone Support"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("9 AM - 9 PM"),
                            Text("+20xxxxxxxxxx"),
                          ],
                        ),
                        trailing: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          color: Color(0xFFDBFCE7),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text("Available",style: TextStyle(color: Color(0xFF1e5e31),fontSize: 12,fontWeight: FontWeight.w500),),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Card(
                      elevation: 0.5,
                      color: Colors.white,
                      shadowColor: Colors.grey,
                      child: ListTile(
                        leading: Icon(Icons.email_outlined,color: Colors.purple,),
                        title: Text("Email Support"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Response within 24 hours"),
                            Text("support@kite.com"),
                          ],
                        ),
                        trailing: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          color: Color(0xFFDBFCE7),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text("Available",style: TextStyle(color: Color(0xFF1e5e31),fontSize: 12,fontWeight: FontWeight.w500),),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12,),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6,),
                    Text("Quick Tips",style: TextStyle(fontWeight: FontWeight.w400),),
                    const SizedBox(height: 12,),
                    ListTile(
                      leading: Text('💡',style: TextStyle(fontSize: 18),),
                      title: Text("Be specific in your description",style: TextStyle(fontWeight: FontWeight.w500),),
                      subtitle: Text("Include details like order number, date of issue, and error message"),
                    ),
                    ListTile(
                      leading: Text('📸',style: TextStyle(fontSize: 18),),
                      title: Text("Attach images if possible",style: TextStyle(fontWeight: FontWeight.w500),),
                      subtitle: Text("Images help us understand your issue better"),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
