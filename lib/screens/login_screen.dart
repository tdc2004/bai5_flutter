import 'package:bai5/dao/user_dao.dart';
import 'package:bai5/main.dart'; // Đảm bảo NavigatorApp đã được khai báo trong main.dart
import 'package:bai5/screens/signup_screen.dart';
import 'package:bai5/widgets/show_message.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  // ignore: non_constant_identifier_names
  static String LOGIN_SCREEN = '/loginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignUpState();
}

class _SignUpState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isRemember = false;
  bool _isShowPass = true;

  UserDao userDao = UserDao();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(  // Thêm Center để căn giữa toàn bộ nội dung của màn hình
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Đảm bảo căn giữa
            crossAxisAlignment: CrossAxisAlignment.center, // Đảm bảo căn giữa theo chiều ngang
            children: [
              RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                      text: 'WelCome\n',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      children: [
                        TextSpan(
                            text: 'Please enter your data to continue',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey))
                      ])),
              const SizedBox(height: 30),
              
              const SizedBox(height: 20),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Username',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';  // Hiển thị khi không nhập username
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                          controller: _passwordController,
                          obscureText: _isShowPass,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isShowPass =
                                      !_isShowPass; // Thay đổi trạng thái ẩn/hiện mật khẩu
                                });
                              },
                              icon: Icon(
                                _isShowPass ? Icons.remove_red_eye : Icons.key,
                              ),
                            ),
                            icon: const Icon(Icons.keyboard),
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';  // Hiển thị khi không nhập password
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.topRight,
                        child: const Text('Forgot password?',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Color(0xff525CB5), fontSize: 15)),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Remember me',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Switch(
                              value: _isRemember,
                              onChanged: (value) {
                                setState(() {
                                  _isRemember = value;
                                });
                              })
                        ],
                      ),
                    ],
                  )),
              const SizedBox(height: 10),
// Thêm phần chuyển đến màn hình đăng ký trước nút Login
              GestureDetector(
                onTap: () {
                  // Chuyển đến màn hình đăng ký
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: const Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff525CB5),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool isLoginSucess = await userDao.checkLogin(
                          _usernameController.text, _passwordController.text);
                      if (isLoginSucess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NavigatorApp()),
                        );
                      } else {
                        showMessage(context, 'Failed to login user');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(107, 48),
                      backgroundColor: const Color(0xff4A4E69),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
