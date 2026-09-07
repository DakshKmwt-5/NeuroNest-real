import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertService {
  StreamSubscription? _subscription;
  bool isDialogShowing = false;

  AlertService();

  /// Listens for patient emergency events.
  /// Firestore stream is currently mocked until Firebase options are configured.
  StreamSubscription? listenForEmergencies(BuildContext context) {
    debugPrint('MOCK: AlertService listening initialized. Firestore bypassed.');
    // Future.delayed(const Duration(seconds: 10), () {
    //   debugPrint("MOCK ALERT: Testing alert dialog in 10 seconds");
    //   if (context.mounted) {
    //     showEmergencyDialog(context);
    //   }
    // });

    // TODO: Uncomment once Firebase project is configured with web options:
    // _subscription = FirebaseFirestore.instance
    //     .collection('patients')
    //     .doc('current_patient')
    //     .snapshots()
    //     .listen((snapshot) {
    //   if (!snapshot.exists || snapshot.data() == null) return;
    //   final data = snapshot.data() as Map<String, dynamic>;
    //   if (data['isOutOfZone'] == true) {
    //     debugPrint('CRITICAL ALERT: PATIENT WANDERING DETECTED!');
    //     if (!isDialogShowing && context.mounted) {
    //       showEmergencyDialog(context);
    //     }
    //   }
    // });

    return _subscription;
  }

  /// Displays a prominent, full-featured emergency alert dialog
  void showEmergencyDialog(BuildContext context) {
    if (isDialogShowing) return;
    isDialogShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE), // Light red alert background
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.red, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withAlpha(90),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Flashing emergency icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(40),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Critical Alert Title
                Text(
                  'CRITICAL ALERT',
                  style: GoogleFonts.baloo2(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFFB71C1C),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),

                // Alert Description
                Text(
                  'Patient has left the Safe Zone!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFC62828),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Real-time GPS indicates that the patient has wandered outside their designated safe perimeter. Please contact or locate them immediately.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    // Acknowledge / Dismiss Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          isDialogShowing = false;
                          Navigator.of(dialogContext).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Acknowledge',
                          style: GoogleFonts.baloo2(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD32F2F),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Call Patient Immediately Button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          isDialogShowing = false;
                          Navigator.of(dialogContext).pop();
                          final Uri telUri = Uri(scheme: 'tel', path: '+1234567890');
                          if (await canLaunchUrl(telUri)) {
                            await launchUrl(telUri);
                          }
                        },
                        icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18),
                        label: Text(
                          'Call Patient',
                          style: GoogleFonts.baloo2(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      isDialogShowing = false;
    });
  }

  /// Cancels any active subscription
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    isDialogShowing = false;
  }
}
