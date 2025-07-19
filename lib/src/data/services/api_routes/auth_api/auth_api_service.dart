import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import '../../snackbar_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api_service.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthApiService(apiService);
});

class AuthApiService {
  final ApiService _apiService;

  AuthApiService(this._apiService);

  Future<Map<String, String>> submitPhoneNumber(
      String countryCode, BuildContext context, String phone) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Completer<String> verificationIdcompleter = Completer<String>();
    Completer<String> resendTokencompleter = Completer<String>();
    log('phone:+$countryCode$phone');
    await auth.verifyPhoneNumber(
      phoneNumber: '+$countryCode$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        print(e.message.toString());

        verificationIdcompleter.complete('');
        resendTokencompleter.complete('');
      },
      codeSent: (String verificationId, int? resendToken) {
        log(verificationId);
        verificationIdcompleter.complete(verificationId);
        resendTokencompleter.complete(resendToken?.toString() ?? '');
      },
      codeAutoRetrievalTimeout: (String verificationID) {
        if (!verificationIdcompleter.isCompleted) {
          verificationIdcompleter.complete('');
        }
      },
    );
    return {
      "verificationId": await verificationIdcompleter.future,
      "resendToken": await resendTokencompleter.future
    };
  }

  void resendOTP(
      String phoneNumber, String verificationId, String resendToken) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: int.tryParse(resendToken),
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print("Resend verification failed:  e.message");
      },
      codeSent: (String verificationId, int? resendToken) {
        print("Resend verification Success");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<Map<String, dynamic>> verifyOTP(
      {required String verificationId,
      required String fcmToken,
      required String smsCode,
      required String countryCode,
      required BuildContext context}) async {
    SnackbarService snackbarService = SnackbarService();
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      User? user = userCredential.user;
      if (user != null) {
        String? idToken = await user.getIdToken();
        log("ID Token: $idToken");
        log("fcm token:$fcmToken");
        log("Verification ID:$verificationId");
        final Map<String, dynamic> tokenMap =
            await verifyUserDB(idToken ?? '', fcmToken, context, countryCode);
        log(tokenMap.toString());
        return tokenMap;
      } else {
        print("User signed in, but no user information was found.");
        return {};
      }
    } catch (e) {
      // snackbarService.showSnackBar('Wrong OTP');
      print("Failed to sign in:  e.toString()");
      return {};
    }
  }

  Future<Map<String, dynamic>> verifyUserDB(String idToken, String fcmToken,
      BuildContext context, String countryCode) async {
    SnackbarService snackbarService = SnackbarService();

    const Map<int, String> callingCodeToPrimaryCurrency = {
      // North America
      1: 'USD', // United States (Note: Canada and many Caribbean nations also use +1, but have different currencies like CAD, XCD)
      52: 'MXN', // Mexico

      // Europe
      7: 'RUB', // Russia (also Kazakhstan, but RUB is most prominent)
      30: 'EUR', // Greece
      31: 'EUR', // Netherlands
      32: 'EUR', // Belgium
      33: 'EUR', // France
      34: 'EUR', // Spain
      39: 'EUR', // Italy
      40: 'RON', // Romania
      41: 'CHF', // Switzerland
      44: 'GBP', // United Kingdom
      45: 'DKK', // Denmark
      46: 'SEK', // Sweden
      47: 'NOK', // Norway
      48: 'PLN', // Poland
      49: 'EUR', // Germany
      51: 'PEN', // Peru
      54: 'ARS', // Argentina
      55: 'BRL', // Brazil
      56: 'CLP', // Chile
      57: 'COP', // Colombia
      58: 'VES', // Venezuela
      60: 'MYR', // Malaysia
      61: 'AUD', // Australia (also Christmas Island, Cocos Islands, Norfolk Island, etc.)
      62: 'IDR', // Indonesia
      63: 'PHP', // Philippines
      64: 'NZD', // New Zealand (also Cook Islands, Niue, Tokelau)
      65: 'SGD', // Singapore
      66: 'THB', // Thailand
      81: 'JPY', // Japan
      82: 'KRW', // South Korea
      84: 'VND', // Vietnam
      86: 'CNY', // China
      90: 'TRY', // Turkey
      91: 'INR', // India (also Bhutan)
      92: 'PKR', // Pakistan
      93: 'AFN', // Afghanistan
      94: 'LKR', // Sri Lanka
      95: 'MMK', // Myanmar
      98: 'IRR', // Iran
      212: 'MAD', // Morocco
      213: 'DZD', // Algeria
      216: 'TND', // Tunisia
      218: 'LYD', // Libya
      220: 'EGP', // Egypt
      221: 'XOF', // West African CFA Franc (multiple countries)
      222: 'XOF', // West African CFA Franc (multiple countries)
      223: 'XOF', // West African CFA Franc (multiple countries)
      224: 'XAF', // Central African CFA Franc (multiple countries)
      225: 'XOF', // West African CFA Franc (multiple countries)
      226: 'XOF', // West African CFA Franc (multiple countries)
      227: 'XOF', // West African CFA Franc (multiple countries)
      228: 'XOF', // West African CFA Franc (multiple countries)
      229: 'XOF', // West African CFA Franc (multiple countries)
      230: 'ETB', // Ethiopia
      231: 'SOS', // Somalia
      232: 'ERN', // Eritrea
      233: 'GHS', // Ghana
      234: 'NGN', // Nigeria
      235: 'XAF', // Central African CFA Franc (multiple countries)
      236: 'XAF', // Central African CFA Franc (multiple countries)
      237: 'XAF', // Central African CFA Franc (multiple countries)
      238: 'XAF', // Central African CFA Franc (multiple countries)
      239: 'XAF', // Central African CFA Franc (multiple countries)
      240: 'XAF', // Central African CFA Franc (multiple countries)
      241: 'XAF', // Central African CFA Franc (multiple countries)
      242: 'XAF', // Central African CFA Franc (multiple countries
      243: 'CDF', // Democratic Republic of Congo
      244: 'AOA', // Angola
      245: 'BIF', // Burundi
      246: 'MGA', // Madagascar
      248: 'SZL', // Eswatini (Swaziland)
      249: 'KMF', // Comoros
      250: 'MWK', // Malawi
      251: 'ZMW', // Zambia
      252: 'ZWL', // Zimbabwe
      253: 'MZN', // Mozambique
      254: 'KES', // Kenya
      255: 'TZS', // Tanzania
      256: 'UGX', // Uganda
      257: 'RWF', // Rwanda
      258: 'DJF', // Djibouti
      260: 'ZAR', // South Africa (also Lesotho, Namibia, Eswatini)
      261: 'BWP', // Botswana
      262: 'NAD', // Namibia
      263: 'LSL', // Lesotho
      264: 'BWP', // Botswana
      265: 'LBP', // Lebanon
      266: 'SDG', // Sudan
      267: 'BWP', // Botswana
      268: 'XCD', // East Caribbean Dollar (multiple countries)
      269: 'KMF', // Comoros
      290: 'EUR', // Faroe Islands (uses DKK primarily)
      291: 'FJD', // Fiji
      297: 'AWG', // Aruba
      298: 'EUR', // Faroe Islands
      299: 'DKK', // Greenland
      350: 'GIP', // Gibraltar
      351: 'EUR', // Portugal
      352: 'EUR', // Luxembourg
      353: 'EUR', // Ireland
      354: 'ISK', // Iceland
      355: 'ALL', // Albania
      356: 'MTL', // Malta (now EUR)
      357: 'EUR', // Cyprus
      358: 'EUR', // Finland
      359: 'BGN', // Bulgaria
      370: 'EUR', // Lithuania
      371: 'EUR', // Latvia
      372: 'EUR', // Estonia
      373: 'MDL', // Moldova
      374: 'AMD', // Armenia
      375: 'BYN', // Belarus
      376: 'EUR', // Andorra
      377: 'EUR', // Monaco
      378: 'EUR', // San Marino
      379: 'EUR', // Vatican City
      380: 'UAH', // Ukraine
      381: 'RSD', // Serbia
      382: 'EUR', // Montenegro
      385: 'EUR', // Croatia
      386: 'EUR', // Slovenia
      387: 'BAM', // Bosnia and Herzegovina
      389: 'MKD', // North Macedonia
      420: 'CZK', // Czech Republic
      421: 'EUR', // Slovakia
      423: 'CHF', // Liechtenstein
      431: 'BAM', // Bosnia and Herzegovina
      500: 'FKP', // Falkland Islands
      501: 'BZD', // Belize
      502: 'GTQ', // Guatemala
      503: 'USD', // El Salvador
      504: 'HNL', // Honduras
      505: 'NIO', // Nicaragua
      506: 'CRC', // Costa Rica
      507: 'PAB', // Panama (also USD)
      508: 'XCD', // Saint Pierre and Miquelon
      509: 'HTG', // Haiti (also USD)
      590: 'EUR', // Guadeloupe (and other French Caribbean)
      591: 'BOB', // Bolivia
      592: 'GYD', // Guyana
      593: 'USD', // Ecuador
      594: 'EUR', // French Guiana
      595: 'PYG', // Paraguay
      596: 'EUR', // Martinique
      597: 'SRD', // Suriname
      598: 'UYU', // Uruguay
      599: 'ANG', // Curaçao (also Sint Maarten, Bonaire)
      670: 'USD', // Timor-Leste
      672: 'AUD', // Australia (external territories)
      673: 'BND', // Brunei
      674: 'AUD', // Nauru
      675: 'PGK', // Papua New Guinea
      676: 'TOP', // Tonga
      677: 'SBD', // Solomon Islands
      678: 'VUV', // Vanuatu
      679: 'FJD', // Fiji
      680: 'USD', // Palau
      681: 'XPF', // Wallis and Futuna
      682: 'NZD', // Cook Islands
      683: 'NZD', // Niue
      685: 'WST', // Samoa
      686: 'AUD', // Kiribati
      687: 'XPF', // New Caledonia
      688: 'AUD', // Tuvalu
      689: 'XPF', // French Polynesia
      690: 'NZD', // Tokelau
      691: 'USD', // Federated States of Micronesia
      692: 'USD', // Marshall Islands
      850:
          'KRW', // North Korea (KPW is official, but less used internationally)
      852: 'HKD', // Hong Kong
      853: 'MOP', // Macau
      855: 'KHR', // Cambodia
      856: 'LAK', // Laos
      859: 'VND', // Vietnam
      870: 'XDR', // Satellite Phone (Special Drawing Rights for IMF)
      878: 'XCD', // East Caribbean Dollar
      880: 'BDT', // Bangladesh
      886: 'TWD', // Taiwan
      960: 'QAR', // Qatar
      961: 'LBP', // Lebanon
      962: 'JOD', // Jordan
      963: 'SYP', // Syria
      964: 'IQD', // Iraq
      965: 'KWD', // Kuwait
      966: 'SAR', // Saudi Arabia
      967: 'YER', // Yemen
      968: 'OMR', // Oman
      970: 'ILS', // Palestine (also JOD and USD)
      971: 'AED', // United Arab Emirates
      972: 'ILS', // Israel
      973: 'BHD', // Bahrain
      974: 'QAR', // Qatar
      975: 'BTN', // Bhutan (also INR)
      976: 'MNT', // Mongolia
      977: 'NPR', // Nepal
      992: 'TJS', // Tajikistan
      993: 'TMT', // Turkmenistan
      994: 'AZN', // Azerbaijan
      995: 'GEL', // Georgia
      996: 'KGS', // Kyrgyzstan
      998: 'UZS', // Uzbekistan
    };
    String? currencyCode = callingCodeToPrimaryCurrency[int.parse(countryCode)];
    final Map<String, dynamic> body = {
      "client_token": idToken,
      "fcm": fcmToken,
      'country_code': currencyCode
    };
    log(body.toString(), name: 'requesting body');
    try {
      final response = await _apiService.post('/auth/login', body);
      if (response.success && response.data != null) {
        snackbarService
            .showSnackBar(response.data?['message'] ?? 'Login successful');
        return {
          ...(response.data?['data'] ?? {}),
          'currency': currencyCode,
        };
      } else if (response.statusCode == 400) {
        snackbarService.showSnackBar(response.message ?? 'Invalid request');
        return {};
      } else {
        snackbarService
            .showSnackBar(response.message ?? 'Something went wrong');
        return {};
      }
    } catch (e, stackTrace) {
      log('Exception during verifyUserDB: $e',
          name: 'VERIFY_USER_DB', error: e, stackTrace: stackTrace);
      snackbarService
          .showSnackBar('Unexpected error occurred. Please try again.');
      return {};
    }
  }
}
