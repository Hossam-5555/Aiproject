import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wep/controller/authcontroller.dart';
import 'package:wep/view/widget/Coustumtextform.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: controller.regKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_add_outlined,
                        size: 48,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Sign up to get started with ChatMania",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  // Username Field
                  CustomTextFormField(
                    controller: controller.username,
                    labelText: "Username",
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Username is required";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Email Field
                  CustomTextFormField(
                    controller: controller.email,
                    labelText: "Email",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      }
                      if (!GetUtils.isEmail(value.trim())) {
                        return "Invalid email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  Obx(
                    () => CustomTextFormField(
                      controller: controller.password,
                      labelText: "Password",
                      prefixIcon: Icons.lock_outline_rounded,
                      obscureText: controller.obscure.value,
                      suffixIcon: IconButton(
                        onPressed: controller.togglePassword,
                        icon: Icon(
                          controller.obscure.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Gender Title
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      "Gender",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),

                  // Gender Selection Cards
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: controller.gender.value == "Male"
                                    ? theme.primaryColor
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: RadioListTile<String>(
                              title: const Text(
                                "Male",
                                style: TextStyle(fontSize: 14),
                              ),
                              value: "Male",
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              groupValue: controller.gender.value,
                              onChanged: (value) =>
                                  controller.changeGender(value!),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: controller.gender.value == "Female"
                                    ? theme.primaryColor
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: RadioListTile<String>(
                              title: const Text(
                                "Female",
                                style: TextStyle(fontSize: 14),
                              ),
                              value: "Female",
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              groupValue: controller.gender.value,
                              onChanged: (value) =>
                                  controller.changeGender(value!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Register Button
                  GetBuilder<AuthController>(
                    builder: (controller) => controller.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () {
                                if (controller.regKey.currentState!
                                    .validate()) {
                                  controller.register();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  // Login Redirection Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.find<AuthController>().toggleAuthView();
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
