import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuronest/theme/app_theme.dart';
import 'package:neuronest/widgets/widgets.dart';

/// Screen allowing caregivers to edit patient profile details.
class EditPatientProfileScreen extends StatelessWidget {
  const EditPatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.text),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Edit Patient Profile',
          style: GoogleFonts.baloo2(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 46,
                    backgroundColor: AppColors.accent,
                    child: Icon(
                      Icons.person_rounded,
                      size: 52,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const CustomTextField(
              label: 'Patient Name',
              hint: 'e.g. Robert Smith',
              initialValue: 'Robert Smith',
              prefixIcon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Age',
              hint: 'e.g. 72',
              initialValue: '72',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.cake_outlined,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Emergency Contact',
              hint: 'e.g. Sarah (Daughter) - (555) 019-2831',
              initialValue: 'Sarah (Daughter) - (555) 019-2831',
              prefixIcon: Icons.phone_outlined,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Medical Notes',
              hint: 'e.g. Mindful of afternoon routine...',
              initialValue: 'No known severe allergies. Mindful of afternoon routine.',
              maxLines: 3,
              prefixIcon: Icons.note_alt_outlined,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Save Changes',
              icon: Icons.save_rounded,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Patient profile updated successfully!'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
                Navigator.of(context).maybePop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
