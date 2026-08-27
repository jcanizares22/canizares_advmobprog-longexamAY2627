import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_textformfield.dart';
import '../widgets/custom_dialogs.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mobilenumController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) {
      customDialog(
        context,
        title: "Invalid Input",
        content: "Please fill in all fields correctly.",
      );
      return;
    }

    final error = await context.read<AuthProvider>().register(
      firstName: firstnameController.text.trim(),
      lastName: lastnameController.text.trim(),
      username: usernameController.text.trim(),
      mobileNumber: mobilenumController.text.trim(),
      password: passwordController.text,
    );
    if (!mounted) return;
    if (error != null) {
      customDialog(context, title: 'Registration failed', content: error);
      return;
    }
    Navigator.popAndPushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(25.w, 40.h, 25.w, 10.h),
              child: Column(
                children: [
                  SizedBox(height: 25.h),

                  CustomFont(
                    text: 'Register Here',
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 240, 7, 7),
                  ),

                  SizedBox(height: 25.h),

                  /// FIRST NAME
                  CustomTextFormField(
                    controller: firstnameController,
                    hintText: 'First name',
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                    onSaved: (_) {},
                    fontSize: 15.sp,
                    fontColor: Colors.black,
                    hintTextSize: 15.sp,
                    height: 12.h,
                    width: 12.w,
                    borderColor: Color.fromARGB(255, 240, 7, 7),
                  ),

                  SizedBox(height: 10.h),

                  /// LAST NAME
                  CustomTextFormField(
                    controller: lastnameController,
                    hintText: 'Last name',
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                    onSaved: (_) {},
                    fontSize: 15.sp,
                    fontColor: Colors.black,
                    hintTextSize: 15.sp,
                    height: 12.h,
                    width: 12.w,
                    borderColor: Color.fromARGB(255, 240, 7, 7),
                  ),

                  SizedBox(height: 10.h),

                  /// USERNAME
                  CustomTextFormField(
                    controller: usernameController,
                    hintText: 'Username',
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                    onSaved: (_) {},
                    fontSize: 15.sp,
                    fontColor: Colors.black,
                    hintTextSize: 15.sp,
                    height: 12.h,
                    width: 12.w,
                    borderColor: Color.fromARGB(255, 240, 7, 7),
                  ),

                  SizedBox(height: 10.h),

                  /// MOBILE NUMBER
                  CustomTextFormField(
                    controller: mobilenumController,
                    hintText: 'Mobile Number',
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    validator: (value) =>
                        value!.length != 11 ? 'Invalid number' : null,
                    onSaved: (_) {},
                    fontSize: 15.sp,
                    fontColor: Colors.black,
                    hintTextSize: 15.sp,
                    height: 12.h,
                    width: 12.w,
                    borderColor: Color.fromARGB(255, 240, 7, 7),
                  ),

                  SizedBox(height: 10.h),

                  /// PASSWORD
                  CustomTextFormField(
                    controller: passwordController,
                    hintText: 'Password',
                    isObscure: true,
                    validator: (value) =>
                        value!.length < 8 ? 'Minimum 8 characters' : null,
                    onSaved: (_) {},
                    fontSize: 15.sp,
                    fontColor: Colors.black,
                    hintTextSize: 15.sp,
                    height: 12.h,
                    width: 12.w,
                    borderColor: Color.fromARGB(255, 240, 7, 7),
                  ),

                  SizedBox(height: 5.h),

                  Text(
                    '(Password should be at least 8 characters.)',
                    style: TextStyle(color: Colors.black45, fontSize: 10.sp),
                  ),

                  SizedBox(height: 10.h),

                  /// CONFIRM PASSWORD
                  CustomTextFormField(
                    controller: confirmpasswordController,
                    hintText: 'Confirm Password',
                    isObscure: true,
                    validator: (value) => value != passwordController.text
                        ? 'Passwords do not match'
                        : null,
                    onSaved: (_) {},
                    fontSize: 15.sp,
                    fontColor: Colors.black,
                    hintTextSize: 15.sp,
                    height: 12.h,
                    width: 12.w,
                    borderColor: Color.fromARGB(255, 240, 7, 7),
                  ),

                  const Spacer(),

                  /// LOGIN LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You have an account? ',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 15.sp,
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.popAndPushNamed(context, '/login'),
                        child: Text(
                          'Login here',
                          style: TextStyle(
                            color: Color.fromARGB(255, 240, 7, 7),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  /// SUBMIT BUTTON
                  CustomInkwellButton(
                    onTap: register,
                    height: 45.h,
                    width: ScreenUtil().screenWidth,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    buttonName: 'Submit',
                    bgColor: Color.fromARGB(255, 240, 7, 7),
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
