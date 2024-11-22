import 'package:bai5/screens/login_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();

    // Chờ 3 giây trước khi chuyển sang màn hình tiếp theo
    Future.delayed(const Duration(seconds: 3), () {
      // Chuyển đến màn hình LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f5f7), // Màu nền nhẹ nhàng
      body: Center( // Căn giữa toàn bộ nội dung của màn hình
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Khoảng cách giữa các phần tử
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa theo chiều dọc
            crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều ngang
            children: [
              const Text(
                'Tống Doanh Chính - PH40493',
                style: TextStyle(
                  fontSize: 20, // Kích thước chữ lớn
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4A4E69), // Màu chữ đẹp
                  letterSpacing: 1.2, // Khoảng cách giữa các chữ
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(15), // Bo góc cho ảnh
                child: Image.asset(
                  'assets/images/img2.png', // Hình ảnh chào mừng
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover, // Đảm bảo hình ảnh đầy đủ mà không bị biến dạng
                ),
              ),
              const SizedBox(height: 30),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xff4A4E69)),
                strokeWidth: 6.0, // Độ dày vòng tròn
              ),
            ],
          ),
        ),
      ),
    );
  }
}
