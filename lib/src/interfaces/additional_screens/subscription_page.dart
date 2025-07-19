import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/services/api_routes/subscription_api/subscription_api_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:ipaconnect/src/interfaces/additional_screens/payment_success_page.dart';
import 'package:ipaconnect/src/data/utils/currency_converted.dart';

class SubscriptionPage extends ConsumerStatefulWidget {
  final String userCurrency;
  const SubscriptionPage({super.key, required this.userCurrency});

  @override
  ConsumerState<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends ConsumerState<SubscriptionPage> {
  bool _isPaying = false;
  String? _paymentError;
  String? _paymentSuccess;
  String _paymentMethod = 'online';

  // Converted values
  double? _convertedRegFee;
  double? _convertedMonthlyFee;
  double? _convertedDurationFee;
  double? _convertedVat;
  double? _convertedTotal;
  bool _isConverting = false;

  Future<void> _payNow(int total, Map<String, dynamic> subscription) async {
    setState(() {
      _isPaying = true;
      _paymentError = null;
      _paymentSuccess = null;
    });
    try {
      // Use converted total and user currency for Stripe payment
      if (_convertedTotal == null) {
        setState(() {
          _paymentError = 'Currency conversion not ready. Please wait.';
          _isPaying = false;
        });
        return;
      }
      final result = await ref.read(createSubscriptionPaymentProvider(
        subscriptionId: subscription['_id'] ?? '',
        amount: _convertedTotal!, // Pass converted amount
        currency: widget.userCurrency, // Pass user currency
        paymentMethod: _paymentMethod,
      ).future);
      if (result == null) {
        if (!mounted) return;
        setState(() {
          _paymentError = 'Failed to initiate payment. Please try again.';
          _isPaying = false;
        });
        return;
      }
      // Stripe payment
      final paymentIntentClientSecret = result['data'];
      if (paymentIntentClientSecret == null ||
          paymentIntentClientSecret is! String ||
          paymentIntentClientSecret.isEmpty) {
        if (!mounted) return;
        setState(() {
          _paymentError = 'Failed to get payment intent. Please try again.';
          _isPaying = false;
        });
        return;
      }
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
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
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: 'IPA CONNECT',
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      if (!mounted) return;
      setState(() {
        _paymentSuccess = 'Payment successful!';
        _isPaying = false;
      });
      // Navigate to PaymentSuccessPage with converted values
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        // Only navigate if all converted values are available
        if (_convertedTotal != null && _convertedRegFee != null && _convertedVat != null && _convertedMonthlyFee != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PaymentSuccessPage(
              transactionId: result['transaction_id']?.toString() ?? 'N/A',
              transactionDate:
                  DateFormat('dd/MM/yyyy | hh:mm a').format(DateTime.now()),
                amount: _convertedMonthlyFee!.toStringAsFixed(2),
                fees: _convertedVat!.toStringAsFixed(2),
                total: _convertedTotal!.toStringAsFixed(2),
                currency: widget.userCurrency,
            ),
          ),
        );
        } else {
          // Optionally show a loading or error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Currency conversion not ready. Please wait.')),
          );
        }
      });
    } on StripeException catch (e) {
      log(e.toString());
      if (!mounted) return;
      setState(() {
        _paymentError = 'Payment cancelled or failed. Please try again.';
        _isPaying = false;
      });
    } catch (e) {
      log(e.toString());
      if (!mounted) return;
      setState(() {
        _paymentError = 'An error occurred. Please try again.';
        _isPaying = false;
      });
    }
  }

  Future<void> _convertAllPrices({
    required int regFee,
    required int monthlyFee,
    required int durationFee,
    required double vat,
    required int total,
    required String fromCurrency,
  }) async {
    setState(() {
      _isConverting = true;
    });
    final results = await Future.wait([
      convertCurrency(
          from: fromCurrency,
          to: widget.userCurrency,
          amount: regFee.toDouble()),
      convertCurrency(
          from: fromCurrency,
          to: widget.userCurrency,
          amount: monthlyFee.toDouble()),
      convertCurrency(
          from: fromCurrency,
          to: widget.userCurrency,
          amount: durationFee.toDouble()),
      convertCurrency(from: fromCurrency, to: widget.userCurrency, amount: vat),
      convertCurrency(
          from: fromCurrency,
          to: widget.userCurrency,
          amount: total.toDouble()),
    ]);
    setState(() {
      _convertedRegFee = results[0];
      _convertedMonthlyFee = results[1];
      _convertedDurationFee = results[2];
      _convertedVat = results[3];
      _convertedTotal = results[4];
      _isConverting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncSubscription = ref.watch(fetchSubscriptionProvider);
    return asyncSubscription.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xFF00031A),
        body: Center(child: LoadingAnimation()),
      ),
      error: (error, stackTrace) => const Scaffold(
        backgroundColor: Color(0xFF00031A),
        body: Center(
            child: Text('Failed to load subscription info',
                style: TextStyle(color: Colors.white))),
      ),
      data: (subscription) {
        if (subscription == null) {
          return const SizedBox.shrink();
        }
        final bool isRegistered = subscription['is_registered'] ?? true;
        final int registrationFee = subscription['registration_fee'] ?? 0;
        final int feePerMonth = subscription['fee_per_month'] ?? 0;
        final String currency = subscription['currency'] ?? '';
        final List<String> features =
            (subscription['features'] as List<dynamic>?)?.cast<String>() ?? [];
        final String subscriptionId = subscription['_id'] ?? '';
        // Pricing Details logic
        final now = DateTime.now();
        final int currentMonth = now.month;
        final int monthsLeft = 12 - currentMonth + 1; // Including current month
        final String monthRange = '${DateFormat.MMMM().format(now)} – December';
        final int durationFee = feePerMonth * monthsLeft;
        final int regFee = registrationFee;
        final int vatBase = (isRegistered ? 0 : regFee) + durationFee;
        final double vat = vatBase * 0.05;
        final int total = vatBase + vat.round();

        // Currency conversion for all prices
        if ((_convertedTotal == null ||
                _convertedMonthlyFee == null ||
                _convertedDurationFee == null ||
                _convertedVat == null ||
                _convertedRegFee == null) &&
            !_isConverting) {
          _convertAllPrices(
            regFee: regFee,
            monthlyFee: feePerMonth,
            durationFee: durationFee,
            vat: vat,
            total: total,
            fromCurrency: currency,
          );
        }
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: const Color(0xFF00031A), // Add background color
                child: Image.asset(
                  'assets/pngs/subcription_bg.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      SvgPicture.asset(
                          'assets/svg/icons/subscription_shield.svg'),
                      const SizedBox(height: 16),
                      Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Color(0xFFFFFFFF),
                              Color(0xFFE4E5FF),
                              Color(0xFF355BBB),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(
                              Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                          child: Text(
                            'IPA SUBSCRIPTION',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .white, // This will be overridden by the ShaderMask
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Show only user's currency for all prices
                      _isConverting || _convertedTotal == null
                          ? const LoadingAnimation()
                          : Text(
                              '${widget.userCurrency} ${_convertedTotal!.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: _PricingDetailsSection(
                          isRegistered: isRegistered,
                          registrationFee: _convertedRegFee,
                          durationFee: _convertedDurationFee,
                          monthsLeft: monthsLeft,
                          monthRange: monthRange,
                          monthlyFee: _convertedMonthlyFee,
                          vat: _convertedVat,
                          total: _convertedTotal,
                          currency: widget.userCurrency,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x00355BBB),
                              const Color(0xFF355BBB).withOpacity(.21),
                            ],
                            stops: [0, 1.0],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: kStrokeColor),
                        ),
                        child: Stack(
                          children: [
                            // Randomly placed stars
                            Positioned(
                              top: 8,
                              left: 12,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 18,
                                height: 18,
                              ),
                            ),
                            Positioned(
                              top: 40,
                              right: 24,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 14,
                                height: 14,
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 40,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 12,
                                height: 12,
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 16,
                                height: 16,
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 80,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 10,
                                height: 10,
                              ),
                            ),
                            Positioned(
                              top: 70,
                              right: 60,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 13,
                                height: 13,
                              ),
                            ),
                            Positioned(
                              bottom: 40,
                              left: 20,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 11,
                                height: 11,
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              right: 40,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 15,
                                height: 15,
                              ),
                            ),
                            Positioned(
                              top: 100,
                              left: 30,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 9,
                                height: 9,
                              ),
                            ),
                            Positioned(
                              bottom: 60,
                              right: 20,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 12,
                                height: 12,
                              ),
                            ),
                            // More small stars for a denser effect
                            Positioned(
                              top: 12,
                              left: 120,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 7,
                                height: 7,
                              ),
                            ),
                            Positioned(
                              top: 55,
                              left: 60,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 8,
                                height: 8,
                              ),
                            ),
                            Positioned(
                              top: 90,
                              right: 30,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 6,
                                height: 6,
                              ),
                            ),
                            Positioned(
                              bottom: 22,
                              right: 70,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 7,
                                height: 7,
                              ),
                            ),
                            Positioned(
                              bottom: 55,
                              left: 90,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 8,
                                height: 8,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 110,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 6,
                                height: 6,
                              ),
                            ),
                            Positioned(
                              top: 110,
                              right: 50,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 7,
                                height: 7,
                              ),
                            ),
                            Positioned(
                              top: 130,
                              left: 60,
                              child: SvgPicture.asset(
                                'assets/svg/icons/subscription_star.svg',
                                width: 9,
                                height: 9,
                              ),
                            ),
                            // Card content
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: features.isNotEmpty
                                  ? features.map(_benefit).toList()
                                  : [
                                      _benefit(
                                          'Business Networking & Product Listings'),
                                      _benefit('IPA Connect card'),
                                      _benefit('View job profiles'),
                                      _benefit(
                                          'Access your verified membership proof.'),
                                      _benefit(
                                          'Access to IPA Store & merchandise'),
                                      _benefit(
                                          'Get the latest IPA insights and stories.'),
                                      _benefit(
                                          'Join social and community initiatives.'),
                                      _benefit(
                                          'Attend premium events and webinars.'),
                                      _benefit(
                                          'Member-only discounts and promotional access'),
                                    ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Valid through Dec 31, 2025 – Renewal required to maintain premium access.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                color: const Color(0xFF00063F).withOpacity(0.86),
                elevation: 8, // Optional: adds shadow
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 16, top: 8),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_paymentError != null) ...[
                          const SizedBox(height: 12),
                          Text(_paymentError!,
                              style: const TextStyle(color: Colors.red)),
                          SizedBox(
                            height: 10,
                          )
                        ],
                        if (_paymentSuccess != null) ...[
                          const SizedBox(height: 12),
                          Text(_paymentSuccess!,
                              style: const TextStyle(color: Colors.green)),
                          SizedBox(
                            height: 10,
                          )
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: customButton(
                            isLoading: _isPaying,
                            label: _isPaying ? 'Processing...' : 'Pay Now',
                            onPressed: _isPaying
                                ? null
                                : () => _payNow(total, subscription),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _benefit(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            SvgPicture.asset('assets/svg/icons/subscription_tick.svg'),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      );
}

class _PricingDetailsSection extends StatefulWidget {
  final bool isRegistered;
  final double? registrationFee;
  final double? durationFee;
  final int monthsLeft;
  final String monthRange;
  final double? monthlyFee;
  final double? vat;
  final double? total;
  final String currency;

  const _PricingDetailsSection({
    required this.isRegistered,
    required this.registrationFee,
    required this.durationFee,
    required this.monthsLeft,
    required this.monthRange,
    required this.monthlyFee,
    required this.vat,
    required this.total,
    required this.currency,
    Key? key,
  }) : super(key: key);

  @override
  State<_PricingDetailsSection> createState() => _PricingDetailsSectionState();
}

class _PricingDetailsSectionState extends State<_PricingDetailsSection>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _arrowController;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      upperBound: 0.5,
      lowerBound: 0.0,
    );
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _arrowController.forward();
      } else {
        _arrowController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/icons/subscription_pricing_details.svg',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Pricing Details',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 4),
                    AnimatedBuilder(
                      animation: _arrowController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _arrowController.value * 3.1416 * 2,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                            size: 18,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0x00355BBB),
                  const Color(0xFF355BBB).withOpacity(.21),
                ],
                stops: [0, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kStrokeColor),
            ),
            child: Stack(
              children: [
                // Star decorations (copy from features container)
                Positioned(
                  top: 8,
                  left: 12,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 18,
                    height: 18,
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 24,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 14,
                    height: 14,
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 40,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 12,
                    height: 12,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 16,
                    height: 16,
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 80,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 10,
                    height: 10,
                  ),
                ),
                Positioned(
                  top: 70,
                  right: 60,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 13,
                    height: 13,
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: 20,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 11,
                    height: 11,
                  ),
                ),
                Positioned(
                  bottom: 30,
                  right: 40,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 15,
                    height: 15,
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 30,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 9,
                    height: 9,
                  ),
                ),
                Positioned(
                  bottom: 60,
                  right: 20,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 12,
                    height: 12,
                  ),
                ),
                // More small stars for a denser effect
                Positioned(
                  top: 12,
                  left: 120,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 7,
                    height: 7,
                  ),
                ),
                Positioned(
                  top: 55,
                  left: 60,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 8,
                    height: 8,
                  ),
                ),
                Positioned(
                  top: 90,
                  right: 30,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 6,
                    height: 6,
                  ),
                ),
                Positioned(
                  bottom: 22,
                  right: 70,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 7,
                    height: 7,
                  ),
                ),
                Positioned(
                  bottom: 55,
                  left: 90,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 8,
                    height: 8,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 110,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 6,
                    height: 6,
                  ),
                ),
                Positioned(
                  top: 110,
                  right: 50,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 7,
                    height: 7,
                  ),
                ),
                Positioned(
                  top: 130,
                  left: 60,
                  child: SvgPicture.asset(
                    'assets/svg/icons/subscription_star.svg',
                    width: 9,
                    height: 9,
                  ),
                ),
                // Card content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!widget.isRegistered)
                      _pricingRow(
                          'Registration Fee',
                          widget.registrationFee == null
                              ? 'loading'
                              : '${widget.currency} ${widget.registrationFee!.toStringAsFixed(2)}'),
                    _pricingRow(
                        'Monthly Fee',
                        widget.monthlyFee == null
                            ? 'loading'
                            : '${widget.currency} ${widget.monthlyFee!.toStringAsFixed(2)}'),
                    _pricingRow(
                      'Duration',
                      widget.durationFee == null
                          ? 'loading'
                          : '${widget.monthsLeft} Months (${widget.monthRange}): ${widget.currency} ${widget.durationFee!.toStringAsFixed(2)}',
                    ),
                    _pricingRow(
                        'VAT (5%)',
                        widget.vat == null
                            ? 'loading'
                            : '${widget.currency} ${widget.vat!.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }

  Widget _pricingRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              softWrap: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: value == 'loading'
                ? const LoadingAnimation()
                : Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
