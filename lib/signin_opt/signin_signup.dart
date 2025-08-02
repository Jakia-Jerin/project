import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:theme_desiree/signin_opt/profile_model.dart';
import 'package:theme_desiree/signin_opt/authcontroller.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final authController = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final contextTheme = FTheme.of(context);
    authController.fetchProfile;
    return Scaffold(
      backgroundColor: contextTheme.colorScheme.background,
      body: Column(
        children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FButton.icon(
                  onPress: () => Get.toNamed("/settings"),
                  style: FButtonStyle.outline,
                  child: FIcon(
                    FAssets.icons.chevronLeft,
                    size: 24,
                  ),
                ),
                Text(
                  'Profile'.tr.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          FDivider(
            style: contextTheme.dividerStyles.verticalStyle.copyWith(
              width: 1,
              padding: EdgeInsets.zero,
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header text changes based on mode
                  Obx(() {
                    if (authController.isLogin.value) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sign up or Log in',
                            style: contextTheme.typography.lg.copyWith(
                              height: 1,
                              fontWeight: FontWeight.bold,
                              color: contextTheme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select your preferred method to continue',
                            style: contextTheme.typography.sm,
                          ),
                          const SizedBox(height: 40),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Create new account',
                            style: contextTheme.typography.lg.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1,
                              color: contextTheme.colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    }
                  }),

                  Obx(() {
                    return Column(
                      children: [
                        // Sign Up extra fields: name and gender
                        if (!authController.isLogin.value) ...[
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 360),
                            child: FTextField(
                              onChange: (value) {
                                // Update the nameController's text if needed
                                authController.updateName(value);
                              },
                              initialValue:
                                  authController.profile.value?.name ?? "",
                              controller: authController.nameController,
                              hint: 'Enter your name *',
                              keyboardType: TextInputType.text,
                              prefixBuilder: (context, value, child) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: FIcon(FAssets.icons.userRoundPen),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 360),
                            child: FSelectMenuTile(
                              groupController: authController.genderController,
                              autoHide: false,
                              prefixIcon: FIcon(
                                FAssets.icons.baby,
                                size: 20,
                              ),
                              onSaved: (newValue) {
                                authController.updateGender(newValue!.first);
                              },
                              title: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  'Gender',
                                  style:
                                      FTheme.of(context).typography.sm.copyWith(
                                            color: FTheme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                ),
                              ),
                              details: ListenableBuilder(
                                listenable: authController.genderController,
                                builder: (context, _) => Text(
                                  switch (authController
                                      .genderController.value.firstOrNull) {
                                    Gender.male => 'Male',
                                    Gender.female => 'Female',
                                    Gender.other => 'Other',
                                    Gender.none || null => 'None',
                                  },
                                ),
                              ),
                              menu: [
                                FSelectTile(
                                  title: const Text('Male'),
                                  value: Gender.male,
                                ),
                                FSelectTile(
                                    title: const Text('Female'),
                                    value: Gender.female),
                                FSelectTile(
                                    title: const Text('Other'),
                                    value: Gender.other),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],

                        // Email input
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: FTextField(
                            onChange: (value) {
                              authController.updateEmail(value);
                            },
                               initialValue:
                                 authController.profile.value?.email.data ?? "",
                            controller: authController.emailController,
                            hint: 'Enter your email *',
                            keyboardType: TextInputType.text,
                            prefixBuilder: (context, value, child) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: FIcon(FAssets.icons.mail),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Password input
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: FTextField(
                            obscureText: true,
                            maxLines: 1,
                            controller: authController.passwordController,
                            hint: 'Enter password *',
                            keyboardType: TextInputType.text,
                            prefixBuilder: (context, value, child) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: FIcon(FAssets.icons.lock),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        //       const Text('OR'),
                        //     const SizedBox(height: 10),

                        // Phone input
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: FTextField(
                            onChange: (value) =>
                                authController.updatePhone(value),
                            initialValue:
                                authController.editedProfile.value?.phone.data,
                            controller: authController.phoneController,
                            hint: 'Enter phone number (optional)',
                            keyboardType: TextInputType.text,
                            prefixBuilder: (context, value, child) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              child: FIcon(FAssets.icons.phone),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Buttons row
                        Row(
                          children: [
                            Expanded(
                              child: FButton(
                                style:
                                    contextTheme.buttonStyles.primary.copyWith(
                                  contentStyle: contextTheme
                                      .buttonStyles.primary.contentStyle
                                      .copyWith(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                  ),
                                ),
                                onPress: () {
                                  if (authController.isLogin.value) {
                                    authController.login();
                                  } else {
                                    authController.signUp();
                                  }
                                },
                                label: Text(
                                  authController.isLogin.value
                                      ? 'Login'
                                      : 'Sign Up',
                                  style: contextTheme.typography.sm.copyWith(
                                    color: contextTheme.typography.sm.color,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: FButton(
                                style:
                                    contextTheme.buttonStyles.primary.copyWith(
                                  contentStyle: contextTheme
                                      .buttonStyles.primary.contentStyle
                                      .copyWith(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 12),
                                  ),
                                ),
                                onPress: authController.toggleLoginSignUp,
                                label: Text(
                                  authController.isLogin.value
                                      ? 'Go to Sign Up'
                                      : 'Go to Login',
                                  style: contextTheme.typography.sm.copyWith(
                                    color: contextTheme.typography.sm.color,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
