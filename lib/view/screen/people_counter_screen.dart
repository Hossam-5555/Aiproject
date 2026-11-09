import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wep/core/conistant/app_colors.dart';

import '../../../controller/people_counter_controller.dart';

class PeopleCounterScreen extends StatelessWidget {
  PeopleCounterScreen({super.key});

  final PeopleCounterController controller = Get.put(PeopleCounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildTitle(),
              const SizedBox(height: 24),
              Expanded(child: _buildImageArea()),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.peopleCount.value == 0 &&
                    controller.errorMessage.isEmpty) {
                  return const SizedBox.shrink();
                }

                if (controller.errorMessage.isNotEmpty) {
                  return Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.redAccent),
                  );
                }

                return Text(
                  'Detected People: ${controller.peopleCount.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
              _buildActions(),
              const SizedBox(height: 20),
              _buildAnalyzeButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(
            Icons.groups_rounded,
            color: AppColors.secondary,
            size: 25,
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'VISION AI',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'Smart People Detection',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.secondary.withAlpha(20),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.circle, color: AppColors.secondary, size: 7),
              SizedBox(width: 6),
              Text(
                'AI READY',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Count people\nwith AI.',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 34,
            height: 1.15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Upload an image and let AI detect every person in it.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildImageArea() {
    return Obx(() {
      final File? image = controller.selectedImage.value;

      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: image == null
            ? _buildEmptyImage()
            : _buildSelectedImage(image),
      );
    });
  }

  Widget _buildEmptyImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add_a_photo_outlined,
            color: AppColors.primary,
            size: 38,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'No image selected',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose or capture an image to get started',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 20),
        const Icon(
          Icons.keyboard_double_arrow_down_rounded,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }

  Widget _buildSelectedImage(File image) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(image, fit: BoxFit.contain),
        Positioned(
          top: 12,
          right: 12,
          child: IconButton(
            onPressed: controller.removeImage,
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withAlpha(150),
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.close_rounded),
          ),
        ),
        Positioned(
          left: 12,
          bottom: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(160),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'IMAGE SELECTED',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            icon: Icons.photo_library_outlined,
            title: 'Gallery',
            onTap: controller.pickImage,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionButton(
            icon: Icons.camera_alt_outlined,
            title: 'Camera',
            onTap: controller.takePhoto,
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 19),
      label: Text(title),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.border),
        minimumSize: const Size(0, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return Obx(() {
      final bool hasImage = controller.selectedImage.value != null;

      return SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: hasImage ? controller.analyzeImage : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.card,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome_rounded),
                    SizedBox(width: 10),
                    Text(
                      'Analyze Image',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
        ),
      );
    });
  }
}
