// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QrcodeScanner extends StatefulWidget {
  const QrcodeScanner({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<QrcodeScanner> createState() => _QrcodeScannerState();
}

class _QrcodeScannerState extends State<QrcodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;
  String scannedSchedId = ''; // Store the scanned schedId

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: isProcessing
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('Processing scan...'),
                      ],
                    )
                  : scannedSchedId.isNotEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Scanned Data: $scannedSchedId',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Scan Date: ${_getFormattedDateTime()}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        )
                      : const Text('Point your camera at a QR Code'),
            ),
          ),
        ],
      ),
    );
  }

  // Function to format the scan date and time
  String _getFormattedDateTime() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) return; // Prevent multiple scans
      setState(() {
        isProcessing = true;
      });

      try {
        final scannedText = scanData.code; // Ensure scannedText is not null
        if (scannedText == null) {
          _showError('Invalid QR Code: Data is null.');
          setState(() => isProcessing = false);
          return;
        }

        final schedId = _extractSchedId(scannedText);

        if (schedId == "Unknown") {
          _showError('Invalid QR Code: schedId not found.');
        } else {
          await _saveScanData(schedId);
          setState(() {
            scannedSchedId = schedId; // Store scanned schedId for display
          });

          // Pause the camera
          await controller.pauseCamera();
        }
      } catch (e) {
        _showError('An error occurred: $e');
      }

      setState(() {
        isProcessing = false;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  /// Extract schedId from scanned data
  String _extractSchedId(String data) {
    final regExp = RegExp(r"code:\s*([^\n]+)");
    final match = regExp.firstMatch(data);
    return match != null && match.groupCount > 0
        ? match.group(1)!.trim()
        : "Unknown";
  }

  Future<void> _saveScanData(String schedId) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showError('User not authenticated.');
        return;
      }

      // Retrieve the student number and display name from the users collection
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        _showError('User document not found.');
        return;
      }

      final stud_num = userDoc['stud_num'] ?? 'N/A';
      final display_name = userDoc['display_name'] ?? 'Unknown';

      final scanDateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      // Save the attendance data including additional user info
      await FirebaseFirestore.instance.collection('attendance').add({
        'schedId': schedId,
        'scanDateTime': scanDateTime,
        'userId': user.uid,
        'studentNumber': stud_num,
        'displayName': display_name,
      });

      // Optional: Notify user that data was saved successfully
      _showError('Attendance marked successfully.');
    } catch (e) {
      _showError('Failed to save scan data: $e');
    }
  }

  /// Show error messages
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.red))),
    );
  }
}
