// ------------------------------------
//           FAKE DATA
// ------------------------------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:depi_app/core/models/product.dart';
import 'package:depi_app/core/models/review.dart';

final List<Product> fakeProducts = [
  Product(
    id: 'p1',
    name: 'Nike Air Max 270',
    price: 1800.0,
    photoUrl: 'https://img.icons8.com/color/512/flutter.png',
    comments: [
      Review(
        reviewId: 'r1',
        productId: 'p1',
        date: Timestamp.now(),
        senderId: 'u1',
        message: 'Comfortable and stylish, love it!',
        reactNum: 5,
        rate: 5,
      ),
      Review(
        reviewId: 'r2',
        productId: 'p1',
        date: Timestamp.now(),
        senderId: 'u2',
        message: 'Slightly tight fit, but overall great.',
        reactNum: 3,
        rate: 4,
      ),
    ],
    rate: 4.5,
    reviews: 2,
    quantity: 10,
    brand: 'Nike',
    category: 'Shoes',
    description:
        'The Nike Air Max 270 delivers a soft and responsive cushioning experience with a bold, modern design.',
    instruction: ['Hand wash only', 'Avoid direct sunlight'],
    productAttributeType: ProductAttributeType.color,
    stock: {'black': 5, 'red': 3, 'white': 2},
    date: Timestamp.now(),
  ),
  Product(
    id: 'p2',
    name: 'Adidas Ultraboost 22',
    price: 2200.0,
    photoUrl: 'https://img.icons8.com/color/512/flutter.png',
    comments: [
      Review(
        reviewId: 'r3',
        productId: 'p2',
        date: Timestamp.now(),
        senderId: 'u3',
        message: 'Perfect for long runs!',
        reactNum: 2,
        rate: 5,
      ),
    ],
    rate: 5.0,
    reviews: 1,
    quantity: 7,
    brand: 'Adidas',
    category: 'Shoes',
    description:
        'The Ultraboost 22 offers a perfect blend of comfort, responsiveness, and premium materials.',
    instruction: ['Machine wash cold', 'Air dry only'],
    productAttributeType: ProductAttributeType.size,
    stock: {'40': 2, '41': 3, '42': 2},
    date: Timestamp.now(),
  ),
  Product(
    id: 'p3',
    name: 'Puma Sport T-Shirt',
    price: 450.0,
    photoUrl: 'https://img.icons8.com/color/512/flutter.png',
    comments: [
      Review(
        reviewId: 'r4',
        productId: 'p3',
        date: Timestamp.now(),
        senderId: 'u4',
        message: 'Good quality but runs slightly large.',
        reactNum: 1,
        rate: 4,
      ),
      Review(
        reviewId: 'r5',
        productId: 'p3',
        date: Timestamp.now(),
        senderId: 'u5',
        message: 'Nice color and fabric.',
        reactNum: 4,
        rate: 5,
      ),
    ],
    rate: 4.5,
    reviews: 2,
    quantity: 15,
    brand: 'Puma',
    category: 'Clothing',
    description:
        'Lightweight and breathable sport T-shirt designed for performance and comfort during workouts.',
    instruction: ['Do not bleach', 'Iron on low heat'],
    productAttributeType: ProductAttributeType.both,
    stock: {
      'red': {'S': 3, 'M': 4},
      'blue': {'M': 2, 'L': 2},
    },
    date: Timestamp.now(),
  ),
];
