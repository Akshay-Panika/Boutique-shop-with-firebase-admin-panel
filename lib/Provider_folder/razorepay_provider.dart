import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayProvider extends ChangeNotifier {
  late Razorpay _razorpay;

  RazorpayProvider() {
    initializeRazorpay();
  }

  void initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle success
    print("Payment Successful: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle error
    print("Payment Error: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    print("External Wallet: ${response.walletName}");
  }

   startPayment(double amount) {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY', // Replace with your Razorpay API Key
      'amount': (amount * 100).toInt(),
      'name': 'Your Shop',
      'description': 'Payment for products',
      'prefill': {
        'contact': '9876543210', // User's phone number
        'email': 'example@example.com', // User's email
      },
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error starting Razorpay: $e");
    }
  }
}