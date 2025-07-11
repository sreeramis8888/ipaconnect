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
import 'package:ipaconnect/src/interfaces/components/animations/animated_logo.dart';
import 'package:ipaconnect/src/interfaces/components/buttons/custom_round_button.dart';
import 'package:ipaconnect/src/interfaces/components/loading/loading_indicator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../data/services/navigation_service.dart';
import '../../data/services/snackbar_service.dart';
import '../../data/utils/secure_storage.dart';
import '../components/buttons/custom_button.dart';
import 'package:ipaconnect/src/data/services/api_routes/auth_api/auth_api_service.dart';
final countryCodeProvider = StateProvider<String?>((ref) => '91');
class PhoneNumberScreen extends ConsumerStatefulWidget {
  const PhoneNumberScreen({
    super.key,
  });

  @override
  ConsumerState<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends ConsumerState<PhoneNumberScreen> {
  late TextEditingController _mobileController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: AnimatedSvgLogoPresets.subtle(
                  assetPath: 'assets/svg/ipa_login_logo.svg',
                  size: 100,
                ),
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
                            if (!_isDisposed) {
                              ref.read(countryCodeProvider.notifier).state =
                                  value.dialCode;
                            }
                          },
                          initialCountryCode: 'IN',
                          onChanged: (PhoneNumber phone) {
                            if (!_isDisposed) {
                              print(phone.completeNumber);
                            }
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
    if (_isDisposed) return;
    
    SnackbarService snackbarService = SnackbarService();
    final countryCode = ref.watch(countryCodeProvider);
    FocusScope.of(context).unfocus();
    ref.read(loadingProvider.notifier).startLoading();
    try {
      String phone = _mobileController.text.trim();
      if (countryCode == '971') {
        if (phone.length != 9) {
          snackbarService.showSnackBar('Please Enter valid mobile number');
        } else {
          final authApiService = ref.watch(authApiServiceProvider);
          final data = await authApiService.submitPhoneNumber(
              countryCode == '971' ? '9710' : countryCode ?? '91',
              context,
              phone);
          final verificationId = data['verificationId'];
          final resendToken = data['resendToken'];
          if (verificationId != null && verificationId.isNotEmpty && !_isDisposed) {
            log('Otp Sent successfully');
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OTPScreen(countryCode: countryCode??'',
                  fullPhone: '+$countryCode${phone}',
                  verificationId: verificationId,
                  resendToken: resendToken ?? '',
                ),
              ),
            );
          } else {
            snackbarService.showSnackBar('Failed');
          }
        }
      } else {
        if (phone.length != 10) {
          snackbarService.showSnackBar('Please Enter valid mobile number');
        } else {
          final authApiService = ref.watch(authApiServiceProvider);
          final data = await authApiService.submitPhoneNumber(
              countryCode == '971' ? '9710' : countryCode ?? '91',
              context,
              phone);
          final verificationId = data['verificationId'];
          final resendToken = data['resendToken'];
          if (verificationId != null && verificationId.isNotEmpty && !_isDisposed) {
            log('Otp Sent successfully');
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OTPScreen(countryCode: countryCode??'',
                  fullPhone: '+$countryCode${phone}',
                  verificationId: verificationId,
                  resendToken: resendToken ?? '',
                ),
              ),
            );
          } else {
            snackbarService.showSnackBar('Failed');
          }
        }
      }
    } catch (e) {
      log(e.toString());
      snackbarService.showSnackBar('Failed');
    } finally {
      if (!_isDisposed) {
        ref.read(loadingProvider.notifier).stopLoading();
      }
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
  final String fullPhone;
  final String countryCode;
  const OTPScreen({
    required this.fullPhone,
    required this.resendToken,
    required this.countryCode,
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

  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void startTimer() {
    if (!mounted) return;
    
    _isButtonDisabled = true;
    _start = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
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
    if (!mounted) return;
    
    startTimer();
    final authApiService = ref.watch(authApiServiceProvider);
    authApiService.resendOTP(
        widget.fullPhone, widget.verificationId, widget.resendToken);
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
            const SizedBox(height: 40),
            // Add back button
     Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: CustomRoundButton(
                offset: Offset(4, 0),
                iconPath: 'assets/svg/icons/arrow_back_ios.svg',
              ),
            ),
          ),
            const SizedBox(height: 30),
            Center(
              child: AnimatedSvgLogoPresets.subtle(
                  assetPath: 'assets/svg/ipa_login_logo.svg'),
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
    if (!mounted) return;
    
    ref.read(loadingProvider.notifier).startLoading();
    SnackbarService snackbarService = SnackbarService();
    try {
      String phone = widget.fullPhone.trim();
      final countryCode = ref.watch(countryCodeProvider);
      String otp = _otpController.text.trim();
      if (otp.length != 6) {
        snackbarService.showSnackBar('Please enter a valid 6 digit OTP');
        return;
      }
      final authApiService = ref.read(authApiServiceProvider);
      // You need to get the FCM token from your notification service or storage
      String fcmToken = await SecureStorage.read('fcmToken') ?? '';
      final responseMap = await authApiService.verifyOTP(
        countryCode: countryCode??'',
        verificationId: widget.verificationId,
        fcmToken: fcmToken,
        smsCode: otp,
        context: context,
      );
      
      if (!mounted) return;
      
      String savedToken = responseMap['token'] ?? '';
      String savedId = responseMap['userId'] ?? '';
      if (savedToken.isNotEmpty && savedId.isNotEmpty) {
        await SecureStorage.write('token', savedToken);
        await SecureStorage.write('id', savedId);
        // Optionally set global token/id if needed
        // token = savedToken;
        // id = savedId;
        log('savedToken: $savedToken');
        log('savedId: $savedId');
        // No name dialog, just navigate to next screen
        NavigationService().pushNamedReplacement('RegistrationPage',
            arguments: '+${countryCode ?? '91'}$phone');
      } else {
        snackbarService.showSnackBar('Wrong OTP', type: SnackbarType.error);
      }
    } catch (e) {
      log(e.toString());
      snackbarService.showSnackBar('Wrong OTP', type: SnackbarType.error);
    } finally {
      if (mounted) {
        ref.read(loadingProvider.notifier).stopLoading();
      }
    }
  }
}
