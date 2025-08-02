import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/services/api_routes/store_api/store_api_service.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:ipaconnect/src/data/models/order_model.dart';
import 'package:ipaconnect/src/data/notifiers/cart_notifier.dart';
import 'package:ipaconnect/src/data/notifiers/saved_shipping_address_notifier.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/components/painter/dot_line_painter.dart';
import 'package:ipaconnect/src/interfaces/components/textFormFields/custom_text_form_field.dart';

// Add PaymentResultOverlay widget
class PaymentResultOverlay extends StatefulWidget {
  final bool isSuccess;
  final VoidCallback onClose;
  final String message;
  const PaymentResultOverlay({
    required this.isSuccess,
    required this.onClose,
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentResultOverlay> createState() => _PaymentResultOverlayState();
}

class _PaymentResultOverlayState extends State<PaymentResultOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _iconAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
    );
    _textAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
    );
    _confettiAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.3),
      child: Stack(
        children: [
          // Gradient background
          AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 400),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.isSuccess
                      ? [
                          kPrimaryColor.withOpacity(0.9),
                          kGreen.withOpacity(0.7)
                        ]
                      : [
                          kRed.withOpacity(0.9),
                          Colors.redAccent.withOpacity(0.7)
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Confetti for success
          if (widget.isSuccess)
            AnimatedBuilder(
              animation: _confettiAnimation,
              builder: (context, child) => CustomPaint(
                painter: _ConfettiPainter(_confettiAnimation.value),
                child: Container(),
              ),
            ),
          // Centered content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated check/cross
                AnimatedBuilder(
                  animation: _iconAnimation,
                  builder: (context, child) => CustomPaint(
                    size: const Size(100, 100),
                    painter: widget.isSuccess
                        ? _AnimatedCheckPainter(_iconAnimation.value)
                        : _AnimatedCrossPainter(_iconAnimation.value),
                  ),
                ),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _textAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(_textAnimation),
                    child: Text(
                      widget.message,
                      style: kLargeTitleSB.copyWith(
                        color: Colors.white,
                        shadows: [
                          const Shadow(color: Colors.black26, blurRadius: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _textAnimation,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: widget.isSuccess ? kPrimaryColor : kRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      elevation: 6,
                    ),
                    onPressed: widget.onClose,
                    child: Text(widget.isSuccess ? 'Continue' : 'Close',
                        style: kBodyTitleB.copyWith(
                          color: widget.isSuccess ? kPrimaryColor : kRed,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Animated checkmark painter
class _AnimatedCheckPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  _AnimatedCheckPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kGreen
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.55);
    path.lineTo(size.width * 0.45, size.height * 0.8);
    path.lineTo(size.width * 0.8, size.height * 0.3);
    final totalLength = 0.6 * size.width + 0.5 * size.width;
    final drawLength = totalLength * progress;
    final metrics = path.computeMetrics().first;
    final extractPath = metrics.extractPath(0, drawLength);
    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant _AnimatedCheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// Animated cross painter
class _AnimatedCrossPainter extends CustomPainter {
  final double progress;
  _AnimatedCrossPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kRed
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final p1 = Offset(size.width * 0.25, size.height * 0.25);
    final p2 = Offset(size.width * 0.75, size.height * 0.75);
    final p3 = Offset(size.width * 0.75, size.height * 0.25);
    final p4 = Offset(size.width * 0.25, size.height * 0.75);
    if (progress < 0.5) {
      final partial = progress / 0.5;
      canvas.drawLine(p1, Offset.lerp(p1, p2, partial)!, paint);
    } else {
      canvas.drawLine(p1, p2, paint);
      final partial = (progress - 0.5) / 0.5;
      canvas.drawLine(p3, Offset.lerp(p3, p4, partial)!, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedCrossPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

// Simple confetti painter for success
class _ConfettiPainter extends CustomPainter {
  final double progress;
  _ConfettiPainter(this.progress);
  final List<Color> colors = [
    Colors.yellow,
    Colors.pink,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orange,
    Colors.purple,
  ];
  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random(42);
    for (int i = 0; i < 30; i++) {
      final color = colors[i % colors.length];
      final x = rand.nextDouble() * size.width;
      final y = rand.nextDouble() * size.height * progress;
      final radius = 4.0 + rand.nextDouble() * 3.0;
      final paint = Paint()..color = color.withOpacity(1 - (progress * 0.3));
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class CheckoutPage extends ConsumerStatefulWidget {
  final String userCurrency;
  final double totalAmount;
  const CheckoutPage(
      {super.key, required this.userCurrency, required this.totalAmount});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage>
    with SingleTickerProviderStateMixin {
  int _currentStep = 1;
  int? _selectedAddressIndex;
  bool _showAddAddressForm = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _zipController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  bool _saveShippingAddress = true;

  ShippingAddress? _selectedShippingAddress;
  bool _isPlacingOrder = false;
  String? _orderError;
  String? _orderSuccess;

  String _cartId = '';
  bool _showResultOverlay = false;
  bool _paymentSuccess = false;
  late AnimationController _resultAnimController;
  late Animation<double> _fillAnimation;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<double> _contentScaleAnimation;

  @override
  void initState() {
    super.initState();
    _resultAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fillAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _resultAnimController, curve: Curves.easeOut),
    );
    _positionAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -2.5),
    ).animate(
      CurvedAnimation(
        parent: _resultAnimController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
      ),
    );
    _iconScaleAnimation = Tween<double>(begin: 1, end: 0.5).animate(
      CurvedAnimation(
        parent: _resultAnimController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
      ),
    );
    _contentFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _resultAnimController,
        curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
      ),
    );
    _contentScaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _resultAnimController,
        curve: const Interval(0.8, 1.0, curve: Curves.elasticOut),
      ),
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
    _resultAnimController.dispose();
    super.dispose();
  }

  Widget _buildDeliveryStep(List<ShippingAddress> savedAddresses) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select Delivery Address', style: kBodyTitleB),
              TextButton(
                onPressed: () => setState(() => _showAddAddressForm = true),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  '+ Add New',
                  style: kSmallTitleB.copyWith(
                    color: kSecondaryTextColor,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (savedAddresses.isEmpty)
            Text('No saved addresses found.', style: kSmallTitleR),
          if (savedAddresses.isNotEmpty)
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: savedAddresses.length,
                itemBuilder: (context, index) {
                  final address = savedAddresses[index];
                  final isSelected = _selectedAddressIndex == index;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() => _selectedAddressIndex = index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: kCardBackgroundColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? kPrimaryColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on,
                                  color: kPrimaryColor, size: 28),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${address.name ?? ''} - ${address.phone ?? ''}',
                                      style: kSmallTitleB,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      address.address ?? '',
                                      style: kSmallerTitleR,
                                    ),
                                    if (isSelected)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: kGreen,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'Selected',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (index != savedAddresses.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Divider(
                            color: kStrokeColor.withOpacity(0.2),
                            thickness: 1,
                            height: 1,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddressStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  textController: _nameController,
                  title: 'FullName',
                  labelText: 'Name',
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  textController: _emailController,
                  title: 'Email ',
                  labelText: 'Email',
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              CustomTextFormField(
                  textInputType: TextInputType.number,
                  backgroundColor: kCardBackgroundColor,
                  textController: _phoneController,
                  title: 'Phone ',
                  labelText: 'Phone number',
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  textController: _addressController,
                  title: 'Address',
                  labelText: 'Enter your address',
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                        textInputType: TextInputType.number,
                        backgroundColor: kCardBackgroundColor,
                        textController: _zipController,
                        labelText: 'Code',
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextFormField(
                        backgroundColor: kCardBackgroundColor,
                        textController: _cityController,
                        labelText: 'City',
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                  backgroundColor: kCardBackgroundColor,
                  textController: _stateController,
                  labelText: 'State',
                  title: 'State',
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              CustomTextFormField(
                  title: 'Country',
                  backgroundColor: kCardBackgroundColor,
                  textController: _countryController,
                  labelText: 'Country',
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
                  Text(
                    'Save shipping address',
                    style: kSmallerTitleR.copyWith(color: kSecondaryTextColor),
                  ),
                ],
              ),
            ],
          ),
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isPlacingOrder) const LoadingAnimation(),
          if (_orderSuccess != null)
            Center(
                child: Text(_orderSuccess!,
                    style: kLargeTitleSB.copyWith(color: kGreen))),
          if (_orderError != null)
            Center(
                child: Text(_orderError!,
                    textAlign: TextAlign.center,
                    style: kLargeTitleSB.copyWith(color: kRed))),
          SizedBox(
            height: 10,
          ),
          if (!_isPlacingOrder && _orderSuccess == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: customButton(
                label: 'Make Payment',
                onPressed: _placeOrder,
              ),
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
            loading: () => const Center(child: LoadingAnimation()),
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
    if (_currentStep == 2) return SizedBox.shrink();
    return customButton(
      label: label,
      onPressed: enabled
          ? () {
              if (_currentStep < 2) {
                _goToNextStep();
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

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: CustomRoundButton(
              offset: Offset(4, 0),
              iconPath: 'assets/svg/icons/arrow_back_ios.svg',
            ),
          ),
        ),
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text('Check out',
            style: kBodyTitleR.copyWith(color: kSecondaryTextColor)),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
            if (_showResultOverlay)
              Positioned.fill(
                child: PaymentResultOverlay(
                  isSuccess: _paymentSuccess,
                  message: _paymentSuccess
                      ? 'Payment Successful!'
                      : 'Payment Failed',
                  onClose: () {
                    setState(() => _showResultOverlay = false);
                    if (_paymentSuccess) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.of(context).pushNamed('MyOrdersPage');
                      });
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _goToNextStep() {
    if (_currentStep == 1 && _showAddAddressForm) {
      if (_formKey.currentState?.validate() ?? false) {
        _selectedShippingAddress = ShippingAddress(
          name: _nameController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          city: _cityController.text,
          state: _stateController.text,
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
    final cart = ref.read(cartNotifierProvider);
    final cartId = cart?.id ?? '';

    if (_selectedShippingAddress == null || cartId.isEmpty) return;
    setState(() {
      _isPlacingOrder = true;
      _orderError = null;
      _orderSuccess = null;
      _paymentSuccess = false;
      _showResultOverlay = false;
    });
    final service = ref.read(storeApiServiceProvider);
    final shippingAddressMap = _selectedShippingAddress!.toJson();
    if (shippingAddressMap['is_saved'] == null) {
      shippingAddressMap.remove('is_saved');
    }
    final data = await service.createOrder(
      cartId: cartId,
      amount: double.parse(widget.totalAmount.toStringAsFixed(2)),
      currency: widget.userCurrency,
      shippingAddress: ShippingAddress.fromJson(shippingAddressMap),
    );
    final paymentIntentClientSecret = data['data'];

    if (paymentIntentClientSecret == null ||
        paymentIntentClientSecret is! String ||
        paymentIntentClientSecret.isEmpty) {
      setState(() {
        _isPlacingOrder = false;
        _orderError = 'Failed to initiate payment. Please try again.';
      });
      return;
    }

    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'IPA CONNECT',
          appearance: PaymentSheetAppearance(
              colors: PaymentSheetAppearanceColors(
            primaryText: kWhite,
            componentBorder: kStrokeColor,
            componentDivider: kStrokeColor,
            placeholderText: kSecondaryTextColor,
            error: kRed,
            icon: kWhite,
            primary: kPrimaryColor,
            secondaryText: kSecondaryTextColor,
            componentText: kWhite,
            background: kBackgroundColor,
            componentBackground: kCardBackgroundColor,
          )),
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      setState(() {
        _isPlacingOrder = false;
        _orderSuccess = 'Order placed successfully!';
        _paymentSuccess = true;
        _showResultOverlay = true;
      });
      _resultAnimController.forward(from: 0);
    } on StripeException catch (error) {
      dev.log(name: 'post order error:', error.toString());
      setState(() {
        _isPlacingOrder = false;
        _orderError = 'Payment cancelled or failed. Please try again.';
        _paymentSuccess = false;
        _showResultOverlay = true;
      });
      _resultAnimController.forward(from: 0);
    } catch (error) {
      dev.log(error.toString(), name: 'STRIPE INIT ERROR');
      setState(() {
        _isPlacingOrder = false;
        _orderError = 'An error occurred. Please try again.';
        _paymentSuccess = false;
        _showResultOverlay = true;
      });
      _resultAnimController.forward(from: 0);
    }
  }

  Widget _buildStepper() {
    List<String> steps = ['Delivery', 'Address', 'Payment'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Dotted line across the whole stepper, centered
              Positioned.fill(
                top: 18, // Center the line with the circles (36/2 - 1)
                child: Row(
                  children: List.generate(steps.length * 2 - 1, (i) {
                    if (i.isOdd) {
                      return Expanded(
                        child: CustomPaint(
                          size: const Size(double.infinity, 2),
                          painter: DottedLinePainter(),
                        ),
                      );
                    } else {
                      return const SizedBox(width: 36);
                    }
                  }),
                ),
              ),
              // Step circles only
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(steps.length * 2 - 1, (i) {
                    if (i.isOdd) {
                      return const Expanded(child: SizedBox());
                    } else {
                      int index = i ~/ 2;
                      bool isCompleted = _currentStep > index;
                      bool isCurrent = _currentStep == index;
                      Color borderColor = isCompleted
                          ? Color(0xFF1E3A81)
                          : (isCurrent ? Color(0xFF1E3A81) : Color(0xFF1E3A81));
                      Color fillColor = isCompleted
                          ? Color(0xFF1E3A81)
                          : (isCurrent
                              ? Color(0xFFF7F7F7).withOpacity(.7)
                              : Colors.transparent);
                      return Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: borderColor,
                            width: 2,
                          ),
                          color: fillColor,
                          boxShadow: isCompleted
                              ? [
                                  BoxShadow(
                                    color: kPrimaryColor.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                            child: isCompleted
                                ? Icon(Icons.check, color: kPrimaryColor)
                                : isCurrent
                                    ? Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF1E3A81),
                                        ),
                                      )
                                    : null),
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Step labels below, centered under each circle
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: List.generate(steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                return const Expanded(child: SizedBox());
              } else {
                int index = i ~/ 2;
                bool isCompleted = _currentStep > index;
                bool isCurrent = _currentStep == index;
                return Expanded(
                  child: Center(
                    child: Text(
                      steps[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isCompleted || isCurrent ? kPrimaryColor : kGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }
            }),
          ),
        ),
      ],
    );
  }
}
