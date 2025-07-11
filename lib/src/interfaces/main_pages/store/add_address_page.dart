// import 'package:flutter/material.dart';
// import 'package:ipaconnect/src/data/constants/color_constants.dart';
// import 'package:ipaconnect/src/data/constants/style_constants.dart';
// import 'package:ipaconnect/src/interfaces/components/buttons/custom_button.dart';

// class AddAddressPage extends StatefulWidget {
//   const AddAddressPage({Key? key}) : super(key: key);

//   @override
//   State<AddAddressPage> createState() => _AddAddressPageState();
// }

// class _AddAddressPageState extends State<AddAddressPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _stateController = TextEditingController();
//   final _pincodeController = TextEditingController();
//   bool _isDefaultAddress = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _pincodeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackgroundColor,
//       appBar: AppBar(
//         backgroundColor: kBackgroundColor,
//         elevation: 0,
//         title: Text('Add New Address', style: kHeadTitleSB),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: kWhite),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           children: [
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Contact Information', style: kLargeTitleSB),
//                     const SizedBox(height: 16),
                    
//                     // Full Name
//                     Container(
//                       decoration: BoxDecoration(
//                         color: kCardBackgroundColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TextFormField(
//                         controller: _nameController,
//                         style: kBodyTitleR,
//                         decoration: const InputDecoration(
//                           labelText: 'Full Name',
//                           labelStyle: TextStyle(color: kGrey),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your full name';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 16),
                    
//                     // Phone Number
//                     Container(
//                       decoration: BoxDecoration(
//                         color: kCardBackgroundColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TextFormField(
//                         controller: _phoneController,
//                         style: kBodyTitleR,
//                         keyboardType: TextInputType.phone,
//                         decoration: const InputDecoration(
//                           labelText: 'Phone Number',
//                           labelStyle: TextStyle(color: kGrey),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your phone number';
//                           }
//                           if (value.length < 10) {
//                             return 'Please enter a valid phone number';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 24),
                    
//                     Text('Address Information', style: kLargeTitleSB),
//                     const SizedBox(height: 16),
                    
//                     // Address Line
//                     Container(
//                       decoration: BoxDecoration(
//                         color: kCardBackgroundColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TextFormField(
//                         controller: _addressController,
//                         style: kBodyTitleR,
//                         maxLines: 3,
//                         decoration: const InputDecoration(
//                           labelText: 'Address Line',
//                           labelStyle: TextStyle(color: kGrey),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your address';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 16),
                    
//                     // City
//                     Container(
//                       decoration: BoxDecoration(
//                         color: kCardBackgroundColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TextFormField(
//                         controller: _cityController,
//                         style: kBodyTitleR,
//                         decoration: const InputDecoration(
//                           labelText: 'City',
//                           labelStyle: TextStyle(color: kGrey),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your city';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 16),
                    
//                     // State
//                     Container(
//                       decoration: BoxDecoration(
//                         color: kCardBackgroundColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TextFormField(
//                         controller: _stateController,
//                         style: kBodyTitleR,
//                         decoration: const InputDecoration(
//                           labelText: 'State',
//                           labelStyle: TextStyle(color: kGrey),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your state';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 16),
                    
//                     // Pincode
//                     Container(
//                       decoration: BoxDecoration(
//                         color: kCardBackgroundColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: TextFormField(
//                         controller: _pincodeController,
//                         style: kBodyTitleR,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(
//                           labelText: 'Pincode',
//                           labelStyle: TextStyle(color: kGrey),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your pincode';
//                           }
//                           if (value.length != 6) {
//                             return 'Please enter a valid 6-digit pincode';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 24),
                    
//                     // Default Address Toggle
//                     Container(
//                       decoration: BoxDecoration(
//                         color: kCardBackgroundColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: SwitchListTile(
//                         title: Text('Set as default address', style: kBodyTitleR),
//                         value: _isDefaultAddress,
//                         onChanged: (value) {
//                           setState(() {
//                             _isDefaultAddress = value;
//                           });
//                         },
//                         activeColor: kPrimaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Bottom action button
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: kCardBackgroundColor,
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//               ),
//               child: customButton(
//                 label: 'Save Address',
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     // TODO: Save address to backend
//                     Navigator.pop(context);
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 