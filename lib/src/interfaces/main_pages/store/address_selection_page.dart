// import 'package:flutter/material.dart';
// import 'package:ipaconnect/src/data/constants/color_constants.dart';
// import 'package:ipaconnect/src/data/constants/style_constants.dart';
// import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';

// class AddressSelectionPage extends StatefulWidget {
//   const AddressSelectionPage({Key? key}) : super(key: key);

//   @override
//   State<AddressSelectionPage> createState() => _AddressSelectionPageState();
// }

// class _AddressSelectionPageState extends State<AddressSelectionPage> {
//   int selectedAddressIndex = -1;
  
//   final List<Map<String, dynamic>> addresses = [
//     {
//       'name': 'John Doe',
//       'phone': '+91 98765 43210',
//       'address': '123 Main Street, Apartment 4B',
//       'city': 'Mumbai',
//       'state': 'Maharashtra',
//       'pincode': '400001',
//       'isDefault': true,
//     },
//     {
//       'name': 'Jane Smith',
//       'phone': '+91 98765 43211',
//       'address': '456 Park Avenue, Floor 2',
//       'city': 'Delhi',
//       'state': 'Delhi',
//       'pincode': '110001',
//       'isDefault': false,
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: kBackgroundColor,
//         elevation: 0,
//         title: Text('Select Address', style: kHeadTitleSB),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: kWhite),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pushNamed(context, 'AddAddressPage');
//             },
//             child: Text('Add New', style: kBodyTitleSB.copyWith(color: kPrimaryColor)),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: addresses.length,
//               itemBuilder: (context, index) {
//                 final address = addresses[index];
//                 final isSelected = selectedAddressIndex == index;
                
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: kCardBackgroundColor,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: isSelected ? kPrimaryColor : Colors.transparent,
//                       width: 2,
//                     ),
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       setState(() {
//                         selectedAddressIndex = index;
//                       });
//                     },
//                     borderRadius: BorderRadius.circular(12),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Row(
//                         children: [
//                           // Radio button
//                           Container(
//                             width: 20,
//                             height: 20,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: isSelected ? kPrimaryColor : kGrey,
//                                 width: 2,
//                               ),
//                             ),
//                             child: isSelected
//                                 ? Container(
//                                     margin: const EdgeInsets.all(4),
//                                     decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: kPrimaryColor,
//                                     ),
//                                   )
//                                 : null,
//                           ),
//                           const SizedBox(width: 16),
//                           // Address details
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(address['name'], style: kBodyTitleSB),
//                                     const SizedBox(width: 8),
//                                     if (address['isDefault'])
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                                         decoration: BoxDecoration(
//                                           color: kGreen,
//                                           borderRadius: BorderRadius.circular(4),
//                                         ),
//                                         child: Text('Default', style: kSmallerTitleR),
//                                       ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(address['phone'], style: kSmallerTitleR),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   '${address['address']}, ${address['city']}, ${address['state']} - ${address['pincode']}',
//                                   style: kBodyTitleR,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // Edit button
//                           IconButton(
//                             icon: const Icon(Icons.edit_outlined, color: kGrey),
//                             onPressed: () {
//                               // TODO: Navigate to edit address page
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Bottom action buttons
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: kCardBackgroundColor,
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             ),
//             child: Column(
//               children: [
//                 customButton(
//                   label: 'Deliver to this Address',
//                   onPressed: selectedAddressIndex >= 0
//                       ? () {
//                           // TODO: Navigate to payment/order confirmation
//                         }
//                       : null,
//                 ),
//                 const SizedBox(height: 12),
//                 customButton(
//                   label: 'Add New Address',
//                   onPressed: () {
//                     Navigator.pushNamed(context, 'AddAddressPage');
//                   },
//                   buttonColor: Colors.transparent,
//                   sideColor: kPrimaryColor,
//                   labelColor: kPrimaryColor,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// } 