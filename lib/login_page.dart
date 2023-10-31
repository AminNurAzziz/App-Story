import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:story/list_story.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String message = '';
  String? authToken; // Menyimpan token otentikasi
  String? name;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final url = Uri.parse('https://story-api.dicoding.dev/v1/login');

    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      url,
      body: {
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final loginResult = responseData['loginResult'];
      name = loginResult['name']; // Ini adalah nama pengguna
      if (responseData['error'] == false) {
        setState(() {
          message = 'Login berhasil: ${name}';
          authToken = loginResult['token'];
          name = loginResult['name'];
        });
        _showSuccessDialog();
        // Navigasi ke halaman ListStory setelah berhasil login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ListStory(authToken: authToken, name: name),
          ),
        );
      } else {
        setState(() {
          message = 'Login gagal: ${responseData['message']}';
        });
        _showErrorDialog();
      }
    } else if (response.statusCode == 401) {
      setState(() {
        message = 'Login gagal: Otentikasi gagal';
      });
      _showErrorDialog();
    } else {
      setState(() {
        message = 'Terjadi kesalahan saat login: ${response.statusCode}';
      });
      _showErrorDialog();
    }
  }

  // Method untuk menampilkan dialog sukses
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sukses'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  // Method untuk menampilkan dialog kesalahan
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 241, 249, 255),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(10 * _controller.value, 0),
                      child: Image.asset('assets/5340752.jpg'),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sudah siap untuk berbagi cerita?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Masukkan datamu dulu ya',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 71, 73, 77),
                        ),
                      ),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          prefixIconConstraints: BoxConstraints(
                            maxHeight: 32,
                            maxWidth: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 71, 73, 77),
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          prefixIconConstraints: BoxConstraints(
                            maxHeight: 32,
                            maxWidth: 32,
                          ),
                          suffixIcon: Icon(Icons.visibility),
                          suffixIconConstraints: BoxConstraints(
                            maxHeight: 32,
                            maxWidth: 32,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () {
                            loginUser();
                          },
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Text('Login'),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF1A1A1A),
                            onPrimary: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            minimumSize: Size(double.infinity, 40),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
