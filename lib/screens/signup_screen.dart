import 'package:bai5/dao/user_dao.dart';
import 'package:bai5/models/user.dart';
import 'package:bai5/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static String SIGN_UP_SCREEN = '/signUpScreen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isRemember = false;
  bool _isShowPass = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();

  final UserDao _userDao = UserDao();

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      String username = _usernameController.text;

      // Kiểm tra xem tên người dùng đã tồn tại chưa
      bool userExists = await _userDao.checkUserExists(username);

      if (userExists) {
        _showMessage('Username already exists. Please choose another one.');
        return; // Ngừng quá trình đăng ký nếu tài khoản đã tồn tại
      }

      User user = User(
        username: username,
        password: _passwordController.text,
        email: _emailAddressController.text,
      );

      bool isSuccessfully = await _userDao.registerUser(user);

      if (isSuccessfully) {
        _showSuccessMessage('User registered successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        _showMessage('Failed to register user');
      }
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại và chuyển hướng
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Sign Up\n',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Please enter your data to create an account',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
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
                          return 'Please enter some text';
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
                                  !_isShowPass; // Toggle password visibility
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
                          return 'Please enter some text';
                        }
                        if (value.length < 3) {
                          return 'Password too short';
                        } else if (value.length < 7) {
                          return 'Password is weak';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailAddressController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Email Address',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff525CB5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(107, 48),
                        backgroundColor: const Color(0xff4A4E69),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
