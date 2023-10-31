// import 'package:flutter/material.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({Key? key}) : super(key: key);

//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 2), // Atur durasi animasi
//     )..repeat(reverse: true); // Membuat animasi berulang dengan berbalik arah
//   }

//   @override
//   void dispose() {
//     _controller.dispose(); // Hapus controller saat widget di dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Color.fromARGB(255, 241, 249, 255),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 AnimatedBuilder(
//                   animation: _controller,
//                   builder: (context, child) {
//                     return Transform.translate(
//                       offset: Offset(10 * _controller.value, 0),
//                       child: Image.asset('assets/5340752.jpg'),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   width: double.infinity,
//                   margin: const EdgeInsets.symmetric(horizontal: 40),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Lengkapilah data dirimu di bawah ini ya !',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         'Nama',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: const Color.fromARGB(255, 71, 73, 77),
//                         ),
//                       ),
//                       TextField(
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.person),
//                           prefixIconConstraints: BoxConstraints(
//                             maxHeight: 32,
//                             maxWidth: 32,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Text(
//                         'Email',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: const Color.fromARGB(255, 71, 73, 77),
//                         ),
//                       ),
//                       TextField(
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.email),
//                           prefixIconConstraints: BoxConstraints(
//                             maxHeight: 32,
//                             maxWidth: 32,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Text(
//                         'Password',
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: const Color.fromARGB(255, 71, 73, 77),
//                         ),
//                       ),
//                       TextField(
//                         obscureText:
//                             true, // Ini akan menyembunyikan teks input sebagai karakter tersembunyi
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.lock),
//                           prefixIconConstraints: BoxConstraints(
//                             maxHeight: 32,
//                             maxWidth: 32,
//                           ),
//                           suffixIcon: Icon(Icons
//                               .visibility), // Icon tanda centang di sebelah kanan
//                           suffixIconConstraints: BoxConstraints(
//                             maxHeight: 32,
//                             maxWidth: 32,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       Align(
//                         alignment: Alignment.center,
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           child: Text('Daftar'),
//                           style: ElevatedButton.styleFrom(
//                             primary: Color(0xFF1A1A1A),
//                             onPrimary: Colors.white,
//                             padding: EdgeInsets.symmetric(
//                                 horizontal:
//                                     20), // Atur padding sesuai kebutuhan
//                             minimumSize: Size(double.infinity,
//                                 40), // Ini yang membuat tombol full width
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String message = '';

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

  Future<void> registerUser() async {
    final url = Uri.parse('https://story-api.dicoding.dev/v1/register');

    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      url,
      body: {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      },
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      if (responseData['error'] == false) {
        setState(() {
          message = 'Pendaftaran berhasil: ${responseData['message']}';
        });
        _showSuccessDialog();
      } else {
        setState(() {
          message = 'Pendaftaran gagal: ${responseData['message']}';
        });
        _showErrorDialog();
      }
    } else {
      setState(() {
        message = 'Pendaftaran gagal: ${response.statusCode}';
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
                        'Lengkapilah data dirimu di bawah ini ya !',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Nama',
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color.fromARGB(255, 71, 73, 77),
                        ),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          prefixIconConstraints: BoxConstraints(
                            maxHeight: 32,
                            maxWidth: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
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
                            registerUser();
                          },
                          child: isLoading
                              ? CircularProgressIndicator()
                              : Text('Daftar'),
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
