export 'user_status_sreens.dart';
import 'package:flutter/material.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/onboarding/login.dart';

// ACTIVE (Placeholder)
class UserActivePage extends StatelessWidget {
  const UserActivePage({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // Not shown, handled in main_page
  }
}

// INACTIVE
class UserInactivePage extends StatelessWidget {
  const UserInactivePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: kRed,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.block, color: Colors.red, size: 48),
              const SizedBox(height: 10),
              const Text(
                "Your account is Inactive",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Please contact Admin for more information",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // TODO: Add logout logic
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PhoneNumberScreen()),
                  );
                },
                child: const Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// DELETED
class UserDeletedPage extends StatelessWidget {
  const UserDeletedPage({super.key});
  @override
  Widget build(BuildContext context) {
    // Immediately navigate to PhoneNumberScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PhoneNumberScreen()),
      );
    });
    return const Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(child: LoadingAnimation()),
    );
  }
}

// AWAITING PAYMENT
class UserAwaitingPaymentPage extends StatelessWidget {
  const UserAwaitingPaymentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.yellow[50],
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Colors.amber,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.payment, color: Colors.amber, size: 48),
              const SizedBox(height: 10),
              const Text(
                "Payment Required",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Please complete your payment to activate your account.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // TODO: Add payment navigation logic
                },
                child: const Text('Pay Now', style: TextStyle(color: Colors.amber)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PhoneNumberScreen()),
                  );
                },
                child: const Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// REJECTED
class UserRejectedPage extends StatelessWidget {
  const UserRejectedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: kRed,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cancel, color: Colors.red, size: 48),
              const SizedBox(height: 10),
              const Text(
                "Your registration was rejected",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Please contact support for more information.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PhoneNumberScreen()),
                  );
                },
                child: const Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SUSPENDED
class UserSuspendedPage extends StatelessWidget {
  const UserSuspendedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: kRed,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.block, color: Colors.red, size: 48),
              const SizedBox(height: 10),
              const Text(
                "Your account is Suspended",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Please contact Admin for more information",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PhoneNumberScreen()),
                  );
                },
                child: const Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
