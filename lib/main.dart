import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';


late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Barcode Scanner"),
              Icon(Icons.qr_code)
            ],
          ),
        ),
        body: AppPage(),
      ),
    );
  }
}

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {

  late CameraController cameraController;
  String result = "Scan";
  bool canUse = true;
  CameraImage? img;
  dynamic barcodeScanner;


  @override
  void initState() {
    super.initState();

    final List<BarcodeFormat> formats = [BarcodeFormat.all];
    barcodeScanner = BarcodeScanner(formats: formats);

    cameraController = CameraController(_cameras[0], ResolutionPreset.high);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }

      cameraController.startImageStream((image) => {
        if(canUse){
          canUse = false,
          img = image,
          doScanning()
        }
      });

      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }


  Future<void> doScanning() async {
    InputImage inputImage = getInputImage();
    final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

    result = "";
    for (Barcode barcode in barcodes) {
      final BarcodeType type = barcode.type;
      final Rect? boundingBox = barcode.boundingBox;
      final String? displayValue = barcode.displayValue;
      final String? rawValue = barcode.rawValue;

      // See API reference for complete list of supported types
      switch (type) {
        case BarcodeType.wifi:
          BarcodeWifi barcodeWifi = barcode.value as BarcodeWifi;
          result = "Wifi:- " + barcodeWifi.password!;
          break;
        case BarcodeType.url:
          BarcodeUrl barcodeUrl = barcode.value as BarcodeUrl;
          result = "URL:- " + barcodeUrl.url!;
          break;
        default:
          print("");
      }

      setState(() {
        result;
      });
    }
    canUse = true;
  }

  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in img!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(img!.width.toDouble(), img!.height.toDouble());

    final camera = _cameras[0];
    final imageRotation =
    InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    // if (imageRotation == null) return;

    final inputImageFormat =
    InputImageFormatValue.fromRawValue(img!.format.raw);
    // if (inputImageFormat == null) return null;

    final planeData = img!.planes.map(
          (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation!,
      inputImageFormat: inputImageFormat!,
      planeData: planeData,
    );

    final inputImage =
    InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    return inputImage;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 400,
              child: CameraPreview(cameraController),
            ),
            Text(
              result,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),
            )
          ],
        ),
      ),
    );
  }
}
