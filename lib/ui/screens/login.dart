import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resep/services/auth_services.dart';
import 'package:resep/ui/screens/home.dart';
import 'package:resep/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  Future<void> saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Theme(
      data: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          bodyMedium: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: GoogleFonts.ubuntu(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.white70),
          errorStyle: const TextStyle(color: Colors.red),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white, width: 3),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white, width: 3),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red, width: 3),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red, width: 3),
          ),
        ),
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF6F6F6), Color(0xFFACDDB5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: l10n.appName,
                                style: GoogleFonts.ubuntu(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF02480F),
                                ),
                              ),
                              const TextSpan(text: '\n'),
                              TextSpan(
                                text: l10n.subtitle,
                                style: GoogleFonts.ubuntu(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF02480F),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          l10n.description,
                          style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF02480F),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Image.asset(
                          'assets/logo.png',
                          width: 295,
                          height: 283,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        _AuthButton(
                          text: l10n.createAccountButton,
                          color: const Color(0xFF02480F),
                          textColor: const Color(0xFFFFFFFF),
                          onTap: () => _showAuthModal(context, isLogin: false),
                          width: 296,
                          height: 50,
                          borderRadius: 30,
                        ),
                        _AuthButton(
                          text: l10n.loginButton,
                          color: Colors.white,
                          textColor: const Color(0xFF02480F),
                          borderColor: const Color(0xFF02480F),
                          onTap: () => _showAuthModal(context, isLogin: true),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: PopupMenuButton<Locale>(
                    icon: Icon(Icons.language, color: Color(0xFF02480F)),
                    onSelected: (Locale locale) {
                      Get.updateLocale(locale);
                      saveLocale(locale.languageCode);
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<Locale>(
                        value: const Locale('en'),
                        child: Row(
                          children: [
                            const Text('🇺🇸'),
                            const SizedBox(width: 8),
                            Text(l10n.languageEnglish),
                          ],
                        ),
                      ),
                      PopupMenuItem<Locale>(
                        value: const Locale('id'),
                        child: Row(
                          children: [
                            const Text('🇮🇩'),
                            const SizedBox(width: 8),
                            Text(l10n.languageIndonesian),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAuthModal(BuildContext context, {required bool isLogin}) {
    final l10n = AppLocalizations.of(context)!;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final nameController = TextEditingController();
    final bioController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    bool obscurePassword = true;
    bool obscureConfirmPassword = true;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      backgroundColor: const Color(0xFFB6EDC0),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            passwordController.addListener(() {
              if (confirmPasswordController.text.isNotEmpty) setState(() {});
            });

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLogin ? l10n.loginButton : l10n.createAccountButton,
                        style: GoogleFonts.ubuntu(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF02480F),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _AuthTextField(
                        controller: emailController,
                        label: l10n.emailLabel,
                        hint: l10n.emailHint,
                        prefixIcon: Icons.email_outlined,
                        validator: (value) => value == null || value.isEmpty
                            ? l10n.emailEmptyError
                            : !RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)
                            ? l10n.emailInvalidError
                            : null,
                      ),
                      if (!isLogin) ...[
                        const SizedBox(height: 20),
                        _AuthTextField(
                          controller: nameController,
                          label: l10n.nameLabel,
                          hint: l10n.nameHint,
                          prefixIcon: Icons.person_outline,
                          validator: (value) => value == null || value.isEmpty
                              ? l10n.nameEmptyError
                              : null,
                        ),
                        const SizedBox(height: 20),
                        _AuthTextField(
                          controller: bioController,
                          label: l10n.bioLabel,
                          hint: l10n.bioHint,
                          prefixIcon: Icons.info_outline,
                          validator: (value) => value == null || value.isEmpty
                              ? l10n.bioEmptyError
                              : null,
                        ),
                      ],
                      const SizedBox(height: 20),
                      _AuthTextField(
                        controller: passwordController,
                        label: l10n.passwordLabel,
                        hint: l10n.passwordHint,
                        prefixIcon: Icons.lock_outline,
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.black,
                          ),
                          onPressed: () => setState(
                            () => obscurePassword = !obscurePassword,
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? l10n.passwordEmptyError
                            : value.length < 6
                            ? l10n.passwordMinLengthError
                            : null,
                      ),
                      if (!isLogin) ...[
                        const SizedBox(height: 20),
                        _AuthTextField(
                          controller: confirmPasswordController,
                          label: l10n.confirmPasswordLabel,
                          hint: l10n.confirmPasswordHint,
                          prefixIcon: Icons.lock_outline,
                          obscureText: obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () => setState(
                              () => obscureConfirmPassword =
                                  !obscureConfirmPassword,
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? l10n.confirmPasswordEmptyError
                              : value != passwordController.text
                              ? l10n.confirmPasswordMismatchError
                              : null,
                        ),
                      ],
                      const SizedBox(height: 20),
                      _AuthButton(
                        text: isLogin ? l10n.loginButton : l10n.createAccountButton,
                        color: Colors.white,
                        textColor: const Color(0xFF02480F),
                        isLoading: isLoading,
                        onTap: isLoading
                            ? null
                            : () async {
                                if (formKey.currentState!.validate()) {
                                  setState(() => isLoading = true);
                                  try {
                                    final service = SupabaseService();
                                    if (isLogin) {
                                      await service.login(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      );
                                    } else {
                                      await service.register(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                        bio: bioController.text,
                                      );
                                    }
                                    Get.off(() => const HomeScreen());
                                  } catch (e) {
                                    setState(() => isLoading = false);
                                    if (isLogin &&
                                        (e.toString().contains(
                                              'invalid credentials',
                                            ) ||
                                            e.toString().contains(
                                              'Invalid login credentials',
                                            ))) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            l10n.loginFailedTitle,
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF02480F),
                                            ),
                                          ),
                                          content: Text(
                                            l10n.loginFailedContent,
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 16,
                                              color: const Color(0xFF02480F),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                l10n.ok,
                                                style: GoogleFonts.ubuntu(
                                                  fontSize: 16,
                                                  color: const Color(
                                                    0xFF02480F,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (!isLogin &&
                                        (e.toString().contains(
                                              'email already exists',
                                            ) ||
                                            e.toString().contains(
                                              'Email already registered',
                                            ))) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            l10n.registerFailedTitle,
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF02480F),
                                            ),
                                          ),
                                          content: Text(
                                            l10n.registerFailedContent,
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 16,
                                              color: const Color(0xFF02480F),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                l10n.ok,
                                                style: GoogleFonts.ubuntu(
                                                  fontSize: 16,
                                                  color: const Color(
                                                    0xFF02480F,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            l10n.genericErrorTitle,
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF02480F),
                                            ),
                                          ),
                                          content: Text(
                                            l10n.genericErrorContent,
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 16,
                                              color: const Color(0xFF02480F),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text(
                                                l10n.ok,
                                                style: GoogleFonts.ubuntu(
                                                  fontSize: 16,
                                                  color: const Color(
                                                    0xFF02480F,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                } else {
                                  setState(() {});
                                }
                              },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLogin
                                ? l10n.switchAuthTextLogin
                                : l10n.switchAuthTextRegister,
                            style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              color: const Color(0xFF02480F),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _showAuthModal(context, isLogin: !isLogin);
                            },
                            child: Text(
                              l10n.switchAuthButton,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _AuthTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: GoogleFonts.ubuntu(
          color: const Color(0xFF02480F),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.ubuntu(
            color: const Color(0xFF02480F).withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          hintStyle: GoogleFonts.ubuntu(
            color: const Color(0xFF02480F).withOpacity(0.5),
            fontSize: 14,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: const Color(0xFF02480F).withOpacity(0.7),
                  size: 24,
                )
              : null,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: const Color(0xFF02480F).withOpacity(0.3),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF02480F), width: 2.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 2.5),
          ),
          errorStyle: GoogleFonts.ubuntu(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final bool isLoading;
  final VoidCallback? onTap;
  final double width;
  final double height;
  final double borderRadius;

  const _AuthButton({
    required this.text,
    required this.color,
    required this.textColor,
    this.borderColor,
    this.isLoading = false,
    this.onTap,
    this.width = 296,
    this.height = 50,
    this.borderRadius = 30,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 3)
              : null,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 5,
              spreadRadius: 0,
              color: Color(0xFF00000040),
            ),
          ],
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Color(0xFF02480F))
            : Text(
                text,
                style: GoogleFonts.ubuntu(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}