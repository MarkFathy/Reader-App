// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:qrscanner/core/router/router.dart';
// import 'package:qrscanner/features/extract_image/extract_image_view.dart';
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
//   bool _isPermissionGranted = false;
//
//   late final Future<void> _future;
//   CameraController? _cameraController;
//
//   final textRecognizer = TextRecognizer();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//
//     _future = _requestCameraPermission();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _stopCamera();
//     _cameraController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (_cameraController == null || !_cameraController!.value.isInitialized) {
//       return;
//     }
//
//     if (state == AppLifecycleState.inactive) {
//       _stopCamera();
//     } else if (state == AppLifecycleState.resumed &&
//         _cameraController != null &&
//         _cameraController!.value.isInitialized) {
//       _startCamera();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: _future,
//         builder: (context, snapshot) {
//           return Stack(
//             children: [
//               if (_isPermissionGranted)
//                 FutureBuilder<List<CameraDescription>>(
//                   future: availableCameras(),
//                   builder: (context, snapshot) {
//                     if (snapshot.hasData) {
//                       _initCameraController(snapshot.data!);
//
//                       return Center(child: CameraPreview(_cameraController!));
//                     } else {
//                       return const LinearProgressIndicator();
//                     }
//                   },
//                 ),
//               Scaffold(
//                 backgroundColor:
//                     _isPermissionGranted ? Colors.transparent : null,
//                 body: _isPermissionGranted
//                     ? Column(
//                         children: [
//                           Expanded(
//                             child: Container(),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.only(bottom: 30.0),
//                             child: Center(
//                               child: ElevatedButton(
//                                 onPressed: _scanImage,
//                                 child: const Text('Scan'),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     : Center(
//                         child: Container(
//                           padding:
//                               const EdgeInsets.only(left: 24.0, right: 24.0),
//                           child: const Text(
//                             'Camera permission denied',
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Future<void> _requestCameraPermission() async {
//     final status = await Permission.camera.request();
//     _isPermissionGranted = status == PermissionStatus.granted;
//   }
//
//   void _startCamera() {
//     if (_cameraController != null) {
//       _cameraSelected(_cameraController!.description);
//     }
//   }
//
//   void _stopCamera() {
//     if (_cameraController != null) {
//       _cameraController?.dispose();
//     }
//   }
//
//   void _initCameraController(List<CameraDescription> cameras) {
//     if (_cameraController != null) {
//       return;
//     }
//
//     // Select the first rear camera.
//     CameraDescription? camera;
//     for (var i = 0; i < cameras.length; i++) {
//       final CameraDescription current = cameras[i];
//       if (current.lensDirection == CameraLensDirection.back) {
//         camera = current;
//         break;
//       }
//     }
//
//     if (camera != null) {
//       _cameraSelected(camera);
//     }
//   }
//
//   Future<void> _cameraSelected(CameraDescription camera) async {
//     _cameraController = CameraController(
//       camera,
//       ResolutionPreset.max,
//       enableAudio: false,
//     );
//
//     await _cameraController!.initialize();
//     await _cameraController!.setFlashMode(FlashMode.off);
//
//     if (!mounted) {
//       return;
//     }
//     setState(() {});
//   }
//
//   Future<void> _scanImage() async {
//     if (_cameraController == null) return;
//
//     final navigator = Navigator.of(context);
//
//     try {
//       final pictureFile = await _cameraController!.takePicture();
//
//       final file = File(pictureFile.path);
//
//       final inputImage = InputImage.fromFile(file);
//       final recognizedText = await textRecognizer.processImage(inputImage);
//       // print(recognizedText.text);
//
//       navigator.pop([recognizedText,file]);
//       // }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('An error occurred when scanning text'),
//         ),
//       );
//     }
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera_overlay/flutter_camera_overlay.dart';
import 'package:flutter_camera_overlay/model.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';


class ScannerCameraOverlay extends StatefulWidget {
  const ScannerCameraOverlay({Key? key}) : super(key: key);

  @override
  _ScannerCameraOverlayState createState() => _ScannerCameraOverlayState();
}

class _ScannerCameraOverlayState extends State<ScannerCameraOverlay> {
  OverlayFormat format = OverlayFormat.cardID3;
  int tab = 0;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CameraDescription>?>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No camera found',
                    style: TextStyle(color: Colors.black),
                  ));
            }
            return CameraOverlay(
                snapshot.data!.first, CardOverlay.byFormat(format),
                    (XFile file) async {
                  final navigator = Navigator.of(context);
                  final inputImage = InputImage.fromFile(File(file.path));
                  final recognizedText =
                  await textRecognizer.processImage(inputImage);
                  navigator.pop([recognizedText,File(file.path)]);
                  // showDialog(
                  //   context: context,
                  //   barrierColor: Colors.black,
                  //   builder: (context) {
                  //     CardOverlay overlay = CardOverlay.byFormat(format);
                  //     return AlertDialog(
                  //       actionsAlignment: MainAxisAlignment.center,
                  //       backgroundColor: Colors.black,
                  //       title: const Text('Capture',
                  //           style: TextStyle(color: Colors.white),
                  //           textAlign: TextAlign.center),
                  //       actions: [
                  //         OutlinedButton(
                  //             onPressed: () => Navigator.of(context).pop(),
                  //             child: const Icon(Icons.close))
                  //       ],
                  //       content: SizedBox(
                  //         width: double.infinity,
                  //         child: AspectRatio(
                  //           aspectRatio: overlay.ratio!,
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //                 image: DecorationImage(
                  //               fit: BoxFit.fitWidth,
                  //               alignment: FractionalOffset.center,
                  //               image: FileImage(
                  //                 File(file.path),
                  //               ),
                  //             )),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                },
                info:
                'Position your card within the rectangle and ensure the image is perfectly readable.',
                label: 'Scanning Cards');
          } else {
            return const Align(
                alignment: Alignment.center,
                child: Text(
                  'Fetching cameras',
                  style: TextStyle(color: Colors.black),
                ));
          }
        },
      ),
    );
  }
}
