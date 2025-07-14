// import 'package:flutter/material.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:ipaconnect/src/interfaces/additional_screens/no_internet_page.dart';

// class ConnectivityWrapper extends StatelessWidget {
//   final Widget child;
//   const ConnectivityWrapper({required this.child, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<ConnectivityResult>(
//       stream: Connectivity().onConnectivityChanged,
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return child;
//         final hasInternet = snapshot.data != ConnectivityResult.none;
//         return hasInternet ? child : const NoInternetPage();
//       },
//     );
//   }
// } 