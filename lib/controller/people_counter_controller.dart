
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wep/core/services/ai_srvices.dart';


class PeopleCounterController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final PeopleDetectionService _service = PeopleDetectionService();

  final RxBool isLoading = false.obs;
  final RxInt peopleCount = 0.obs;
  final RxList<Map<String, dynamic>> detections =
      <Map<String, dynamic>>[].obs;
  final RxString errorMessage = ''.obs;


final Rx<File?> selectedImage = Rx<File?>(null);

Future<void> pickImage() async {
  final image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    selectedImage.value = File(image.path);
    peopleCount.value = 0;
    detections.clear();
    errorMessage.value = '';
  }
}

Future<void> takePhoto() async {
  final image = await _picker.pickImage(source: ImageSource.camera);

  if (image != null) {
    selectedImage.value = File(image.path);
    peopleCount.value = 0;
    detections.clear();
    errorMessage.value = '';
  }
}

  void removeImage() {
    selectedImage.value = null;
    peopleCount.value = 0;
    detections.clear();
    errorMessage.value = '';
  }

  Future<void> analyzeImage() async {
    if (selectedImage.value == null) {
      errorMessage.value = 'Please select an image first.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      detections.clear();
      peopleCount.value = 0;

      final result = await _service.detectPeople(
        File(selectedImage.value!.path),
      );

      final predictions = result['predictions'];

      if (predictions is! List) {
        throw Exception('Unexpected response from Roboflow.');
      }

      final people = predictions
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .where((item) {
            final className =
                (item['class'] ?? '').toString().toLowerCase();

            return className == 'person';
          })
          .toList();

      detections.assignAll(people);
      peopleCount.value = people.length;
    } catch (e) {
      errorMessage.value = 'Analysis failed: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
