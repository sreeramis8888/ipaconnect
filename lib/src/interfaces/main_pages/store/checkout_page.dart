import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/data/services/api_routes/store_api_service.dart';
import 'package:ipaconnect/src/data/models/order_model.dart';
import 'package:ipaconnect/src/data/notifiers/cart_notifier.dart';
import 'package:ipaconnect/src/data/notifiers/saved_shipping_address_notifier.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage>
    with SingleTickerProviderStateMixin {
  int _currentStep = 1; // Start at Address step
  int? _selectedAddressIndex;
  bool _showAddAddressForm = false; // Only show address form when Add New is clicked

  // Address form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController(); // Add state controller
  final _countryController = TextEditingController();
  bool _saveShippingAddress = true;

  // Order state
  ShippingAddress? _selectedShippingAddress;
  bool _isPlacingOrder = false;
  String? _orderError;
  String? _orderSuccess;

  String _cartId = '';
  double _amount = 0.0;
  String _currency = 'USD';

  @override
  void initState() {
    super.initState();
    // No need to fetch cart details here, will use Riverpod in build
  }

  Widget _buildDeliveryStep(List<ShippingAddress> savedAddresses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Delivery Address', style: kLargeTitleSB),
        const SizedBox(height: 16),
        if (savedAddresses.isEmpty)
          Center(child: Text('No saved addresses found.', style: kBodyTitleR)),
        if (savedAddresses.isNotEmpty)
          ...List.generate(savedAddresses.length, (index) {
            final address = savedAddresses[index];
            final isSelected = _selectedAddressIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedAddressIndex = index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kCardBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? kPrimaryColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: kPrimaryColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.name ?? 'No Name',
                            style: kBodyTitleSB,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            address.address ?? '',
                            style: kBodyTitleR,
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: kGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('Selected',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                  ],
                ),
              ),
            );
          }),
        const SizedBox(height: 8),
        Row(
          children: [
            TextButton(
              onPressed: () => setState(() => _showAddAddressForm = true),
              child: Text('Add New',
                  style: kBodyTitleSB.copyWith(color: kPrimaryColor)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressStep() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name', style: kBodyTitleSB),
            const SizedBox(height: 4),
            _buildTextField(_nameController, 'Name',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            Text('Email', style: kBodyTitleSB),
            const SizedBox(height: 4),
            _buildTextField(_emailController, 'Email',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            Text('Phone Number', style: kBodyTitleSB),
            const SizedBox(height: 4),
            _buildTextField(_phoneController, 'Phone Number',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            Text('Address', style: kBodyTitleSB),
            const SizedBox(height: 4),
            _buildTextField(_addressController, 'Enter your address',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildTextField(_zipController, 'Code',
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null)),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildTextField(_cityController, 'City',
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null)),
              ],
            ),
            const SizedBox(height: 12),
            Text('State', style: kBodyTitleSB),
            const SizedBox(height: 4),
            _buildTextField(_stateController, 'State',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            Text('Country', style: kBodyTitleSB),
            const SizedBox(height: 4),
            _buildTextField(_countryController, 'Select',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _saveShippingAddress,
                  onChanged: (val) =>
                      setState(() => _saveShippingAddress = val ?? true),
                  activeColor: kPrimaryColor,
                ),
                const SizedBox(width: 8),
                const Text('Save shipping address'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {String? Function(String?)? validator}) {
    return Container(
      decoration: BoxDecoration(
        color: kCardBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        style: kBodyTitleR,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPaymentStep() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isPlacingOrder) const CircularProgressIndicator(),
          if (_orderSuccess != null)
            Text(_orderSuccess!, style: kLargeTitleSB.copyWith(color: kGreen)),
          if (_orderError != null)
            Text(_orderError!, style: kLargeTitleSB.copyWith(color: kRed)),
          if (!_isPlacingOrder && _orderSuccess == null)
            customButton(
              label: 'Make Payment',
              onPressed: _placeOrder,
            ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    final asyncSavedAddresses = ref.watch(savedShippingAddressNotifierProvider);

    switch (_currentStep) {
      case 1:
        if (_showAddAddressForm) {
          return _buildAddressStep();
        } else {
          return asyncSavedAddresses.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (addresses) => _buildDeliveryStep(addresses),
          );
        }
      case 2:
        return _buildPaymentStep();
      default:
        return Container();
    }
  }

  Widget _buildBottomButton() {
    String label = _currentStep == 2 ? 'Make Payment' : 'Next';
    bool enabled = true;
    if (_currentStep == 0)
      enabled = _selectedAddressIndex != null || _showAddAddressForm;
    if (_currentStep == 2) enabled = !_isPlacingOrder && _orderSuccess == null;
    return customButton(
      label: label,
      onPressed: enabled
          ? () {
              if (_currentStep < 2) {
                _goToNextStep();
              } else {
                _placeOrder();
              }
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    final cart = ref.read(cartNotifierProvider);
    _cartId = cart?.id ?? '';
    _amount = cartNotifier.getCartTotal();
    _currency = 'USD'; // Or get from cart if available

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text('Check out', style: kHeadTitleSB),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kWhite),
          onPressed: _goToPreviousStep,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildStepper(),
            const SizedBox(height: 24),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: _buildStepContent(),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildBottomButton(),
            ),
          ],
        ),
      ),
    );
  }

  void _goToNextStep() {
    if (_currentStep == 1 && _showAddAddressForm) {
      // Validate and store new address
      if (_formKey.currentState?.validate() ?? false) {
        _selectedShippingAddress = ShippingAddress(
          name: _nameController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          city: _cityController.text,
          state: _stateController.text, // Save state
          country: _countryController.text,
          pincode: _zipController.text,
          isSaved: _saveShippingAddress,
        );
        setState(() {
          _showAddAddressForm = false;
          _currentStep++;
        });
      }
    } else if (_currentStep == 1 && _selectedAddressIndex != null) {
      // Use selected saved address
      final addresses =
          ref.read(savedShippingAddressNotifierProvider).maybeWhen(
                data: (addresses) => addresses,
                orElse: () => [],
              );
      if (_selectedAddressIndex != null && addresses.isNotEmpty) {
        _selectedShippingAddress = addresses[_selectedAddressIndex!];
      }
      setState(() {
        _currentStep++;
      });
    } else if (_currentStep == 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _placeOrder() async {
    final cartNotifier = ref.read(cartNotifierProvider.notifier);
    final cart = ref.read(cartNotifierProvider);
    final cartId = cart?.id ?? '';
    final amount = cartNotifier.getCartTotal();
    if (_selectedShippingAddress == null || cartId.isEmpty) return;
    setState(() {
      _isPlacingOrder = true;
      _orderError = null;
      _orderSuccess = null;
    });
    final service = ref.read(storeApiServiceProvider);
    // Expecting createOrder to return payment_intent with client_secret
    final response = await service.createOrder(
      cartId: cartId,
      amount: amount,
      currency: _currency,
      shippingAddress: _selectedShippingAddress!,
    );
    String? clientSecret;
    if (response is Map && response['payment_intent'] != null) {
      // If service returns the whole payment_intent object
      clientSecret = response['payment_intent']['client_secret'];
    } else if (response is String) {
      // If service returns just the client_secret
      clientSecret = response;
    }
    if (clientSecret != null) {
      try {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'IPA Connect',
          ),
        );
        await Stripe.instance.presentPaymentSheet();
        setState(() {
          _orderSuccess = 'Order placed successfully!';
        });
      } catch (e) {
        setState(() {
          _orderError = 'Payment failed or cancelled.';
        });
      }
    } else {
      setState(() {
        _orderError = 'Failed to initiate payment.';
      });
    }
    setState(() {
      _isPlacingOrder = false;
    });
  }

  Widget _buildStepper() {
    List<String> steps = ['Delivery', 'Address', 'Payment'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Draw connecting line
          int leftStep = (i - 1) ~/ 2;
          bool isActive = _currentStep > leftStep;
          return Expanded(
            child: Container(
              height: 2,
              color: isActive ? kPrimaryColor : kGrey,
            ),
          );
        } else {
          int index = i ~/ 2;
          bool isActive = _currentStep >= index;
          bool isCompleted = index == 0; // Delivery always ticked
          return Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive ? kPrimaryColor : kGrey,
                    width: 2,
                  ),
                  color: isActive
                      ? kPrimaryColor.withOpacity(0.2)
                      : Colors.transparent,
                ),
                child: Center(
                  child: (isCompleted || isActive)
                      ? Icon(Icons.check, color: kPrimaryColor)
                      : Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kGrey,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                steps[index],
                style: TextStyle(
                  color: isActive ? kPrimaryColor : kGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _zipController.dispose();
    _cityController.dispose();
    _stateController.dispose(); // Dispose new controller
    _countryController.dispose();
    super.dispose();
  }
}
