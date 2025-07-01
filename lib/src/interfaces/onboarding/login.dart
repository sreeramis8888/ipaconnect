import 'dart:async';
import 'dart:developer';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipaconnect/src/data/constants/color_constants.dart';
import 'package:ipaconnect/src/data/constants/style_constants.dart';
import 'package:ipaconnect/src/data/notifiers/loading_notifier.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../data/services/navigation_service.dart';
import '../../data/services/snackbar_service.dart';
import '../../data/utils/secure_storage.dart';
import '../components/buttons/custom_button.dart';
import 'package:ipaconnect/src/data/services/api_routes/auth_api/auth_api_service.dart';

TextEditingController _mobileController = TextEditingController();
TextEditingController _otpController = TextEditingController();

final countryCodeProvider = StateProvider<String?>((ref) => '91');

class PhoneNumberScreen extends ConsumerWidget {
  const PhoneNumberScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);
    final countryCode = ref.watch(countryCodeProvider);

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              Center(
                child: SvgPicture.asset('assets/svg/ipa_login_logo.svg'),
              ),
              const SizedBox(height: 70),
              Text(
                'Login',
                style: kHeadTitleB.copyWith(color: kWhite),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Please enter your mobile number',
                            style: kBodyTitleL.copyWith(color: kWhite)),
                        const SizedBox(height: 20),
                        IntlPhoneField(
                          validator: (phone) {
                            if (phone!.number.length > 9) {
                              if (phone.number.length > 10) {
                                return 'Phone number cannot exceed 10 digits';
                              }
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: kWhite,
                            letterSpacing: 8,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                          controller: _mobileController,
                          disableLengthCheck: true,
                          showCountryFlag: true,
                          cursorColor: kWhite,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kInputFieldcolor,
                            hintText: 'Enter your phone number',
                            hintStyle: kSmallTitleR.copyWith(
                                color: kWhite, letterSpacing: 0.5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: kInputFieldcolor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: kInputFieldcolor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  const BorderSide(color: kInputFieldcolor),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 10.0,
                            ),
                          ),
                          onCountryChanged: (value) {
                            ref.read(countryCodeProvider.notifier).state =
                                value.dialCode;
                          },
                          initialCountryCode: 'IN',
                          onChanged: (PhoneNumber phone) {
                            print(phone.completeNumber);
                          },
                          flagsButtonPadding:
                              const EdgeInsets.only(left: 10, right: 10.0),
                          showDropdownIcon: true,
                          dropdownIcon: Icon(
                            Icons.arrow_drop_down_outlined,
                            color: kWhite,
                          ),
                          dropdownIconPosition: IconPosition.trailing,
                          dropdownTextStyle: const TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('A 6 digit verification code will be sent',
                            style: kSmallTitleR.copyWith(
                                color: Color(0xFFAEB9E1))),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 10),
                          child: SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: customButton(
                              label: 'Send OTP',
                              onPressed: isLoading
                                  ? null
                                  : () => _handleOtpGeneration(context, ref),
                              fontSize: 16,
                              isLoading: isLoading,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleOtpGeneration(BuildContext context, WidgetRef ref) async {
    SnackbarService snackbarService = SnackbarService();
    final countryCode = ref.watch(countryCodeProvider);
    FocusScope.of(context).unfocus();
    ref.read(loadingProvider.notifier).startLoading();

    try {
      String phone = _mobileController.text.trim();
      String fullPhone = '+${countryCode ?? '91'}$phone';
      if (countryCode == '971') {
        if (phone.length != 9) {
          snackbarService.showSnackBar('Please Enter valid mobile number');
          return;
        }
      } else {
        if (phone.length != 10) {
          snackbarService.showSnackBar('Please Enter valid mobile number');
          return;
        }
      }
      final authApiService = ref.watch(authApiServiceProvider);
      final otp = await authApiService.login(fullPhone);
      if (otp != null && otp.isNotEmpty) {
        log('Otp Sent successfully');
        log(otp, name: 'AUTH');
        Navigator.of(context).pushReplacement(
          _createFadeRoute(
            OTPScreen(
              phone: phone,
              verificationId: '',
              resendToken: '',
            ),
          ),
        );
      } else {
        snackbarService.showSnackBar('Failed to send OTP',
            type: SnackbarType.warning);
      }
    } catch (e) {
      log(e.toString());
      snackbarService.showSnackBar('Failed to send OTP');
    } finally {
      ref.read(loadingProvider.notifier).stopLoading();
    }
  }

  Route _createFadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}

class OTPScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String resendToken;
  final String phone;
  const OTPScreen({
    required this.phone,
    required this.resendToken,
    super.key,
    required this.verificationId,
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  Timer? _timer;

  int _start = 59;

  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isButtonDisabled = true;
    _start = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isButtonDisabled = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void resendCode() {
    startTimer();

    // resendOTP(widget.phone, widget.verificationId, widget.resendToken);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            Center(
              child: SvgPicture.asset('assets/svg/ipa_login_logo.svg'),
            ),
            const SizedBox(height: 70),
            Text(
              'Verify OTP',
              style: kHeadTitleB.copyWith(color: kWhite),
            ),
            SizedBox(
              height: 40,
            ),
            Text('Enter the OTP to verify',
                style: kSmallerTitleM.copyWith(fontSize: 16, color: kWhite)),
            const SizedBox(height: 10),
            PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              textStyle: const TextStyle(
                color: kWhite,
                fontSize: 25,
                fontWeight: FontWeight.w300,
                letterSpacing: 5.0,
              ),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 55,
                fieldWidth: 50,
                selectedColor: kPrimaryColor,
                activeColor: const Color.fromARGB(255, 232, 226, 226),
                inactiveColor: kInputFieldcolor,
                activeFillColor: kInputFieldcolor,
                selectedFillColor: kInputFieldcolor,
                inactiveFillColor: kInputFieldcolor,
              ),
              animationDuration: const Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              controller: _otpController,
              onChanged: (value) {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    _isButtonDisabled
                        ? 'Resend OTP in $_start seconds'
                        : 'Enter your OTP',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: _isButtonDisabled ? kGrey : kWhite),
                  ),
                ),
                GestureDetector(
                  onTap: _isButtonDisabled ? null : resendCode,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      _isButtonDisabled ? '' : 'Resend Code',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _isButtonDisabled ? kGrey : kRed),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: SizedBox(
                height: 47,
                width: double.infinity,
                child: customButton(
                  label: 'Verify',
                  onPressed: isLoading
                      ? null
                      : () => _handleOtpVerification(context, ref),
                  fontSize: 16,
                  isLoading: isLoading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleOtpVerification(
      BuildContext context, WidgetRef ref) async {
    ref.read(loadingProvider.notifier).startLoading();
    SnackbarService snackbarService = SnackbarService();
    try {
      String phone = widget.phone.trim();
      final countryCode = ref.watch(countryCodeProvider);
      String fullPhone = '+${countryCode ?? '91'}$phone';
      String otp = _otpController.text.trim();
      if (otp.length != 6) {
        snackbarService.showSnackBar('Please enter a valid 6 digit OTP');
        return;
      }
      final authApiService = ref.watch(authApiServiceProvider);
      final token = await authApiService.verifyOtp(fullPhone, otp);
      if (token != null && token.isNotEmpty) {
        await SecureStorage.write('token', token);

        log('savedToken: $token');

        snackbarService.showSnackBar('Login successful');

        NavigationService().pushNamedReplacement('RegistrationPage');
      } else {
        snackbarService.showSnackBar('Wrong OTP', type: SnackbarType.error);
      }
    } catch (e) {
      log(e.toString());
      snackbarService.showSnackBar('Wrong OTP', type: SnackbarType.error);
    } finally {
      ref.read(loadingProvider.notifier).stopLoading();
    }
  }
}
