import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/models/order.dart';
import '../../../../core/models/order.dart' as checkout_state;
import '../../../../core/models/selectedProduct.dart';
import '../../../cart/presentation/manager/cart_cubit.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CartCubit cartCubit;

  CheckoutCubit({required this.cartCubit}) : super(const CheckoutState());

  void updateName(String value) => _updateState(name: value);
  void updatePhone(String value) => _updateState(phone: value);
  void updateAddress(String value) => _updateState(address: value);
  void updateCity(String value) => _updateState(city: value);
  void updateCardNumber(String value) => _updateState(cardNumber: value);
  void updateExpiryDate(String value) => _updateState(expiryDate: value);
  void updateCvv(String value) => _updateState(cvv: value);
  void updateCardholderName(String value) => _updateState(cardholderName: value);
  void updatePaymentMethod(checkout_state.PaymentMethod method) => _updateState(paymentMethod: method);

  void _updateState({
    String? name,
    String? phone,
    String? address,
    String? city,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
    String? cardholderName,
    checkout_state.PaymentMethod? paymentMethod,
  }) {
    final newState = state.copyWith(
      name: name,
      phone: phone,
      address: address,
      city: city,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cvv: cvv,
      cardholderName: cardholderName,
      paymentMethod: paymentMethod,
    );

    emit(newState.copyWith(isCheckoutValid: _validateCheckout(newState)));
  }

  bool _validateCheckout(CheckoutState s) {
    final hasAddress = s.name.isNotEmpty && s.phone.isNotEmpty && s.address.isNotEmpty && s.city.isNotEmpty;
    if (s.paymentMethod == checkout_state.PaymentMethod.cash) {
      return hasAddress;
    } else {
      final hasCard = s.cardNumber.isNotEmpty && s.expiryDate.isNotEmpty && s.cvv.isNotEmpty && s.cardholderName.isNotEmpty;
      return hasAddress && hasCard;
    }
  }

  Future<MyOrder?> confirmOrder() async {
    if (!state.isCheckoutValid) return null;

    emit(state.copyWith(isSubmitting: true));

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(state.copyWith(isSubmitting: false));
      return null;
    }

    final orderData = {
      'userId': user.uid,
      'products': cartCubit.state.products.map((e) => e.toMap()).toList(),
      'totalPrice': cartCubit.total,
      'date': Timestamp.now(),
      'paymentMethod': state.paymentMethod.toString().split('.').last,
      'status': 'processing',
      'address': [state.name, state.phone, state.address, state.city],
    };
    // final orderx= MyOrder(
    //     id: user.uid,
    //     userId: user.uid,
    //     products: cartCubit.state.products.map((e) => e.toMap()).toList(),
    //     totalPrice: cartCubit.total,
    //     date: Timestamp.now(),
    //     status: MyOrder.Status,
    //     paymentMethod: state.paymentMethod!,
    //     address:  [state.name, state.phone, state.address, state.city])

    try {
      final docRef = await FirebaseFirestore.instance.collection('orders').add(orderData);

      final myOrder = MyOrder.fromMap({
        ...orderData,
      }, id: docRef.id);

      await cartCubit.clearCart();

      emit(state.copyWith(isSubmitting: false));
      return myOrder;
    } catch (e) {
      emit(state.copyWith(isSubmitting: false));
      rethrow;
    }
  }


  Stream<int> getUserOrdersCountStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value(0);

    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<MyOrder>> getUserOrdersStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // print("No user logged in");
      return Stream.value([]);
    }

    // print("Fetching orders for user: ${user.uid}");

    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      // print("Orders snapshot received: ${snapshot.docs.length} documents");

      final orders = snapshot.docs.map((doc) {
        final data = doc.data();
        // print("Order data: ${doc.id} -> $data");

        try {
          return MyOrder(
            id: doc.id,
            userId: data['userId'] ?? '',
            products: data['products'] != null
                ? List.from(data['products']).map((e) =>
                ProductSelected.fromMap(Map<String, dynamic>.from(e))).toList()
                : [],

            totalPrice: (data['totalPrice'] ?? 0).toDouble(),
            date: data['date'] ?? Timestamp.now(),
            status: Status.values.firstWhere(
                  (s) => s.toString().split('.').last.toLowerCase() ==
                  ((data['status'] ?? 'processing').toString().toLowerCase()),
              orElse: () => Status.processing,
            ),
            paymentMethod: PaymentMethod.values.firstWhere(
                  (p) => p.toString().split('.').last.toLowerCase() ==
                  ((data['paymentMethod'] ?? 'cash').toString().toLowerCase()),
              orElse: () => PaymentMethod.cash,
            ),
            address: data['address'] != null ? List<String>.from(data['address']) : [],
          );
        } catch (e) {
          // print("Error parsing order ${doc.id}: $e");
          rethrow;
        }
      }).toList();
      return orders;
    }).handleError((error) {
      return <MyOrder>[];
    });
  }

  Stream<List<MyOrder>>? getLastThreeOrdersStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('date', descending: true)
        .limit(3)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        final data = doc.data();

        try {
          return MyOrder(
            id: doc.id,
            userId: data['userId'] ?? '',
            products: data['products'] != null
                ? List.from(data['products']).map((e) =>
                ProductSelected.fromMap(Map<String, dynamic>.from(e))).toList()
                : [],

            totalPrice: (data['totalPrice'] ?? 0).toDouble(),
            date: data['date'] ?? Timestamp.now(),
            status: Status.values.firstWhere(
                  (s) => s.toString().split('.').last.toLowerCase() ==
                  ((data['status'] ?? 'processing').toString().toLowerCase()),
              orElse: () => Status.processing,
            ),
            paymentMethod: PaymentMethod.values.firstWhere(
                  (p) => p.toString().split('.').last.toLowerCase() ==
                  ((data['paymentMethod'] ?? 'cash').toString().toLowerCase()),
              orElse: () => PaymentMethod.cash,
            ),
            address: data['address'] != null ? List<String>.from(data['address']) : [],
          );
        } catch (e) {
          rethrow;
        }
      }).toList();
      return orders;
    }).handleError((error) {
      return <MyOrder>[];
    });
  }
}