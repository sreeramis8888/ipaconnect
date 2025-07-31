// import 'package:flutter/material.dart';

// class CameraPreviewWidget extends StatelessWidget {
//   final VoidCallback onCapture;
//   final VoidCallback onClose;

//   const CameraPreviewWidget({
//     Key? key,
//     required this.onCapture,
//     required this.onClose,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           color: Colors.black,
//           child: const Center(
//             child: Icon(Icons.camera_alt, color: Colors.white, size: 100),
//           ),
//         ),
//         Positioned(
//           top: 40,
//           left: 20,
//           child: IconButton(
//             icon: const Icon(Icons.close, color: Colors.white, size: 32),
//             onPressed: onClose,
//           ),
//         ),
//         Positioned(
//           bottom: 40,
//           left: 0,
//           right: 0,
//           child: Center(
//             child: GestureDetector(
//               onTap: onCapture,
//               child: Container(
//                 width: 70,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Colors.white, width: 6),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
