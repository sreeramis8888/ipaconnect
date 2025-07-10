// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:intl/intl.dart';
// import 'package:ipaconnect/src/data/constants/color_constants.dart';
// import 'package:ipaconnect/src/data/constants/style_constants.dart';
// import 'package:ipaconnect/src/data/models/user_model.dart';
// import 'package:ipaconnect/src/data/services/navigation_service.dart';
// import 'package:ipaconnect/src/interfaces/components/animations/glowing_animated_avatar.dart';
// import 'package:ipaconnect/src/interfaces/components/painter/dot_line_painter.dart';

// import '../../components/custom_widgets/contant_row.dart';

// class ProfilePage extends ConsumerWidget {
//   final UserModel user;
//   const ProfilePage({super.key, required this.user});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     NavigationService navigationService = NavigationService();
//     // final userAsync = ref.watch(userProvider);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // userAsync.whenOrNull(data: (user) {
//       //   log(user.status ?? '');
//       //   if (user.status == 'trial') {
//       //     showDialog(
//       //       context: context,
//       //       builder: (_) => const PremiumDialog(),
//       //     );
//       //   }
//       // });
//     });
//     // final designations = user.company!
//     //     .map((i) => i.designation)
//     //     .where((d) => d != null && d.isNotEmpty)
//     //     .map((d) => d!)
//     //     .toList();

//     // final companyNames = user.company!
//     //     .map((i) => i.name)
//     //     .where((n) => n != null && n.isNotEmpty)
//     //     .map((n) => n!)
//     //     .toList();
//     // String joinedDate = DateFormat('dd/MM/yyyy').format(user.createdAt!);
//     // Map<String, String> levelData = extractLevelDetails(user.level ?? '');
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         centerTitle: true,
//         backgroundColor: Color(0xFF030920),
//         title: Text(
//           'Profile',
//           style: kSubHeadingL,
//         ),
//       ),
//       backgroundColor: Color(0xFF030920),
//       body: Container(
//         decoration: const BoxDecoration(),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Column(
//                     children: [
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(26.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   border:
//                                       Border.all(color: kStrokeColor, width: 2),
//                                   borderRadius: BorderRadius.circular(15),
//                                   gradient: LinearGradient(
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                     colors: [
//                                       Color(0xFF064896),
//                                       kCardBackgroundColor
//                                     ],
//                                   ),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     Stack(
//                                       children: [
//                                         // if (user.id != id)
//                                         Positioned(
//                                           top: 10,
//                                           right: 10,
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                                 color: Color(0xFFF7F7F7)
//                                                     .withOpacity(.2),
//                                                 borderRadius:
//                                                     BorderRadius.circular(30)),
//                                             child: IconButton(
//                                               icon: Icon(
//                                                 Icons.remove_red_eye,
//                                                 color: kWhite,
//                                               ),
//                                               onPressed: () {
//                                                 navigationService.pushNamed(
//                                                     'ProfilePreview',
//                                                     arguments: user);
//                                               },
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: double.infinity,
//                                           child: Column(
//                                             children: [
//                                               SizedBox(height: 30),
//                                               GlowingAnimatedAvatar(
//                                                 imageUrl: user.image,
//                                                 defaultAvatarAsset:
//                                                     'assets/svg/icons/dummy_person_large.svg',
//                                                 size: 90,
//                                                 glowColor: kWhite,
//                                                 borderColor: kWhite,
//                                                 borderWidth: 3.0,
//                                               ),
//                                               Text(
//                                                 user.name ?? '',
//                                                 style: kHeadTitleSB,
//                                               ),
//                                               const SizedBox(height: 5),
//                                               Column(
//                                                 children: [
//                                                   if (user.profession != null)
//                                                     Text('${user.profession}'),
//                                                   SizedBox(height: 20),
//                                                   Container(
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 10,
//                                                         vertical: 6),
//                                                     decoration: BoxDecoration(
//                                                       color: Color(0xFFF7F7F7)
//                                                           .withOpacity(.2),
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                     ),
//                                                     child: IntrinsicWidth(
//                                                       child: Row(
//                                                         mainAxisSize:
//                                                             MainAxisSize.min,
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceBetween,
//                                                         children: [
//                                                           Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .only(
//                                                                       left: 10),
//                                                               child: SizedBox(
//                                                                 width: 30,
//                                                                 height: 30,
//                                                                 child: SvgPicture
//                                                                     .asset(
//                                                                         'assets/svg/icons/ipa_logo.svg'),
//                                                               )),
//                                                           const SizedBox(
//                                                               width: 10),
//                                                           Text(
//                                                               'Member ID: ${user.memberId}',
//                                                               style: kSmallerTitleB
//                                                                   .copyWith(
//                                                                       color:
//                                                                           kWhite)),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(height: 20),
//                                                   Container(
//                                                     height: 1,
//                                                     child: CustomPaint(
//                                                       size: const Size(
//                                                           double.infinity, 1),
//                                                       painter:
//                                                           DottedLinePainter(),
//                                                     ),
//                                                   ),
//                                                   Column(
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .only(
//                                                           top: 10,
//                                                           left: 15,
//                                                           right: 15,
//                                                         ),
//                                                         child: Column(
//                                                           children: [
//                                                             ContactRow(
//                                                                 icon:
//                                                                     Icons.phone,
//                                                                 text:
//                                                                     user.phone ??
//                                                                         ''),
//                                                             if (user.email !=
//                                                                     '' &&
//                                                                 user.email !=
//                                                                     null)
//                                                               const SizedBox(
//                                                                   height: 10),
//                                                             if (user.email !=
//                                                                     '' &&
//                                                                 user.email !=
//                                                                     null)
//                                                               ContactRow(
//                                                                   icon: Icons
//                                                                       .email,
//                                                                   text:
//                                                                       user.email ??
//                                                                           ''),
//                                                             if (user.location !=
//                                                                     '' &&
//                                                                 user.location !=
//                                                                     null)
//                                                               const SizedBox(
//                                                                   height: 10),
//                                                             if (user.location !=
//                                                                     '' &&
//                                                                 user.location !=
//                                                                     null)
//                                                               ContactRow(
//                                                                   icon: Icons
//                                                                       .location_on,
//                                                                   text:
//                                                                       user.location ??
//                                                                           ''),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       const SizedBox(
//                                                           height: 20),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           // captureAndShareOrDownloadWidgetScreenshot(context);
//                         },
//                         child: Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: kCardBackgroundColor,
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Icon(
//                               Icons.share,
//                               color: kPrimaryColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 40),
//                       GestureDetector(
//                         onTap: () {
//                           navigationService.pushNamed('Card', arguments: user);
//                         },
//                         child: Container(
//                           width: 70,
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: kCardBackgroundColor,
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: Icon(
//                               Icons.qr_code,
//                               color: kPrimaryColor,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(
//                     height: 30,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
