import 'package:get/get.dart';
import 'package:wep/controller/usercontroller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserController(), permanent: true);
  }
}
